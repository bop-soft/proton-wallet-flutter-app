import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wallet/helper/logger.dart';
import 'package:wallet/managers/providers/data.provider.manager.dart';
import 'package:wallet/models/drift/db/app.database.dart';
import 'package:wallet/models/drift/user.keys.queries.dart';
import 'package:wallet/models/drift/users.queries.dart';
import 'package:wallet/rust/api/api_service/proton_users_client.dart';
import 'package:wallet/rust/proton_api/proton_users.dart';

class TwoFaUpdated extends DataUpdated<bool> {
  TwoFaUpdated({required bool updatedData}) : super(updatedData);
}

class RecoveryUpdated extends DataUpdated<bool> {
  RecoveryUpdated({required bool updatedData}) : super(updatedData);
}

class ShowWalletRecoveryUpdated extends DataUpdated<bool> {
  ShowWalletRecoveryUpdated({required bool updatedData}) : super(updatedData);
}

/// define proton wallet user to include user settings and
/// manage 2FA and recovery status
class ProtonWalletUser {
  ProtonUser? protonUser;
  ProtonUserSettings? protonUserSettings;
  bool enabled2FA;
  bool enabledRecovery;

  ProtonWalletUser({
    this.enabled2FA = false,
    this.enabledRecovery = false,
  });
}

class UserDataProvider extends DataProvider {
  /// proton wallet user
  late ProtonWalletUser user;

  /// api client
  final ProtonUsersClient protonUsersClient;

  /// drift queries
  final UserQueries userQueries;
  final UserKeysQueries userKeysQueries;

  /// stream
  final dataUpdateController = StreamController<DataUpdated>();

  UserDataProvider(
    this.protonUsersClient,
    this.userQueries,
    this.userKeysQueries,
  ) {
    user = ProtonWalletUser();
  }

  Future<void> preLoad() async {
    /// needs to load UserSettings first
    /// since enabledRecovery will also consider
    /// `DeviceRecovery` in userSettings
    await syncProtonUserSettings(); // init Proton 2FA status
    await syncProtonUser(); // init Proton Recovery status
  }

  Future<void> syncProtonUser() async {
    user.protonUser = await protonUsersClient.getUserInfo();
    final status = user.protonUser?.mnemonicStatus;

    /// status codes:
    /// 0 - Mnemonic is disabled
    /// 1 - Mnemonic is enabled but not set
    /// 2 - Mnemonic is enabled but needs to be re-activated
    /// 3 - Mnemonic is enabled and set
    bool enabledRecovery = false;
    if (status == 3) {
      enabledRecovery = true;
    }
    if (!enabledRecovery) {
      /// check if user has enable device recovery, which is consider as other recovery method
      if (user.protonUserSettings != null) {
        if (user.protonUserSettings!.deviceRecovery == 1) {
          enabledRecovery = true;
        }
      }
    }
    if (enabledRecovery != user.enabledRecovery) {
      this.enabledRecovery(enabledRecovery);
    }
  }

  Future<void> syncProtonUserSettings() async {
    /// fetch user settings from server and update cache
    user.protonUserSettings = await protonUsersClient.getUserSettings();
    bool enabled2FA = false;
    if (user.protonUserSettings != null) {
      if (user.protonUserSettings!.twoFa != null) {
        enabled2FA = user.protonUserSettings!.twoFa!.enabled != 0;
      }
    }
    if (enabled2FA != user.enabled2FA) {
      this.enabled2FA(enabled2FA);
    }
  }

  void enabled2FA(enable) {
    user.enabled2FA = enable;
    emitState(TwoFaUpdated(updatedData: enable));
  }

  void enabledRecovery(enable) {
    user.enabledRecovery = enable;
    emitState(RecoveryUpdated(updatedData: enable));
  }

  void enabledShowWalletRecovery(enable) {
    emitState(ShowWalletRecoveryUpdated(updatedData: enable));
  }

  Future<List<DriftUserKey>> getUserKeys(String userID) async {
    var userKeys = await userKeysQueries.getUseKeys(userID);
    if (userKeys.isNotEmpty) {
      return userKeys;
    }
    await fetchFromServer(userID);
    userKeys = await userKeysQueries.getUseKeys(userID);
    if (userKeys.isNotEmpty) {
      return userKeys;
    }
    return [];
  }

  Future<DriftProtonUser?> getUser(String userID) async {
    var user = await userQueries.getUser(userID);
    if (user != null) {
      return user;
    }
    await fetchFromServer(userID);
    user = await userQueries.getUser(userID);
    if (user != null) {
      return user;
    }
    return null;
  }

  Future<void> fetchFromServer(String userID) async {
    final userinfo = await protonUsersClient.getUserInfo();

    if (userinfo.id != userID) {
      logger.e('User ID does not match');
      const Assert('User ID does not match');
    }

    userQueries.insertOrUpdateItem(DriftProtonUser(
        id: 0,
        userId: userinfo.id,
        name: userinfo.name ?? "",
        usedSpace: userinfo.usedSpace,
        currency: userinfo.currency,
        credit: userinfo.credit,
        createTime: userinfo.createTime,
        maxSpace: userinfo.maxSpace,
        maxUpload: userinfo.maxUpload,
        role: userinfo.role,
        private: userinfo.private,
        subscribed: userinfo.subscribed,
        services: userinfo.services,
        delinquent: userinfo.delinquent,
        organizationPrivateKey: userinfo.organizationPrivateKey,
        email: userinfo.email,
        displayName: userinfo.displayName));
    final keys = userinfo.keys;
    if (keys != null) {
      for (var key in keys) {
        userKeysQueries.insertOrUpdateItem(DriftUserKey(
          keyId: key.id,
          userId: userID,
          version: key.version,
          privateKey: key.privateKey,
          token: key.token,
          fingerprint: key.fingerprint,
          recoverySecret: key.recoverySecret,
          recoverySecretSignature: key.recoverySecretSignature,
          primary: key.primary,
        ));
      }
    }
  }

  @override
  Future<void> clear() async {
    userKeysQueries.clearTable();
    userQueries.clearTable();
    user = ProtonWalletUser();
    dataUpdateController.close();
  }

  @override
  Future<void> reload() async {}
}
