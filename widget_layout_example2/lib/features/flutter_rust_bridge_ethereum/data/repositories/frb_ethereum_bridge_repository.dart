import 'package:widget_layout_example2/features/flutter_rust_bridge_ethereum/domain/entities/ethereum_demo_snapshot.dart';
import 'package:widget_layout_example2/features/flutter_rust_bridge_ethereum/domain/repositories/ethereum_bridge_repository.dart';
import 'package:widget_layout_example2/core/rust/api/ethereum.dart' as rust_api;

class FrbEthereumBridgeRepository implements EthereumBridgeRepository {
  @override
  Future<EthereumDemoSnapshot> fetchSnapshot({
    required String rpcUrl,
    required String walletAddress,
    required String erc20TokenAddress,
  }) async {
    final rust_api.EthereumDemoResult result = await rust_api.fetchEthereumDemo(
      request: rust_api.EthereumDemoRequest(
        rpcUrl: rpcUrl,
        walletAddress: walletAddress,
        erc20TokenAddress: erc20TokenAddress,
      ),
    );

    return EthereumDemoSnapshot(
      rpcUrl: result.chainRpcUrl,
      walletAddress: result.walletAddress,
      erc20TokenAddress: erc20TokenAddress,
      latestBlockNumber: result.latestBlockNumber,
      nativeBalanceWei: result.nativeBalanceWei,
      nativeBalanceEth: result.nativeBalanceEth,
      tokenAddress: result.tokenAddress,
      tokenSymbol: result.tokenSymbol,
      tokenDecimals: result.tokenDecimals,
      tokenBalanceRaw: result.tokenBalanceRaw,
      tokenBalanceFormatted: result.tokenBalanceFormatted,
      explanation: result.explanation,
    );
  }
}
