class VoucherModel {
  final String id;
  final String title;
  final String imageUrl;
  final bool isActive;
  final DateTime createdAt;
  final int discountPercentage;
  final String termsAndCondition;
  final DateTime expiresAt;

  VoucherModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.isActive,
    required this.createdAt,
    required this.discountPercentage,
    required this.termsAndCondition,
    required this.expiresAt,
  });

  factory VoucherModel.fromJson(Map<String, dynamic> json) {
    final createdAt = DateTime.parse(json['created_at']).toLocal();

    return VoucherModel(
      id: json['id'] as String,
      title: json['title'] as String,
      imageUrl: json['image_url'] ?? "https://placehold.co/334x121.png",
      isActive: json['is_active'] ?? false,
      createdAt: createdAt,
      discountPercentage: json['discount_percentage'] ?? 0,
      termsAndCondition:
          json['terms_and_condition'] ?? 'Syarat dan ketentuan berlaku.',

      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at']).toLocal()
          : createdAt.add(const Duration(days: 30)),
    );
  }
}
