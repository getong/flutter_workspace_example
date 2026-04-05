import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/user.dart';
import '../repositories/user_repository.dart';

// Events
abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class UserLoadRequested extends UserEvent {}

class UserCreateRequested extends UserEvent {
  final String name;
  final String email;

  const UserCreateRequested({required this.name, required this.email});

  @override
  List<Object> get props => [name, email];
}

class UserDeleteRequested extends UserEvent {
  final int userId;

  const UserDeleteRequested({required this.userId});

  @override
  List<Object> get props => [userId];
}

// States
abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<User> users;

  const UserLoaded({required this.users});

  @override
  List<Object> get props => [users];
}

class UserError extends UserState {
  final String message;

  const UserError({required this.message});

  @override
  List<Object> get props => [message];
}

// BLoC
class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _repository;

  UserBloc({required UserRepository repository})
      : _repository = repository,
        super(UserInitial()) {
    on<UserLoadRequested>(_onLoadRequested);
    on<UserCreateRequested>(_onCreateRequested);
    on<UserDeleteRequested>(_onDeleteRequested);
  }

  Future<void> _onLoadRequested(
    UserLoadRequested event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      final users = await _repository.getUsers();
      emit(UserLoaded(users: users));
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  Future<void> _onCreateRequested(
    UserCreateRequested event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      await _repository.createUser(event.name, event.email);
      final users = await _repository.getUsers();
      emit(UserLoaded(users: users));
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  Future<void> _onDeleteRequested(
    UserDeleteRequested event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      await _repository.deleteUser(event.userId);
      final users = await _repository.getUsers();
      emit(UserLoaded(users: users));
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }
}
