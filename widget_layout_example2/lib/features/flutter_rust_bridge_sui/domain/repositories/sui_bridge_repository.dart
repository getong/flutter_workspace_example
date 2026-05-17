import 'package:widget_layout_example2/features/flutter_rust_bridge_sui/domain/entities/sui_demo_snapshot.dart';

abstract interface class SuiBridgeRepository {
  Future<SuiDemoSnapshot> fetchSnapshot({
    required String rpcUrl,
    required String walletAddress,
  });
}
