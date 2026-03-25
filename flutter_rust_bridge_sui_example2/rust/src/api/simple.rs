use std::str::FromStr;

use sui_sdk::{types::base_types::SuiAddress, SuiClientBuilder};

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
        return "Network is empty. Use mainnet/testnet/devnet/localnet or a full RPC URL.".to_owned();
    }

    let runtime = match tokio::runtime::Builder::new_current_thread()
        .enable_all()
        .build()
    {
        Ok(runtime) => runtime,
        Err(error) => return format!("Failed to create Tokio runtime: {error}"),
    };

    runtime.block_on(async move {
        match query_sui_api_version(&target).await {
            Ok(message) => message,
            Err(message) => message,
        }
    })
}

async fn query_sui_api_version(target: &str) -> Result<String, String> {
    let target_lowercase = target.to_ascii_lowercase();
    let client_result = match target_lowercase.as_str() {
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
        Ok((label, client)) => Ok(format!("{label} api_version: {}", client.api_version())),
        Err(error) => Err(format!(
            "Failed to connect `{target}`: {error}\nDebug: {error:?}"
        )),
    }
}
