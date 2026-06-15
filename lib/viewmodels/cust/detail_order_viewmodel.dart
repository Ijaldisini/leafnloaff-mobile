import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/order_model.dart';
import '../../services/cust/detail_order_service.dart';
import '../../services/payments/midtrans_service.dart';

class DetailOrderViewModel extends ChangeNotifier {
  final DetailOrderService _service = DetailOrderService();
  final MidtransService _midtransService = MidtransService();

  bool isLoading = true;
  String? errorMessage;

  OrderDetailModel? orderDetail;
  bool isReviewed = false;
  bool _isDisposed = false;

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
    _safeNotifyListeners();

    try {
      orderDetail = await _service.fetchOrderDetails(orderId);

      if (orderDetail != null) {
        _calculateSummary();

        if (orderDetail!.status == 'Selesai') {
          final reviewCheck = await Supabase.instance.client
              .from('reviews')
              .select('id')
              .eq('order_id', orderId)
              .limit(1)
              .maybeSingle();

          isReviewed = reviewCheck != null;
        }

        if (orderDetail!.status == 'Menunggu Pembayaran') {
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
      _safeNotifyListeners();
    }
  }

  void _startPollingPaymentStatus(String orderId) {
    _pollingTimer?.cancel();

    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (_isDisposed) {
        timer.cancel();
        return;
      }
      try {
        final response = await _midtransService.checkTransactionStatus(orderId);
        final transactionStatus = response['transaction_status'];

        if (transactionStatus == 'settlement' ||
            transactionStatus == 'capture') {
          _stopTimers();
          await _service.updateOrderStatus(orderId, 'Diproses');
          await fetchOrder(orderId);
        } else if (transactionStatus == 'expire' ||
            transactionStatus == 'cancel') {
          _stopTimers();
          await _service.updateOrderStatus(orderId, 'Dibatalkan');
          await fetchOrder(orderId);
        }
      } catch (e) {
        debugPrint("Polling status error: $e");
      }
    });
  }

  void _calculateSummary() {
    if (orderDetail == null) return;
    subTotal = 0;
    for (var item in orderDetail!.items) {
      subTotal += (item.priceAtTime * item.quantity);
    }
    discount = orderDetail!.discountApplied;
    totalPayment = orderDetail!.totalPrice;
    shippingCost = totalPayment - subTotal + discount;
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    if (orderDetail == null) return;

    final DateTime expiryTime = orderDetail!.createdAt.add(
      const Duration(hours: 1),
    );

    _updateRemainingTime(expiryTime);

    if (remainingTime.inSeconds > 0) {
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_isDisposed) {
          timer.cancel();
          return;
        }
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
    _safeNotifyListeners();
  }

  String get formattedRemainingTime {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(remainingTime.inHours);
    final minutes = twoDigits(remainingTime.inMinutes.remainder(60));
    final seconds = twoDigits(remainingTime.inSeconds.remainder(60));
    return "$hours : $minutes : $seconds";
  }

  Future<bool> cancelOrder() async {
    if (orderDetail == null) return false;
    isLoading = true;
    _safeNotifyListeners();
    try {
      await _service.updateOrderStatus(orderDetail!.id, 'Dibatalkan');
      await fetchOrder(orderDetail!.id);
      return true;
    } catch (e) {
      isLoading = false;
      _safeNotifyListeners();
      return false;
    }
  }

  Future<bool> receiveOrder() async {
    if (orderDetail == null) return false;
    isLoading = true;
    _safeNotifyListeners();
    try {
      await _service.updateOrderStatus(orderDetail!.id, 'Selesai');
      await fetchOrder(orderDetail!.id);
      return true;
    } catch (e) {
      isLoading = false;
      _safeNotifyListeners();
      return false;
    }
  }

  void _stopTimers() {
    _pollingTimer?.cancel();
    _countdownTimer?.cancel();
  }

  void _safeNotifyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _stopTimers();
    super.dispose();
  }
}
