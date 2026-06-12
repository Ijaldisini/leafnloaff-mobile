import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/cust/detail_order_service.dart';
import '../../services/payments/midtrans_service.dart';
import 'history_viewmodel.dart';

class DetailOrderViewModel extends ChangeNotifier {
  final DetailOrderService _service = DetailOrderService();
  final MidtransService _midtransService = MidtransService();

  bool isLoading = true;
  String? errorMessage;
  Map<String, dynamic>? orderData;
  bool isReviewed = false;

  double subTotal = 0;
  double shippingCost = 0;
  double discount = 0;
  double totalPayment = 0;

  Timer? _countdownTimer;
  Timer? _pollingTimer;
  Duration remainingTime = Duration.zero;

  Future<void> fetchOrder(String orderId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      orderData = await _service.fetchOrderDetails(orderId);

      if (orderData != null) {
        _calculateSummary();

        if (orderData!['status'] == 'Selesai') {
          final reviewCheck = await Supabase.instance.client
              .from('reviews')
              .select('id')
              .eq('order_id', orderId)
              .limit(1)
              .maybeSingle();

          isReviewed = reviewCheck != null;
        }

        if (orderData!['status'] == 'Menunggu Pembayaran') {
          _startCountdown();
          _startPollingPaymentStatus(orderId);
        }
      } else {
        errorMessage = "Data pesanan tidak ditemukan";
      }
    } catch (e) {
      errorMessage = "Gagal memuat detail: ${e.toString()}";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _startPollingPaymentStatus(String orderId) {
    _pollingTimer?.cancel();

    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      try {
        final response = await _midtransService.checkTransactionStatus(orderId);
        final transactionStatus = response['transaction_status'];

        if (transactionStatus == 'settlement' ||
            transactionStatus == 'capture') {
          timer.cancel();
          _countdownTimer?.cancel();

          await _service.updateOrderStatus(orderId, 'Diproses');
          await fetchOrder(orderId);
          HistoryViewModel().fetchHistory();
        } else if (transactionStatus == 'expire' ||
            transactionStatus == 'cancel') {
          timer.cancel();
          _countdownTimer?.cancel();
          await _service.updateOrderStatus(orderId, 'Dibatalkan');
          await fetchOrder(orderId);
          HistoryViewModel().fetchHistory();
        }
      } catch (e) {
        debugPrint("Polling status error: $e");
      }
    });
  }

  void _calculateSummary() {
    if (orderData == null) return;
    subTotal = 0;
    final items = orderData!['order_items'] as List<dynamic>? ?? [];
    for (var item in items) {
      final price = (item['price_at_time'] as num?)?.toDouble() ?? 0.0;
      final qty = (item['quantity'] as num?)?.toInt() ?? 0;
      subTotal += (price * qty);
    }
    discount = (orderData!['discount_applied'] as num?)?.toDouble() ?? 0;
    totalPayment = (orderData!['total_price'] as num?)?.toDouble() ?? 0;
    shippingCost = totalPayment - subTotal + discount;
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    final String? createdAtStr = orderData?['created_at'];
    if (createdAtStr == null) return;

    final DateTime createdAt = DateTime.parse(createdAtStr).toLocal();
    final DateTime expiryTime = createdAt.add(const Duration(hours: 1));

    _updateRemainingTime(expiryTime);

    if (remainingTime.inSeconds > 0) {
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _updateRemainingTime(expiryTime);
        if (remainingTime.inSeconds <= 0) {
          timer.cancel();
        }
      });
    }
  }

  void _updateRemainingTime(DateTime expiryTime) {
    final now = DateTime.now();
    final difference = expiryTime.difference(now);
    if (difference.isNegative) {
      remainingTime = Duration.zero;
    } else {
      remainingTime = difference;
    }
    notifyListeners();
  }

  String get formattedRemainingTime {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(remainingTime.inHours);
    final minutes = twoDigits(remainingTime.inMinutes.remainder(60));
    final seconds = twoDigits(remainingTime.inSeconds.remainder(60));
    return "$hours : $minutes : $seconds";
  }

  Future<bool> cancelOrder() async {
    if (orderData == null) return false;
    isLoading = true;
    notifyListeners();
    try {
      await _service.updateOrderStatus(orderData!['id'], 'Dibatalkan');
      await fetchOrder(orderData!['id']);
      HistoryViewModel().fetchHistory();
      return true;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> receiveOrder() async {
    if (orderData == null) return false;
    isLoading = true;
    notifyListeners();
    try {
      await _service.updateOrderStatus(orderData!['id'], 'Selesai');
      await fetchOrder(orderData!['id']);
      HistoryViewModel().fetchHistory();
      return true;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _pollingTimer?.cancel();
    super.dispose();
  }
}