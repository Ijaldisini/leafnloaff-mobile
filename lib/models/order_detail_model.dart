class OrderProfileModel {
  final String fullName;
  final String phoneNumber;

  OrderProfileModel({required this.fullName, required this.phoneNumber});

  factory OrderProfileModel.fromJson(Map<String, dynamic> json) {
    return OrderProfileModel(
      fullName: json['full_name'] ?? 'Unknown',
      phoneNumber: json['phone_number'] ?? '-',
    );
  }
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

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    final menu = json['menus'] ?? {};
    return OrderItemModel(
      quantity: json['quantity'] ?? 1,
      menuName: menu['name'] ?? 'Unknown Menu',
      menuPrice: (menu['price'] ?? 0).toDouble(),
      menuImageUrl: menu['image_url'],
    );
  }
}

class OrderDetailModel {
  final String id;
  final DateTime createdAt;
  final String status;
  final double totalPrice;
  final String notes;
  final String paymentMethod;
  final String addressDetail;
  final String? vaNumber;
  final double? latitude;
  final double? longitude;
  final String? paymentProofUrl;
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
    this.vaNumber,
    this.latitude,
    this.longitude,
    this.paymentProofUrl,
    required this.profile,
    required this.items,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailModel(
      id: json['id'].toString(),
      createdAt: DateTime.parse(json['created_at']),
      status: json['status'] ?? 'Preparing',
      totalPrice: (json['total_price'] ?? 0).toDouble(),
      notes: json['notes'] ?? '',
      paymentMethod: json['payment_method'] ?? '',
      addressDetail: json['address_detail'] ?? '',
      vaNumber: json['va_number']?.toString(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      paymentProofUrl: json['payment_proof_url']?.toString(),
      profile: json['profiles'] != null
          ? OrderProfileModel.fromJson(json['profiles'])
          : OrderProfileModel(fullName: 'Unknown', phoneNumber: '-'),
      items:
          (json['order_items'] as List<dynamic>?)
              ?.map((item) => OrderItemModel.fromJson(item))
              .toList() ??
          [],
    );
  }
}
