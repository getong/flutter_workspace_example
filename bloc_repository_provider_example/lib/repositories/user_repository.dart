import '../models/user.dart';

abstract class UserRepository {
  Future<List<User>> getUsers();
  Future<User> getUserById(int id);
  Future<User> createUser(String name, String email);
  Future<void> deleteUser(int id);
}

class UserRepositoryImpl implements UserRepository {
  List<User> _users = [
    const User(id: 1, name: 'John Doe', email: 'john@example.com'),
    const User(id: 2, name: 'Jane Smith', email: 'jane@example.com'),
  ];

  @override
  Future<List<User>> getUsers() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_users);
  }

  @override
  Future<User> getUserById(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _users.firstWhere((user) => user.id == id);
  }

  @override
  Future<User> createUser(String name, String email) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final newUser = User(
      id: _users.isEmpty
          ? 1
          : _users.map((u) => u.id).reduce((a, b) => a > b ? a : b) + 1,
      name: name,
      email: email,
    );
    _users.add(newUser);
    return newUser;
  }

  @override
  Future<void> deleteUser(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _users.removeWhere((user) => user.id == id);
  }
}
