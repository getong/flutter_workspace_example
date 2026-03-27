use std::str::FromStr;

use sui_sdk::{types::base_types::SuiAddress, SuiClient, SuiClientBuilder};

#[derive(Clone, Debug)]
pub struct SuiNetworkMetrics {
    pub network: String,
    pub api_version: String,
    pub chain_identifier: String,
    pub latest_checkpoint: u64,
    pub latest_checkpoint_digest: String,
    pub latest_checkpoint_timestamp_ms: u64,
    pub latest_checkpoint_epoch: u64,
    pub network_total_transactions: u64,
}

#[flutter_rust_bridge::frb(sync)]
pub fn greet(name: String) -> String {
    let raw = name.trim();
    if raw.is_empty() {
        return "Address is empty".to_owned();
    }

    match SuiAddress::from_str(raw) {
        Ok(address) => format!("Normalized Sui address: {address}"),
        Err(error) => format!("Invalid Sui address: {error}"),
    }
}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}

pub fn hello(a: String) -> String {
    let target = a.trim().to_owned();
    if target.is_empty() {
        return "Network is empty. Use mainnet/testnet/devnet/localnet or a full RPC URL."
            .to_owned();
    }

    let runtime = match tokio::runtime::Builder::new_current_thread()
        .enable_all()
        .build()
    {
        Ok(runtime) => runtime,
        Err(error) => return format!("Failed to create Tokio runtime: {error}"),
    };

    runtime.block_on(async move {
        query_sui_api_version(&target)
            .await
            .unwrap_or_else(|message| message)
    })
}

pub fn fetch_sui_metrics(network: String) -> Result<SuiNetworkMetrics, String> {
    let target = network.trim().to_owned();
    if target.is_empty() {
        return Err(
            "Network is empty. Use mainnet/testnet/devnet/localnet or a full RPC URL.".to_owned(),
        );
    }

    let runtime = tokio::runtime::Builder::new_current_thread()
        .enable_all()
        .build()
        .map_err(|error| format!("Failed to create Tokio runtime: {error}"))?;

    runtime.block_on(async move { query_sui_metrics(&target).await })
}

async fn query_sui_api_version(target: &str) -> Result<String, String> {
    let (label, client) = build_client_for_target(target).await?;
    Ok(format!("{label} api_version: {}", client.api_version()))
}

async fn query_sui_metrics(target: &str) -> Result<SuiNetworkMetrics, String> {
    let (network, client) = build_client_for_target(target).await?;
    let api_version = client.api_version().to_owned();
    let read_api = client.read_api();

    let chain_identifier = read_api
        .get_chain_identifier()
        .await
        .map_err(|error| format!("Failed to fetch chain identifier from `{target}`: {error}"))?;

    let latest_checkpoint = read_api
        .get_latest_checkpoint_sequence_number()
        .await
        .map_err(|error| format!("Failed to fetch latest checkpoint from `{target}`: {error}"))?;

    let latest_checkpoint_data = read_api
        .get_checkpoint(latest_checkpoint.into())
        .await
        .map_err(|error| format!("Failed to fetch checkpoint detail from `{target}`: {error}"))?;

    Ok(SuiNetworkMetrics {
        network,
        api_version,
        chain_identifier,
        latest_checkpoint,
        latest_checkpoint_digest: latest_checkpoint_data.digest.to_string(),
        latest_checkpoint_timestamp_ms: latest_checkpoint_data.timestamp_ms,
        latest_checkpoint_epoch: latest_checkpoint_data.epoch,
        network_total_transactions: latest_checkpoint_data.network_total_transactions,
    })
}

async fn build_client_for_target(target: &str) -> Result<(String, SuiClient), String> {
    let target_lowercase = target.to_ascii_lowercase();
    let client_result: Result<(String, SuiClient), sui_sdk::error::Error> =
        match target_lowercase.as_str() {
            "mainnet" => SuiClientBuilder::default()
                .build_mainnet()
                .await
                .map(|client| ("mainnet".to_owned(), client)),
            "testnet" => SuiClientBuilder::default()
                .build_testnet()
                .await
                .map(|client| ("testnet".to_owned(), client)),
            "devnet" => SuiClientBuilder::default()
                .build_devnet()
                .await
                .map(|client| ("devnet".to_owned(), client)),
            "localnet" => SuiClientBuilder::default()
                .build_localnet()
                .await
                .map(|client| ("localnet".to_owned(), client)),
            _ if target.starts_with("http://") || target.starts_with("https://") => {
                SuiClientBuilder::default()
                    .build(target)
                    .await
                    .map(|client| (target.to_owned(), client))
            }
            _ => {
                return Err(
                    "Unsupported network. Use mainnet/testnet/devnet/localnet or a full RPC URL."
                        .to_owned(),
                );
            }
        };

    match client_result {
        Ok((label, client)) => Ok((label, client)),
        Err(error) => Err(format!(
            "Failed to connect `{target}`: {error}\nDebug: {error:?}"
        )),
    }
}
