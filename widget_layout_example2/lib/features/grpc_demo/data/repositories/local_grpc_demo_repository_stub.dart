import 'package:widget_layout_example2/features/grpc_demo/domain/entities/grpc_demo_snapshot.dart';
import 'package:widget_layout_example2/features/grpc_demo/domain/repositories/grpc_demo_repository.dart';

class LocalGrpcDemoRepository implements GrpcDemoRepository {
  @override
  Future<GrpcDemoSnapshot> runDemo({
    required String userId,
    required String preferredRole,
    required String target,
    required int steps,
  }) {
    throw UnsupportedError(
      'The local gRPC server demo requires dart:io. Run it on mobile or desktop, '
      'or point the generated client at a real gRPC-Web compatible endpoint.',
    );
  }

  @override
  Future<void> dispose() async {}
}
