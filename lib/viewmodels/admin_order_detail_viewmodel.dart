import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/order_detail_model.dart';
import '../services/admin_order_detail_service.dart';

class AdminOrderDetailViewModel extends ChangeNotifier {
  final AdminOrderDetailService _service = AdminOrderDetailService();

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  OrderDetailModel? _orderDetail;
  OrderDetailModel? get orderDetail => _orderDetail;

  Future<void> fetchOrderDetail(String orderId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _service.getOrderDetail(orderId);

      final profileData = response['profiles'] ?? {};
      final profile = OrderProfileModel(
        fullName: profileData['full_name']?.toString() ?? 'Guest Customer',
        phoneNumber: profileData['phone_number']?.toString() ?? '-',
      );

      final itemsData = response['order_items'] as List<dynamic>? ?? [];
      final List<OrderItemModel> items = itemsData.map((item) {
        final menu = item['menus'] ?? {};
        return OrderItemModel(
          quantity: item['quantity'] ?? 1,
          menuName: menu['name']?.toString() ?? 'Unknown Item',
          menuPrice: (menu['price'] as num?)?.toDouble() ?? 0.0,
          menuImageUrl: menu['image_url']?.toString(),
        );
      }).toList();

      _orderDetail = OrderDetailModel(
        id: response['id'].toString(),
        createdAt: DateTime.parse(response['created_at']).toLocal(),
        status: response['status']?.toString() ?? 'Menunggu Pembayaran',
        totalPrice: (response['total_price'] as num?)?.toDouble() ?? 0.0,
        notes:
            (response['notes'] == null ||
                response['notes'] == 'null' ||
                response['notes'] == '')
            ? '-'
            : response['notes'].toString(),
        paymentMethod: response['payment_method']?.toString() ?? 'QRIS',
        addressDetail:
            response['address_detail']?.toString() ??
            'Pickup / Tidak ada alamat',
        profile: profile,
        items: items,
      );
    } catch (e) {
      debugPrint("Error Fetching Order Detail: $e");
      _orderDetail = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String formatCurrency(double amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 0,
    ).format(amount);
  }
}
