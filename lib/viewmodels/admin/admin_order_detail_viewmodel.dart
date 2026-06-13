import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/order_detail_model.dart';
import '../../services/admin/admin_order_detail_service.dart';

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
      _orderDetail = OrderDetailModel.fromJson(response);
    } catch (e) {
      debugPrint("Error Fetching Order Detail: $e");
      _orderDetail = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> changeOrderStatus(String orderId, String newStatus) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _service.updateOrderStatus(orderId, newStatus);

      await fetchOrderDetail(orderId);
      return true;
    } catch (e) {
      debugPrint("❌ Error Updating Order Status: $e");
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  String? getNextStatusText(String currentStatus) {
    final s = currentStatus.toLowerCase();
    if (s.contains('tunggu') || s.contains('bayar'))
      return 'Update To Preparing';
    if (s.contains('proses') || s.contains('siap'))
      return 'Update To On The Way';
    return null;
  }

  String? getNextStatusValue(String currentStatus) {
    final s = currentStatus.toLowerCase();
    if (s.contains('tunggu') || s.contains('bayar')) return 'Diproses';
    if (s.contains('proses') || s.contains('siap')) return 'Dikirim';
    return null;
  }

  String formatCurrency(double amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 0,
    ).format(amount);
  }

  Future<void> openMap(double lat, double lng) async {
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint("Gagal membuka Maps");
    }
  }

  Future<void> openPaymentProof(String urlString) async {
    final url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
      debugPrint("Gagal membuka Bukti Pembayaran");
    }
  }
}
