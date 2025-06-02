import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ProfileLoadRequested extends ProfileEvent {
  const ProfileLoadRequested({required this.username});

  final String username;

  @override
  List<Object> get props => [username];
}

class ProfileClearRequested extends ProfileEvent {
  const ProfileClearRequested();
}
