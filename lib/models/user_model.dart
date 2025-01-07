class User {
  final String id;
  final String email;
  final String? token;

  User({
    required this.id,
    required this.email,
    this.token,
  });

  // Factory method to create a User object from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '', // Match your Sign Up response
      email: json['email'],
      token: json['token'], // Match your Login response
    );
  }

  // Convert User object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'token': token,
    };
  }
}
