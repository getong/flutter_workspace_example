use alloy::{
    primitives::{Address, U256},
    providers::{Provider, ProviderBuilder},
    sol,
};
use anyhow::Result;
use std::str::FromStr;
use url::Url;

mod erc20_support {
    use super::*;

    pub(super) async fn fetch_token_data<P: Provider>(
        provider: &P,
        token_address: Address,
        wallet_address: Address,
    ) -> Result<(String, u8, U256)> {
        sol! {
            #[sol(rpc)]
            interface IERC20 {
                function balanceOf(address owner) external view returns (uint256);
                function decimals() external view returns (uint8);
                function symbol() external view returns (string);
            }
        }

        let token_contract = IERC20::new(token_address, provider);
        let token_balance = token_contract.balanceOf(wallet_address).call().await?;
        let token_decimals = token_contract.decimals().call().await?;
        let token_symbol = token_contract.symbol().call().await?;
        Ok((token_symbol, token_decimals, token_balance))
    }
}

#[derive(Debug, Clone)]
pub struct EthereumDemoRequest {
    pub rpc_url: String,
    pub wallet_address: String,
    pub erc20_token_address: String,
}

#[derive(Debug, Clone)]
pub struct EthereumDemoResult {
    pub chain_rpc_url: String,
    pub wallet_address: String,
    pub latest_block_number: String,
    pub native_balance_wei: String,
    pub native_balance_eth: String,
    pub token_address: String,
    pub token_symbol: String,
    pub token_decimals: u8,
    pub token_balance_raw: String,
    pub token_balance_formatted: String,
    pub explanation: String,
}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    if rustls::crypto::CryptoProvider::get_default().is_none() {
        let _ = rustls::crypto::aws_lc_rs::default_provider().install_default();
    }
    flutter_rust_bridge::setup_default_user_utils();
}

pub async fn fetch_ethereum_demo(
    request: EthereumDemoRequest,
) -> Result<EthereumDemoResult, String> {
    fetch_ethereum_demo_impl(request)
        .await
        .map_err(|error| error.to_string())
}

async fn fetch_ethereum_demo_impl(request: EthereumDemoRequest) -> Result<EthereumDemoResult> {
    let rpc_url = Url::parse(&request.rpc_url)?;
    let wallet_address = Address::from_str(&request.wallet_address)?;
    let token_address = Address::from_str(&request.erc20_token_address)?;

    let provider = ProviderBuilder::new().connect_http(rpc_url);

    let latest_block_number = provider.get_block_number().await?;
    let native_balance = provider.get_balance(wallet_address).await?;

    let (token_symbol, token_decimals, token_balance) =
        erc20_support::fetch_token_data(&provider, token_address, wallet_address).await?;

    Ok(EthereumDemoResult {
        chain_rpc_url: request.rpc_url,
        wallet_address: request.wallet_address,
        latest_block_number: latest_block_number.to_string(),
        native_balance_wei: native_balance.to_string(),
        native_balance_eth: format_units(native_balance, 18),
        token_address: request.erc20_token_address,
        token_symbol,
        token_decimals,
        token_balance_raw: token_balance.to_string(),
        token_balance_formatted: format_units(token_balance, token_decimals),
        explanation: String::from(
            "This example uses flutter_rust_bridge to call Rust, and Rust uses alloy to read Ethereum RPC data: latest block number, wallet ETH balance, and ERC-20 token metadata/balance.",
        ),
    })
}

fn format_units(value: U256, decimals: u8) -> String {
    let raw = value.to_string();
    let decimals_usize = usize::from(decimals);

    if decimals_usize == 0 {
        return raw;
    }

    if raw.len() <= decimals_usize {
        let padded = format!("{raw:0>width$}", width = decimals_usize);
        let trimmed = padded.trim_end_matches('0');
        if trimmed.is_empty() {
            return String::from("0");
        }
        return format!("0.{}", trimmed);
    }

    let split = raw.len() - decimals_usize;
    let integer = &raw[..split];
    let fraction = raw[split..].trim_end_matches('0');
    if fraction.is_empty() {
        integer.to_string()
    } else {
        format!("{integer}.{fraction}")
    }
}
