class AddressModel {
  final String id;
  final String userId;
  final String recipientName;
  final String phoneNumber;
  final String addressDetail;
  final double latitude;
  final double longitude;
  final bool isDefault;

  AddressModel({
    required this.id,
    required this.userId,
    required this.recipientName,
    required this.phoneNumber,
    required this.addressDetail,
    required this.latitude,
    required this.longitude,
    required this.isDefault,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      recipientName: json['recipient_name'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      addressDetail: json['address_detail'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      isDefault: json['is_default'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recipient_name': recipientName,
      'phone_number': phoneNumber,
      'address_detail': addressDetail,
      'latitude': latitude,
      'longitude': longitude,
      'is_default': isDefault,
    };
  }
}
