import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import '../repository/user_repository.dart';
import '../repository/analytics_repository.dart';

/// {@template user_state}
/// State for user management
/// {@endtemplate}
class UserState {
  const UserState({
    this.users = const [],
    this.isLoading = false,
    this.error,
    this.selectedUser,
  });

  final List<User> users;
  final bool isLoading;
  final String? error;
  final User? selectedUser;

  UserState copyWith({
    List<User>? users,
    bool? isLoading,
    String? error,
    User? selectedUser,
  }) {
    return UserState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedUser: selectedUser ?? this.selectedUser,
    );
  }
}

/// Event for user operations (demonstrating Sink with Cubit)
abstract class UserSinkEvent {}

class LoadUsersSinkEvent extends UserSinkEvent {}

class CreateUserSinkEvent extends UserSinkEvent {
  final String name;
  final String email;
  CreateUserSinkEvent(this.name, this.email);
}

class UpdateUserSinkEvent extends UserSinkEvent {
  final User user;
  UpdateUserSinkEvent(this.user);
}

class DeleteUserSinkEvent extends UserSinkEvent {
  final String userId;
  DeleteUserSinkEvent(this.userId);
}

class SelectUserSinkEvent extends UserSinkEvent {
  final String userId;
  SelectUserSinkEvent(this.userId);
}

/// {@template user_cubit}
/// Cubit that demonstrates RepositoryProvider usage and Sink patterns
/// {@endtemplate}
class UserCubit extends Cubit<UserState> {
  UserCubit(this._userRepository, {AnalyticsRepository? analyticsRepository})
      : _analyticsRepository = analyticsRepository,
        super(const UserState()) {
    // Set up event stream processing
    _eventStreamSubscription = _eventController.stream.listen(_handleEvent);
  }

  final UserRepository _userRepository;
  final AnalyticsRepository? _analyticsRepository;

  // Sink for handling user events
  final StreamController<UserSinkEvent> _eventController =
      StreamController<UserSinkEvent>();
  late final StreamSubscription<UserSinkEvent> _eventStreamSubscription;

  /// Sink for adding user events
  Sink<UserSinkEvent> get eventSink => _eventController.sink;

  /// Stream of user events for external monitoring
  Stream<UserSinkEvent> get eventStream => _eventController.stream;

  // Handle events from sink
  void _handleEvent(UserSinkEvent event) {
    switch (event) {
      case LoadUsersSinkEvent():
        loadUsers();
        break;
      case CreateUserSinkEvent():
        createUser(event.name, event.email);
        break;
      case UpdateUserSinkEvent():
        updateUser(event.user);
        break;
      case DeleteUserSinkEvent():
        deleteUser(event.userId);
        break;
      case SelectUserSinkEvent():
        selectUser(event.userId);
        break;
    }
  }

  Future<void> loadUsers() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final users = await _userRepository.getUsers();
      emit(state.copyWith(users: users, isLoading: false));

      // Track analytics
      _analyticsRepository?.trackEvent('users_loaded', {
        'user_count': users.length,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> selectUser(String userId) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final user = await _userRepository.getUserById(userId);
      emit(state.copyWith(selectedUser: user, isLoading: false));

      // Track analytics
      _analyticsRepository?.trackEvent('user_selected', {
        'user_id': userId,
        'user_name': user?.name ?? 'unknown',
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> createUser(String name, String email) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final newUser = await _userRepository.createUser(name, email);
      final updatedUsers = [...state.users, newUser];
      emit(state.copyWith(users: updatedUsers, isLoading: false));

      // Track analytics
      _analyticsRepository?.trackEvent('user_created', {
        'user_id': newUser.id,
        'user_name': newUser.name,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> updateUser(User user) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final updatedUser = await _userRepository.updateUser(user);
      final updatedUsers = state.users
          .map((u) => u.id == updatedUser.id ? updatedUser : u)
          .toList();
      emit(state.copyWith(users: updatedUsers, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> deleteUser(String userId) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await _userRepository.deleteUser(userId);
      final updatedUsers = state.users.where((u) => u.id != userId).toList();
      emit(state.copyWith(users: updatedUsers, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  /// Batch user operations using sink
  void processBatchOperations(List<UserSinkEvent> events) {
    for (final event in events) {
      eventSink.add(event);
    }
  }

  /// Queue user operation for processing via sink
  void queueUserOperation(UserSinkEvent event) {
    eventSink.add(event);
  }

  void clearError() {
    emit(state.copyWith(error: null));
  }

  @override
  Future<void> close() {
    _eventStreamSubscription.cancel();
    _eventController.close();
    return super.close();
  }
}
