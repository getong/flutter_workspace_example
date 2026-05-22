import 'package:flutter/foundation.dart';
import 'package:widget_layout_example2/features/grpc_demo/data/repositories/local_grpc_demo_repository.dart';
import 'package:widget_layout_example2/features/grpc_demo/domain/entities/grpc_demo_snapshot.dart';
import 'package:widget_layout_example2/features/grpc_demo/domain/repositories/grpc_demo_repository.dart';

class GrpcDemoViewModel extends ChangeNotifier {
  GrpcDemoViewModel({GrpcDemoRepository? repository})
    : _repository = repository ?? LocalGrpcDemoRepository();

  final GrpcDemoRepository _repository;

  GrpcDemoSnapshot? _snapshot;
  GrpcDemoSnapshot? get snapshot => _snapshot;

  bool _isRunning = false;
  bool get isRunning => _isRunning;

  String? _error;
  String? get error => _error;

  Future<void> runDemo({
    required String userId,
    required String preferredRole,
    required String target,
    required int steps,
  }) async {
    _isRunning = true;
    _error = null;
    notifyListeners();

    try {
      _snapshot = await _repository.runDemo(
        userId: userId,
        preferredRole: preferredRole,
        target: target,
        steps: steps,
      );
    } catch (error) {
      _error = '$error';
    } finally {
      _isRunning = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _repository.dispose();
    super.dispose();
  }
}
