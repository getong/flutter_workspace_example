import 'package:injectable/injectable.dart';
import 'package:widget_layout_example2/injectable_get_it_demo/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class DemoAuthRepository implements AuthRepository {
  DemoAuthRepository()
    : _createdAt = DateTime.now(),
      _accessToken = 'demo-token-8848';

  final DateTime _createdAt;
  final String _accessToken;

  @override
  String get currentUsername => 'injectable_user';

  @override
  String get accessToken => _accessToken;

  @override
  DateTime get createdAt => _createdAt;
}
