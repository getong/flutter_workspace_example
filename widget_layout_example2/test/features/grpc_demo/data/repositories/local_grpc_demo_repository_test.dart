import 'package:flutter_test/flutter_test.dart';
import 'package:widget_layout_example2/features/grpc_demo/data/repositories/local_grpc_demo_repository.dart';
import 'package:widget_layout_example2/features/grpc_demo/domain/entities/grpc_demo_snapshot.dart';

void main() {
  group('LocalGrpcDemoRepository', () {
    late LocalGrpcDemoRepository repository;

    setUp(() {
      repository = LocalGrpcDemoRepository();
    });

    tearDown(() async {
      await repository.dispose();
    });

    test('runs unary and server-streaming gRPC calls', () async {
      final GrpcDemoSnapshot snapshot = await repository.runDemo(
        userId: 'demo-admin',
        preferredRole: 'maintainer',
        target: 'flutter-grpc-client',
        steps: 3,
      );

      expect(snapshot.endpoint, startsWith('127.0.0.1:'));
      expect(snapshot.userId, 'demo-admin');
      expect(snapshot.displayName, 'Demo Admin');
      expect(snapshot.role, 'maintainer');
      expect(snapshot.capabilities, contains('unary response'));
      expect(snapshot.capabilities, contains('server streaming'));
      expect(snapshot.events, hasLength(3));
      expect(snapshot.events.last.done, isTrue);
      expect(snapshot.unaryBytes, greaterThan(0));
      expect(snapshot.streamBytes, greaterThan(0));
    });
  });
}
