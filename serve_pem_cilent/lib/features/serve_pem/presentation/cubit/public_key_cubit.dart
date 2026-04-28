import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/public_key_info.dart';
import '../../domain/usecases/fetch_public_key_usecase.dart';

sealed class PublicKeyState {
  const PublicKeyState();
}

class PublicKeyInitial extends PublicKeyState {
  const PublicKeyInitial();
}

class PublicKeyLoading extends PublicKeyState {
  const PublicKeyLoading();
}

class PublicKeyLoaded extends PublicKeyState {
  final PublicKeyInfo publicKeyInfo;

  const PublicKeyLoaded(this.publicKeyInfo);
}

class PublicKeyError extends PublicKeyState {
  final String message;

  const PublicKeyError(this.message);
}

@injectable
class PublicKeyCubit extends Cubit<PublicKeyState> {
  final FetchPublicKeyUseCase _fetchPublicKeyUseCase;

  PublicKeyCubit(this._fetchPublicKeyUseCase) : super(const PublicKeyInitial());

  Future<void> load() async {
    emit(const PublicKeyLoading());

    try {
      final publicKeyInfo = await _fetchPublicKeyUseCase();
      emit(PublicKeyLoaded(publicKeyInfo));
    } catch (error) {
      emit(PublicKeyError(error.toString().replaceFirst('Exception: ', '')));
    }
  }
}
