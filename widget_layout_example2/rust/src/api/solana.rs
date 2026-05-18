use anyhow::Result;
use solana_client::rpc_client::RpcClient;
use solana_commitment_config::CommitmentConfig;
use solana_pubkey::Pubkey;
use std::str::FromStr;

#[derive(Debug, Clone)]
pub struct SolanaDemoRequest {
    pub rpc_url: String,
    pub wallet_address: String,
}

#[derive(Debug, Clone)]
pub struct SolanaDemoResult {
    pub rpc_url: String,
    pub wallet_address: String,
    pub latest_slot: u64,
    pub block_height: u64,
    pub epoch: u64,
    pub transaction_count: Option<u64>,
    pub lamports: u64,
    pub sol_balance: String,
    pub commitment: String,
    pub explanation: String,
}

pub async fn fetch_solana_demo(request: SolanaDemoRequest) -> Result<SolanaDemoResult, String> {
    fetch_solana_demo_impl(request)
        .await
        .map_err(|error| error.to_string())
}

async fn fetch_solana_demo_impl(request: SolanaDemoRequest) -> Result<SolanaDemoResult> {
    let wallet_address = Pubkey::from_str(&request.wallet_address)?;
    let client =
        RpcClient::new_with_commitment(request.rpc_url.clone(), CommitmentConfig::confirmed());

    let latest_slot = client.get_slot()?;
    let block_height = client.get_block_height()?;
    let epoch_info = client.get_epoch_info()?;
    let lamports = client.get_balance(&wallet_address)?;
    let transaction_count = client.get_transaction_count().ok();

    Ok(SolanaDemoResult {
        rpc_url: request.rpc_url,
        wallet_address: request.wallet_address,
        latest_slot,
        block_height,
        epoch: epoch_info.epoch,
        transaction_count,
        lamports,
        sol_balance: format!("{:.9}", lamports as f64 / 1_000_000_000.0),
        commitment: String::from("confirmed"),
        explanation: String::from(
            "This demo uses flutter_rust_bridge to call Rust, and Rust uses Solana RPC client crates to read Solana chain state: latest slot, block height, epoch info, and wallet SOL balance.",
        ),
    })
}
