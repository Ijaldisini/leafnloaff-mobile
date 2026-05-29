class RecentOrderModel {
  final String id;
  final String status;
  final DateTime createdAt;
  final double totalPrice;
  final String notes;
  final String productName;
  final int quantity;

  RecentOrderModel({
    required this.id,
    required this.status,
    required this.createdAt,
    required this.totalPrice,
    required this.notes,
    required this.productName,
    required this.quantity,
  });
}
