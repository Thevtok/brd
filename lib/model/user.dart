class User {
  final String userId;
  final String firstName;
  final String lastName;
  final String password;

  User({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.password,
  });

  // Factory untuk membuat objek dari JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      password: json['password'] as String,
    );
  }

  // Metode untuk mengonversi objek ke JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'first_name': firstName,
      'last_name': lastName,
      'password': password,
    };
  }
}
