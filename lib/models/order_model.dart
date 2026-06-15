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
  final String menuId;
  final int quantity;
  final String menuName;
  final double menuPrice;
  final double priceAtTime;
  final String? menuImageUrl;
  final String? notes;

  OrderItemModel({
    required this.menuId,
    required this.quantity,
    required this.menuName,
    required this.menuPrice,
    required this.priceAtTime,
    this.menuImageUrl,
    this.notes,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    final menu = json['menus'] ?? {};
    return OrderItemModel(
      menuId: json['menu_id']?.toString() ?? menu['id']?.toString() ?? '',
      quantity: json['quantity'] ?? 1,
      menuName: menu['name'] ?? 'Unknown Menu',
      menuPrice: (menu['price'] ?? 0).toDouble(),
      priceAtTime: (json['price_at_time'] ?? menu['price'] ?? 0).toDouble(),
      menuImageUrl: menu['image_url'],
      notes: json['notes'],
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
  final DateTime? vaExpiryTime;
  final double discountApplied;
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
    this.vaExpiryTime,
    required this.discountApplied,
    this.latitude,
    this.longitude,
    this.paymentProofUrl,
    required this.profile,
    required this.items,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailModel(
      id: json['id'].toString(),
      createdAt: DateTime.parse(json['created_at']).toLocal(),
      status: json['status'] ?? 'Preparing',
      totalPrice: (json['total_price'] ?? 0).toDouble(),
      notes: json['notes'] ?? '',
      paymentMethod: json['payment_method'] ?? '',
      addressDetail: json['address_detail'] ?? '',
      vaNumber: json['va_number']?.toString(),
      vaExpiryTime: json['va_expiry_time'] != null
          ? DateTime.parse(json['va_expiry_time']).toLocal()
          : null,
      discountApplied: (json['discount_applied'] ?? 0).toDouble(),
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

  factory OrderManagementModel.fromJson(Map<String, dynamic> json) {
    final createdAt = DateTime.parse(json['created_at']).toLocal();
    String productDesc = "Unknown Item";
    int totalQty = 0;

    final items = json['order_items'] as List<dynamic>? ?? [];

    if (items.isNotEmpty) {
      totalQty = items[0]['quantity'] ?? 0;
      productDesc = items[0]['menus']?['name'] ?? "Unknown Item";
      if (items.length > 1) {
        productDesc += " +${items.length - 1} lainnya";
      }
    }

    return OrderManagementModel(
      id: json['id'].toString(),
      totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0.0,
      status: json['status']?.toString() ?? 'Menunggu Pembayaran',
      createdAt: createdAt,
      productDesc: productDesc,
      totalQty: totalQty,
    );
  }
}

class OrderReviewModel {
  final String itemName;
  final String? itemImageUrl;
  final String notes;
  final int qty;
  final double price;
  final int rating;
  final String reviewText;
  final List<String> reviewImages;

  OrderReviewModel({
    required this.itemName,
    this.itemImageUrl,
    required this.notes,
    required this.qty,
    required this.price,
    required this.rating,
    required this.reviewText,
    required this.reviewImages,
  });

  factory OrderReviewModel.fromJson(Map<String, dynamic> json) {
    final menu = json['menus'] ?? {};
    final String? rawImageUrls = json['image_url'];
    List<String> images = [];

    if (rawImageUrls != null && rawImageUrls.isNotEmpty) {
      images = rawImageUrls.split(',').map((e) => e.trim()).toList();
    }

    return OrderReviewModel(
      itemName: menu['name'] ?? 'Item\'s Name',
      itemImageUrl: menu['image_url'],
      notes: json['notes'] ?? '',
      qty: json['quantity'] ?? 1,
      price: (menu['price'] as num?)?.toDouble() ?? 0.0,
      rating: json['rating'] ?? 0,
      reviewText: json['comment'] ?? 'Belum ada ulasan',
      reviewImages: images,
    );
  }
}

class OrderHistoryModel {
  final String id;
  final DateTime createdAt;
  final String status;
  final double totalPrice;
  final String productNames;
  final int totalQuantity;

  OrderHistoryModel({
    required this.id,
    required this.createdAt,
    required this.status,
    required this.totalPrice,
    required this.productNames,
    required this.totalQuantity,
  });

  factory OrderHistoryModel.fromJson(Map<String, dynamic> json) {
    final orderItems = json['order_items'] as List<dynamic>? ?? [];
    int qty = 0;
    List<String> names = [];

    for (var item in orderItems) {
      qty += (item['quantity'] as num?)?.toInt() ?? 0;
      final menu = item['menus'] as Map<String, dynamic>?;
      if (menu != null && menu['name'] != null) {
        names.add(menu['name'].toString());
      }
    }

    return OrderHistoryModel(
      id: json['id']?.toString() ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at']).toLocal()
          : DateTime.now(),
      status: json['status']?.toString() ?? 'Menunggu Pembayaran',
      totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0.0,
      productNames: names.isEmpty ? '-' : names.join(', '),
      totalQuantity: qty,
    );
  }
}
