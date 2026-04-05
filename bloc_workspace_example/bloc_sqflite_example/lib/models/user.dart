class User {
  final int? id;
  final String name;
  final String email;
  final int age;

  User({this.id, required this.name, required this.email, required this.age});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'email': email, 'age': age};
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id']?.toInt(),
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      age: map['age']?.toInt() ?? 0,
    );
  }

  User copyWith({int? id, String? name, String? email, int? age}) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      age: age ?? this.age,
    );
  }
}
