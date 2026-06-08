class UserModel {
  final String id;
  final String fullName;
  final String username;
  final String email;
  final String role;
  final String? phoneNumber;
  final String? profileImageUrl;

  UserModel({
    required this.id,
    required this.fullName,
    required this.username,
    required this.email,
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
      role: map['role'] ?? 'customer',
      phoneNumber: map['phone_number'],
      profileImageUrl: map['profile_image_url'],
    );
  }

  UserModel copyWith({
    String? id,
    String? fullName,
    String? username,
    String? phoneNumber,
    String? profileImageUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      email: email,
      role: role,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}
