class VoucherModel {
  final String id;
  final String title;
  final String imageUrl;
  final bool isActive;
  final DateTime createdAt;
  final int discountPercentage;
  final String termsAndCondition;

  VoucherModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.isActive,
    required this.createdAt,
    required this.discountPercentage,
    required this.termsAndCondition,
  });

  factory VoucherModel.fromJson(Map<String, dynamic> json) {
    return VoucherModel(
      id: json['id'] as String,
      title: json['title'] as String,
      imageUrl: json['image_url'] ?? "https://placehold.co/334x121",
      isActive: json['is_active'] ?? false,
      createdAt: DateTime.parse(json['created_at']).toLocal(),
      discountPercentage: json['discount_percentage'] ?? 0,
      termsAndCondition:
          json['terms_and_condition'] ?? 'Syarat dan ketentuan berlaku.',
    );
  }
}
