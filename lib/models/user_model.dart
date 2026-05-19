class UserModel {
  final String id;
  final String fullName;
  final String username;
  final String email;
  final String? otpSecret;
  final String role;
  
  UserModel({
    required this.id,
    required this.fullName,
    required this.username,
    required this.email,
    this.otpSecret,
    this.role = 'customer',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'username': username,
      'email': email,
      'otp_secret': otpSecret,
      'role': role,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      fullName: map['full_name'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      otpSecret: map['otp_secret'],
      role:
          map['role'] ??
          'customer',
    );
  }
}
