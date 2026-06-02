class OrderProfileModel {
  final String fullName;
  final String phoneNumber;

  OrderProfileModel({required this.fullName, required this.phoneNumber});
}

class OrderItemModel {
  final int quantity;
  final String menuName;
  final double menuPrice;
  final String? menuImageUrl;

  OrderItemModel({
    required this.quantity,
    required this.menuName,
    required this.menuPrice,
    this.menuImageUrl,
  });
}

class OrderDetailModel {
  final String id;
  final DateTime createdAt;
  final String status;
  final double totalPrice;
  final String notes;
  final String paymentMethod;
  final String addressDetail;
  final OrderProfileModel profile;
  final List<OrderItemModel> items;

  OrderDetailModel({
    required this.id,
    required this.createdAt,
    required this.status,
    required this.totalPrice,
    required this.notes,
    required this.paymentMethod,
    required this.addressDetail,
    required this.profile,
    required this.items,
  });
}
