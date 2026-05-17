import 'package:widget_layout_example2/core/rust/api/sui.dart' as rust_api;
import 'package:widget_layout_example2/features/flutter_rust_bridge_sui/domain/entities/sui_demo_snapshot.dart';
import 'package:widget_layout_example2/features/flutter_rust_bridge_sui/domain/repositories/sui_bridge_repository.dart';

class FrbSuiBridgeRepository implements SuiBridgeRepository {
  @override
  Future<SuiDemoSnapshot> fetchSnapshot({
    required String rpcUrl,
    required String walletAddress,
  }) async {
    final rust_api.SuiDemoResult result = await rust_api.fetchSuiDemo(
      request: rust_api.SuiDemoRequest(
        rpcUrl: rpcUrl,
        walletAddress: walletAddress,
      ),
    );

    return SuiDemoSnapshot(
      rpcUrl: result.rpcUrl,
      walletAddress: result.walletAddress,
      apiVersion: result.apiVersion,
      rpcMethodsCount: result.rpcMethodsCount,
      currentEpoch: result.currentEpoch,
      referenceGasPrice: result.referenceGasPrice,
      activeValidators: result.activeValidators,
      ownedObjectsInPage: result.ownedObjectsInPage,
      stakePositionCount: result.stakePositionCount,
      explanation: result.explanation,
    );
  }
}
