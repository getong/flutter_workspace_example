import 'package:widget_layout_example2/features/flutter_rust_bridge_solana/domain/entities/solana_demo_snapshot.dart';

abstract interface class SolanaBridgeRepository {
  Future<SolanaDemoSnapshot> fetchSnapshot({
    required String rpcUrl,
    required String walletAddress,
  });
}
