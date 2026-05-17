class EthereumDemoSnapshot {
  const EthereumDemoSnapshot({
    required this.rpcUrl,
    required this.walletAddress,
    required this.erc20TokenAddress,
    required this.latestBlockNumber,
    required this.nativeBalanceWei,
    required this.nativeBalanceEth,
    required this.tokenAddress,
    required this.tokenSymbol,
    required this.tokenDecimals,
    required this.tokenBalanceRaw,
    required this.tokenBalanceFormatted,
    required this.explanation,
  });

  final String rpcUrl;
  final String walletAddress;
  final String erc20TokenAddress;
  final String latestBlockNumber;
  final String nativeBalanceWei;
  final String nativeBalanceEth;
  final String tokenAddress;
  final String tokenSymbol;
  final int tokenDecimals;
  final String tokenBalanceRaw;
  final String tokenBalanceFormatted;
  final String explanation;
}
