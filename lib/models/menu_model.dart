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
}