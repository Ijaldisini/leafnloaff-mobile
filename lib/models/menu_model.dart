class MenuModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String? imageUrl;
  final int stock;
  final bool isActive;
  final DateTime createdAt;

  MenuModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    this.imageUrl,
    required this.stock,
    required this.isActive,
    required this.createdAt,
  });

  factory MenuModel.fromJson(Map<String, dynamic> data) {
    String? rawImageUrl = data['image_url']?.toString();
    if (rawImageUrl != null && rawImageUrl.contains('example.com')) {
      rawImageUrl = 'https://placehold.co/113x100/png?text=Image+Not+Found';
    }

    return MenuModel(
      id: data['id']?.toString() ?? '',
      name: data['name']?.toString() ?? 'Unknown Name',
      description: data['description']?.toString() ?? '-',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      category: data['category']?.toString() ?? 'Makanan',
      imageUrl: rawImageUrl,
      stock: data['stock'] ?? 0,
      isActive: data['is_active'] ?? true,
      createdAt: data['created_at'] != null
          ? DateTime.parse(data['created_at'].toString())
          : DateTime.now(),
    );
  }
}
