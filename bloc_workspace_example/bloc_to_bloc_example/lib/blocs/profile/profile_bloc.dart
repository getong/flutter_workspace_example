import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../authentication/authentication_bloc.dart';
import '../authentication/authentication_state.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({required AuthenticationBloc authenticationBloc})
      : _authenticationBloc = authenticationBloc,
        super(const ProfileInitial()) {
    // Listen to authentication state changes
    _authenticationSubscription =
        _authenticationBloc.stream.listen((authState) {
      if (authState is AuthenticationAuthenticated) {
        add(ProfileLoadRequested(username: authState.username));
      } else if (authState is AuthenticationUnauthenticated) {
        add(const ProfileClearRequested());
      }
    });

    on<ProfileLoadRequested>(_onLoadRequested);
    on<ProfileClearRequested>(_onClearRequested);
  }

  final AuthenticationBloc _authenticationBloc;
  late StreamSubscription<AuthenticationState> _authenticationSubscription;

  void _onLoadRequested(
    ProfileLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    // Use a more reliable avatar service with proper URL encoding
    final encodedName = Uri.encodeComponent(event.username);

    emit(ProfileLoaded(
      username: event.username,
      email: '${event.username}@example.com',
      avatar: 'https://robohash.org/$encodedName?set=set1&size=200x200',
    ));
  }

  void _onClearRequested(
    ProfileClearRequested event,
    Emitter<ProfileState> emit,
  ) {
    emit(const ProfileEmpty());
  }

  @override
  Future<void> close() {
    _authenticationSubscription.cancel();
    return super.close();
  }
}
