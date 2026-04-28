import 'package:injectable/injectable.dart';

import '../entities/public_key_info.dart';
import '../repositories/serve_pem_repository.dart';

@injectable
class FetchPublicKeyUseCase {
  final ServePemRepository _repository;

  FetchPublicKeyUseCase(this._repository);

  Future<PublicKeyInfo> call() => _repository.getPublicKey();
}
