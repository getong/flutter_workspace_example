use anyhow::Result;
use std::str::FromStr;
use sui_sdk::{SuiClientBuilder, types::base_types::SuiAddress};

#[derive(Debug, Clone)]
pub struct SuiDemoRequest {
    pub rpc_url: String,
    pub wallet_address: String,
}

#[derive(Debug, Clone)]
pub struct SuiDemoResult {
    pub rpc_url: String,
    pub wallet_address: String,
    pub api_version: String,
    pub rpc_methods_count: String,
    pub current_epoch: String,
    pub reference_gas_price: String,
    pub active_validators: String,
    pub owned_objects_in_page: String,
    pub stake_position_count: String,
    pub explanation: String,
}

pub async fn fetch_sui_demo(request: SuiDemoRequest) -> Result<SuiDemoResult, String> {
    fetch_sui_demo_impl(request)
        .await
        .map_err(|error| error.to_string())
}

async fn fetch_sui_demo_impl(request: SuiDemoRequest) -> Result<SuiDemoResult> {
    let address = SuiAddress::from_str(&request.wallet_address)?;
    let client = SuiClientBuilder::default().build(&request.rpc_url).await?;

    let system_state = client
        .governance_api()
        .get_latest_sui_system_state()
        .await?;
    let reference_gas_price = client.governance_api().get_reference_gas_price().await?;
    let owned_objects = client
        .read_api()
        .get_owned_objects(address, None, None, None)
        .await?;
    let stakes = client.governance_api().get_stakes(address).await?;

    Ok(SuiDemoResult {
        rpc_url: request.rpc_url,
        wallet_address: request.wallet_address,
        api_version: client.api_version().to_string(),
        rpc_methods_count: client.available_rpc_methods().len().to_string(),
        current_epoch: system_state.epoch.to_string(),
        reference_gas_price: reference_gas_price.to_string(),
        active_validators: system_state.active_validators.len().to_string(),
        owned_objects_in_page: owned_objects.data.len().to_string(),
        stake_position_count: stakes.len().to_string(),
        explanation: String::from(
            "This demo uses flutter_rust_bridge to call Rust, and Rust uses the Sui Rust SDK to read Sui network information: API version, epoch state, gas price, owned object count, and staking positions for an address.",
        ),
    })
}
