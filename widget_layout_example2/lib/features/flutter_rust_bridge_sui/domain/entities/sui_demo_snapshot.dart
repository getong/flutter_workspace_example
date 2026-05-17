class SuiDemoSnapshot {
  const SuiDemoSnapshot({
    required this.rpcUrl,
    required this.walletAddress,
    required this.apiVersion,
    required this.rpcMethodsCount,
    required this.currentEpoch,
    required this.referenceGasPrice,
    required this.activeValidators,
    required this.ownedObjectsInPage,
    required this.stakePositionCount,
    required this.explanation,
  });

  final String rpcUrl;
  final String walletAddress;
  final String apiVersion;
  final String rpcMethodsCount;
  final String currentEpoch;
  final String referenceGasPrice;
  final String activeValidators;
  final String ownedObjectsInPage;
  final String stakePositionCount;
  final String explanation;
}
