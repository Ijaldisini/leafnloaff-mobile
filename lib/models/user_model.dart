class UserModel {
  final String id;
  final String fullName;
  final String username;
  final String email;
  final String? otpSecret;
  final String role;
  final String? phoneNumber;
  final String? profileImageUrl;

  UserModel({
    required this.id,
    required this.fullName,
    required this.username,
    required this.email,
    this.otpSecret,
    this.role = 'customer',
    this.phoneNumber,
    this.profileImageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'username': username,
      'email': email,
      'otp_secret': otpSecret,
      'role': role,
      'phone_number': phoneNumber,
      'profile_image_url': profileImageUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      fullName: map['full_name'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      otpSecret: map['otp_secret'],
      role: map['role'] ?? 'customer',
      phoneNumber: map['phone_number'],
      profileImageUrl: map['profile_image_url'],
    );
  }

  UserModel copyWith({
    String? fullName,
    String? username,
    String? phoneNumber,
    String? profileImageUrl,
  }) {
    return UserModel(
      id: id,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      email: email,
      otpSecret: otpSecret,
      role: role,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}
