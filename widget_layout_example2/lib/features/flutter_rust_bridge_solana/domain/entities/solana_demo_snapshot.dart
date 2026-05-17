class SolanaDemoSnapshot {
  const SolanaDemoSnapshot({
    required this.rpcUrl,
    required this.walletAddress,
    required this.latestSlot,
    required this.blockHeight,
    required this.epoch,
    required this.transactionCount,
    required this.lamports,
    required this.solBalance,
    required this.commitment,
    required this.explanation,
  });

  final String rpcUrl;
  final String walletAddress;
  final BigInt latestSlot;
  final BigInt blockHeight;
  final BigInt epoch;
  final BigInt? transactionCount;
  final BigInt lamports;
  final String solBalance;
  final String commitment;
  final String explanation;
}
