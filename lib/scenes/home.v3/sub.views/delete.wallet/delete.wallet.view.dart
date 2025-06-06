import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallet/constants/constants.dart';
import 'package:wallet/constants/proton.color.dart';
import 'package:wallet/constants/text.style.dart';
import 'package:wallet/helper/common.helper.dart';
import 'package:wallet/helper/extension/build.context.extension.dart';
import 'package:wallet/l10n/generated/locale.dart';
import 'package:wallet/managers/features/wallet/delete.wallet.bloc.dart';
import 'package:wallet/scenes/components/alert.custom.dart';
import 'package:wallet/scenes/components/button.v5.dart';
import 'package:wallet/scenes/components/button.v6.dart';
import 'package:wallet/scenes/components/close.button.v1.dart';
import 'package:wallet/scenes/components/custom.header.dart';
import 'package:wallet/scenes/components/page.layout.v1.dart';
import 'package:wallet/scenes/core/view.dart';
import 'package:wallet/scenes/home.v3/sub.views/delete.wallet/delete.wallet.viewmodel.dart';
import 'package:wallet/scenes/recovery/recovery.auth.dialog.dart';

class DeleteWalletView extends ViewBase<DeleteWalletViewModel> {
  const DeleteWalletView(DeleteWalletViewModel viewModel)
      : super(viewModel, const Key("DeleteWalletView"));

  @override
  Widget build(BuildContext context) {
    return PageLayoutV1(
      headerWidget: CustomHeader(
        buttonDirection: AxisDirection.right,
        padding: const EdgeInsets.all(0.0),
        button: CloseButtonV1(onPressed: () {
          Navigator.of(context).pop();
        }),
      ),
      child: BlocProvider.value(
        value: viewModel.deleteWalletBloc,
        child: BlocListener<DeleteWalletBloc, DeleteWalletState>(
          listener: (context, state) {
            if (state.deleted) {
              if (context.mounted) {
                Navigator.of(context).pop();
                if (!viewModel.triggerFromSidebar) {
                  /// sidebar only need popup once
                  Navigator.of(context).pop();
                }
                context.showSnackbar(context.local.wallet_deleted);
              }
            }
            if (state.error.isNotEmpty) {
              CommonHelper.showErrorDialog(state.error);
            }
            if (state.requireAuthModel.requireAuth) {
              showAuthBottomSheet(context, state.requireAuthModel.twofaStatus, (
                password,
                twofa,
              ) async {
                viewModel.deleteWalletAuth(
                  password,
                  twofa,
                );
              }, () {});
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.translate(
                offset: const Offset(0, -20),
                child: Column(children: [
                  context.images.deleteWarning.svg(
                    width: 48,
                    height: 48,
                    fit: BoxFit.fill,
                  ),
                  const SizedBox(height: defaultPadding),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            S.of(context).confirm_to_delete_wallet(
                                viewModel.walletMenuModel.walletName),
                            style: ProtonStyles.headline(
                              color: ProtonColors.textNorm,
                            ),
                            textAlign: TextAlign.center),
                        const SizedBox(height: defaultPadding),
                        if (viewModel.hasBalance)
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: defaultPadding),
                            child: AlertCustom(
                              content: S
                                  .of(context)
                                  .confirm_to_delete_wallet_has_balance_warning,
                              canClose: false,
                              border: Border.all(
                                color: Colors.transparent,
                                width: 0,
                              ),
                              backgroundColor:
                                  ProtonColors.notificationErrorBackground,
                              color: ProtonColors.notificationError,
                            ),
                          ),
                        Text(
                          S.of(context).confirm_to_delete_wallet_content,
                          textAlign: TextAlign.center,
                          style: ProtonStyles.body2Regular(
                              color: ProtonColors.textWeak),
                        ),
                        const SizedBox(height: 40),
                        BlocSelector<DeleteWalletBloc, DeleteWalletState, bool>(
                            selector: (state) {
                          return state.isLoading;
                        }, builder: (context, loading) {
                          return ButtonV5(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              viewModel.showSetupBackup();
                            },
                            enable: !loading,
                            text: S.of(context).backup_wallet,
                            width: context.width,
                            textStyle: ProtonStyles.body1Medium(
                              color: ProtonColors.textNorm,
                            ),
                            backgroundColor:
                                ProtonColors.interActionWeakDisable,
                            borderColor: ProtonColors.interActionWeakDisable,
                            height: 55,
                          );
                        }),
                        const SizedBox(height: 8),
                        BlocSelector<DeleteWalletBloc, DeleteWalletState, bool>(
                          selector: (state) {
                            return state.isLoading;
                          },
                          builder: (context, loading) {
                            return ButtonV6(
                              onPressed: () async {
                                if (!loading || !viewModel.isDeleting) {
                                  viewModel.isDeleting = true;
                                  viewModel.deleteWallet();
                                  viewModel.isDeleting = false;
                                }
                              },
                              isLoading: loading,
                              enable: !loading,
                              text: S.of(context).delete_wallet_now,
                              width: context.width,
                              backgroundColor: ProtonColors.notificationError,
                              borderColor: ProtonColors.notificationError,
                              textStyle: ProtonStyles.body1Medium(
                                color: ProtonColors.white,
                              ),
                              height: 55,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
