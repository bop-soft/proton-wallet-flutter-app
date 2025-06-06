import 'package:wallet/constants/constants.dart';
import 'package:wallet/helper/bdk/bdk.library.dart';
import 'package:wallet/helper/dbhelper.dart';
import 'package:wallet/managers/manager.dart';
import 'package:wallet/managers/preferences/preferences.keys.dart';
import 'package:wallet/managers/preferences/preferences.manager.dart';
import 'package:wallet/models/drift/db/app.database.dart';

class AppMigrationManager implements Manager {
  final PreferencesManager shared;

  AppMigrationManager(
    this.shared,
  );

  @override
  Future<void> dispose() async {}

  @override
  Future<void> init() async {
    /// force rebuild drift db
    await shared.checkif(
        PreferenceKeys.appDatabaseForceVersion, driftDatabaseVersion, () async {
      await rebuildDatabase();
    });

    /// force rebuild sqlite db
    await shared.checkif(
        PreferenceKeys.appDatabaseSqliteForceVersion, sqliteDatabaseVersion, () async {
      await DBHelper.reset();
    });

    /// remove bdk cache files to avoid migration issues in bdk@1.0.0-beta.4
    await shared
        .checkif(PreferenceKeys.appBDKDatabaseForceVersion, bdkDatabaseVersion,
            () async {
      await BdkLibrary().clearLocalCache();
    });
  }

  @override
  Future<void> login(String userID) async {}

  @override
  Future<void> logout() async {}

  @override
  Future<void> reload() async {}

  @override
  Priority getPriority() {
    return Priority.level2;
  }
}
