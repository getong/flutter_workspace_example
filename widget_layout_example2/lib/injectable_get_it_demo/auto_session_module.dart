import 'package:injectable/injectable.dart';
import 'package:widget_layout_example2/injectable_get_it_demo/auth_repository.dart';

@injectable
class AutoSessionModule {
  AutoSessionModule(this._authRepository);

  final AuthRepository _authRepository;

  String get headline => 'Hello ${_authRepository.currentUsername}';

  String get summary =>
      'Resolved automatically from GetIt.instance without another binding declaration.';

  int get repositoryIdentity => _authRepository.hashCode;
}
