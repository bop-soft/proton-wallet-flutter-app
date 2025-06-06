use andromeda_api::{
    core::ApiClient,
    settings::{
        FiatCurrencySymbol as FiatCurrency, UserReceiveNotificationEmailTypes,
        UserSettings as ApiWalletUserSettings,
    },
};
use andromeda_common::BitcoinUnit;
use std::sync::Arc;

use super::proton_api_service::ProtonAPIService;
use crate::BridgeError;

pub struct SettingsClient {
    pub(crate) inner: Arc<andromeda_api::settings::SettingsClient>,
}

impl SettingsClient {
    pub fn new(service: &ProtonAPIService) -> SettingsClient {
        SettingsClient {
            inner: Arc::new(andromeda_api::settings::SettingsClient::new(
                service.inner.clone(),
            )),
        }
    }

    pub async fn get_user_settings(&self) -> Result<ApiWalletUserSettings, BridgeError> {
        let result = self.inner.get_user_settings().await?;
        Ok(result)
    }

    pub async fn bitcoin_unit(
        &self,
        symbol: BitcoinUnit,
    ) -> Result<ApiWalletUserSettings, BridgeError> {
        let result = self.inner.update_bitcoin_unit(symbol).await?;
        Ok(result)
    }

    pub async fn fiat_currency(
        &self,
        symbol: FiatCurrency,
    ) -> Result<ApiWalletUserSettings, BridgeError> {
        let result = self.inner.update_fiat_currency(symbol).await?;
        Ok(result)
    }

    pub async fn two_fa_threshold(
        &self,
        amount: u64,
    ) -> Result<ApiWalletUserSettings, BridgeError> {
        let result = self.inner.update_two_fa_threshold(amount).await?;
        Ok(result)
    }

    pub async fn hide_empty_used_addresses(
        &self,
        hide_empty_used_addresses: bool,
    ) -> Result<ApiWalletUserSettings, BridgeError> {
        let result = self
            .inner
            .update_hide_empty_used_addresses(hide_empty_used_addresses)
            .await?;
        Ok(result)
    }

    pub async fn receive_notification_email(
        &self,
        email_type: UserReceiveNotificationEmailTypes,
        is_enable: bool,
    ) -> Result<ApiWalletUserSettings, BridgeError> {
        let result = self
            .inner
            .update_receive_notification_email(email_type, is_enable)
            .await?;
        Ok(result)
    }

    pub async fn accept_terms_and_conditions(&self) -> Result<ApiWalletUserSettings, BridgeError> {
        let result = self.inner.accept_terms_and_conditions().await?;
        Ok(result)
    }

    pub async fn get_user_wallet_eligibility(&self) -> Result<u8, BridgeError> {
        let result = self.inner.get_user_wallet_eligibility().await?;
        Ok(result)
    }
}
