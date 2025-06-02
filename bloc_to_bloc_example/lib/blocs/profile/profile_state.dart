import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  const ProfileLoaded({
    required this.username,
    required this.email,
    required this.avatar,
  });

  final String username;
  final String email;
  final String avatar;

  @override
  List<Object> get props => [username, email, avatar];
}

class ProfileEmpty extends ProfileState {
  const ProfileEmpty();
}
