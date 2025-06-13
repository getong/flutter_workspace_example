import '../models/user.dart';

class UserRepository {
  final List<User> _users = [
    const User(id: 1, name: 'John Doe', email: 'john@example.com'),
    const User(id: 2, name: 'Jane Smith', email: 'jane@example.com'),
    const User(id: 3, name: 'Bob Johnson', email: 'bob@example.com'),
  ];

  Future<List<User>> getUsers() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    return List.from(_users);
  }

  Future<User> getUserById(int id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _users.firstWhere((user) => user.id == id);
  }

  Future<User> addUser(User user) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newUser = user.copyWith(id: _users.length + 1);
    _users.add(newUser);
    return newUser;
  }

  Future<User> updateUser(User user) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _users.indexWhere((u) => u.id == user.id);
    if (index != -1) {
      _users[index] = user;
    }
    return user;
  }

  Future<void> deleteUser(int id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _users.removeWhere((user) => user.id == id);
  }
}
