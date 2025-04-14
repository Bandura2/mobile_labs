class User {
  final String name;
  final String email;
  final String password;
  final bool isLoggedIn;

  User({
    required this.name,
    required this.email,
    required this.password,
    this.isLoggedIn = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'isLoggedIn': isLoggedIn,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      isLoggedIn: map['isLoggedIn'] ?? false,
    );
  }
}
