import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
  });

  final String id;
  final String name;
  final String email;
  final String token;

  @override
  List<Object?> get props => <Object?>[id, name, email, token];
}
