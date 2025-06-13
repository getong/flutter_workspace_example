import '../models/user.dart';

abstract class UserEvent {}

class LoadUsers extends UserEvent {}

class AddUser extends UserEvent {
  final User user;
  AddUser(this.user);
}

class UpdateUser extends UserEvent {
  final User user;
  UpdateUser(this.user);
}

class DeleteUser extends UserEvent {
  final int userId;
  DeleteUser(this.userId);
}
