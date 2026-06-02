class OrderManagementModel {
  final String id;
  final double totalPrice;
  final String status;
  final DateTime createdAt;
  final String productDesc;
  final int totalQty;

  OrderManagementModel({
    required this.id,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    required this.productDesc,
    required this.totalQty,
  });
}
