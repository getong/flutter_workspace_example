import 'package:widget_layout_example2/features/flutter_rust_bridge_ethereum/domain/entities/ethereum_demo_snapshot.dart';

abstract interface class EthereumBridgeRepository {
  Future<EthereumDemoSnapshot> fetchSnapshot({
    required String rpcUrl,
    required String walletAddress,
    required String erc20TokenAddress,
  });
}
