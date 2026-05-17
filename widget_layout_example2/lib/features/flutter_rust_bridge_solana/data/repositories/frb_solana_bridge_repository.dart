import 'package:widget_layout_example2/core/rust/api/solana.dart' as rust_api;
import 'package:widget_layout_example2/features/flutter_rust_bridge_solana/domain/entities/solana_demo_snapshot.dart';
import 'package:widget_layout_example2/features/flutter_rust_bridge_solana/domain/repositories/solana_bridge_repository.dart';

class FrbSolanaBridgeRepository implements SolanaBridgeRepository {
  @override
  Future<SolanaDemoSnapshot> fetchSnapshot({
    required String rpcUrl,
    required String walletAddress,
  }) async {
    final rust_api.SolanaDemoResult result = await rust_api.fetchSolanaDemo(
      request: rust_api.SolanaDemoRequest(
        rpcUrl: rpcUrl,
        walletAddress: walletAddress,
      ),
    );

    return SolanaDemoSnapshot(
      rpcUrl: result.rpcUrl,
      walletAddress: result.walletAddress,
      latestSlot: result.latestSlot,
      blockHeight: result.blockHeight,
      epoch: result.epoch,
      transactionCount: result.transactionCount,
      lamports: result.lamports,
      solBalance: result.solBalance,
      commitment: result.commitment,
      explanation: result.explanation,
    );
  }
}
