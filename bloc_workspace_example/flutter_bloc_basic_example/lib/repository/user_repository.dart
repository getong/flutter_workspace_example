/// {@template user}
/// User model for demonstrating RepositoryProvider
/// {@endtemplate}
class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.isActive,
  });

  final String id;
  final String name;
  final String email;
  final bool isActive;

  User copyWith({
    String? id,
    String? name,
    String? email,
    bool? isActive,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  String toString() =>
      'User(id: $id, name: $name, email: $email, isActive: $isActive)';
}

/// {@template user_repository}
/// Abstract repository interface for user operations
/// {@endtemplate}
abstract class UserRepository {
  Future<List<User>> getUsers();
  Future<User?> getUserById(String id);
  Future<User> createUser(String name, String email);
  Future<User> updateUser(User user);
  Future<void> deleteUser(String id);
  Stream<List<User>> watchUsers();
}

/// {@template mock_user_repository}
/// Mock implementation of UserRepository for demonstration
/// {@endtemplate}
class MockUserRepository implements UserRepository {
  MockUserRepository() {
    _users = [
      const User(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        isActive: true,
      ),
      const User(
        id: '2',
        name: 'Jane Smith',
        email: 'jane@example.com',
        isActive: false,
      ),
      const User(
        id: '3',
        name: 'Bob Johnson',
        email: 'bob@example.com',
        isActive: true,
      ),
    ];
  }

  List<User> _users = [];
  int _nextId = 4;

  @override
  Future<List<User>> getUsers() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_users);
  }

  @override
  Future<User?> getUserById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<User> createUser(String name, String email) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final newUser = User(
      id: _nextId.toString(),
      name: name,
      email: email,
      isActive: true,
    );
    _nextId++;
    _users.add(newUser);
    return newUser;
  }

  @override
  Future<User> updateUser(User user) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _users.indexWhere((u) => u.id == user.id);
    if (index != -1) {
      _users[index] = user;
      return user;
    }
    throw Exception('User not found');
  }

  @override
  Future<void> deleteUser(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _users.removeWhere((user) => user.id == id);
  }

  @override
  Stream<List<User>> watchUsers() async* {
    while (true) {
      yield List.from(_users);
      await Future.delayed(const Duration(seconds: 2));
    }
  }
}
