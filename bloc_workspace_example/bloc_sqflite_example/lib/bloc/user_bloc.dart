import 'package:flutter_bloc/flutter_bloc.dart';
import '../database/database_helper.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  UserBloc() : super(UserInitial()) {
    on<LoadUsers>(_onLoadUsers);
    on<AddUser>(_onAddUser);
    on<UpdateUser>(_onUpdateUser);
    on<DeleteUser>(_onDeleteUser);
  }

  Future<void> _onLoadUsers(LoadUsers event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final users = await _databaseHelper.getUsers();
      emit(UserLoaded(users));
    } catch (e) {
      emit(UserError('Failed to load users: $e'));
    }
  }

  Future<void> _onAddUser(AddUser event, Emitter<UserState> emit) async {
    try {
      await _databaseHelper.insertUser(event.user);
      add(LoadUsers());
    } catch (e) {
      emit(UserError('Failed to add user: $e'));
    }
  }

  Future<void> _onUpdateUser(UpdateUser event, Emitter<UserState> emit) async {
    try {
      await _databaseHelper.updateUser(event.user);
      add(LoadUsers());
    } catch (e) {
      emit(UserError('Failed to update user: $e'));
    }
  }

  Future<void> _onDeleteUser(DeleteUser event, Emitter<UserState> emit) async {
    try {
      await _databaseHelper.deleteUser(event.userId);
      add(LoadUsers());
    } catch (e) {
      emit(UserError('Failed to delete user: $e'));
    }
  }
}
