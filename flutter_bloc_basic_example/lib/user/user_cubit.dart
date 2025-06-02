import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/user_repository.dart';

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

/// {@template user_cubit}
/// Cubit that demonstrates RepositoryProvider usage
/// {@endtemplate}
class UserCubit extends Cubit<UserState> {
  UserCubit(this._userRepository) : super(const UserState());

  final UserRepository _userRepository;

  Future<void> loadUsers() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final users = await _userRepository.getUsers();
      emit(state.copyWith(users: users, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> selectUser(String userId) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final user = await _userRepository.getUserById(userId);
      emit(state.copyWith(selectedUser: user, isLoading: false));
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

  void clearError() {
    emit(state.copyWith(error: null));
  }
}
