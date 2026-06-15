class CartItemModel {
  final String id;
  final String menuId;
  final int quantity;
  final String? notes;
  final String menuName;
  final double menuPrice;
  final String? menuImageUrl;

  CartItemModel({
    required this.id,
    required this.menuId,
    required this.quantity,
    this.notes,
    required this.menuName,
    required this.menuPrice,
    this.menuImageUrl,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final menu = json['menus'] ?? {};
    return CartItemModel(
      id: json['id'].toString(),
      menuId: json['menu_id'].toString(),
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      notes: json['notes'],
      menuName: menu['name'] ?? 'Unknown Menu',
      menuPrice: (menu['price'] as num?)?.toDouble() ?? 0.0,
      menuImageUrl: menu['image_url'],
    );
  }
}
