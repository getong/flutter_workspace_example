import 'package:widget_layout_example2/features/grpc_demo/domain/entities/grpc_demo_snapshot.dart';

abstract interface class GrpcDemoRepository {
  Future<GrpcDemoSnapshot> runDemo({
    required String userId,
    required String preferredRole,
    required String target,
    required int steps,
  });

  Future<void> dispose();
}
