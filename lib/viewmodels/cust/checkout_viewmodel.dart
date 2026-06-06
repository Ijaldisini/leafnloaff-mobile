import 'dart:io';
import 'package:flutter/material.dart';
import '../../utils/image_picker_util.dart';
import '../../services/cust/checkout_service.dart';
import 'cart_viewmodel.dart';
import 'history_viewmodel.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/payments/midtrans_service.dart';

class CheckoutViewModel extends ChangeNotifier {
  final CheckoutService _service = CheckoutService();
  final ImagePickerUtil _imagePickerUtil = ImagePickerUtil();
  final MidtransService _midtransService = MidtransService();

  bool isLoading = false;
  bool isPlacingOrder = false;
  String? errorMessage;

  String shippingMethod = 'Delivery';
  String paymentMethod = 'QRIS Statisx';
  String? selectedBank;

  File? paymentProofFile;
  String? paymentProofUrl;

  Map<String, dynamic>? deliveryAddress;
  List<Map<String, dynamic>> selectedCartItems = [];

  double subTotal = 0;
  double shippingCost = 0;
  double discount = 0;
  double get totalPayment => subTotal + shippingCost - discount;

  Future<void> initCheckoutData() async {
    isLoading = true;
    notifyListeners();

    try {
      final cartVM = CartViewModel();
      selectedCartItems = cartVM.cartItems.where((item) {
        return cartVM.selectedItemIds.contains(item['id'].toString());
      }).toList();

      subTotal = 0;
      for (var item in selectedCartItems) {
        final price = (item['menus']['price'] as num).toDouble();
        final qty = (item['quantity'] as num).toInt();
        subTotal += (price * qty);
      }

      deliveryAddress = await _service.fetchDefaultAddress();

      _calculateShippingCost();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setShippingMethod(String method) {
    shippingMethod = method;
    _calculateShippingCost();
    notifyListeners();
  }

  void _calculateShippingCost() {
    if (shippingMethod != 'Delivery' || deliveryAddress == null) {
      shippingCost = 0;
      return;
    }

    try {
      const double storeLatitude = -8.1689;
      const double storeLongitude = 113.7020;

      final double custLatitude = (deliveryAddress!['latitude'] as num)
          .toDouble();
      final double custLongitude = (deliveryAddress!['longitude'] as num)
          .toDouble();

      double distanceInMeters = Geolocator.distanceBetween(
        storeLatitude,
        storeLongitude,
        custLatitude,
        custLongitude,
      );

      double distanceInKm = distanceInMeters / 1000;

      if (distanceInKm <= 5.0) {
        shippingCost = 0;
      } else {
        double excessDistance = distanceInKm - 5.0;
        shippingCost = excessDistance.ceil() * 10000.0;
      }
    } catch (e) {
      debugPrint('Error memproses perhitungan ongkir: $e');
      shippingCost = 10000;
    }
  }

  void setPaymentMethod(String method) {
    paymentMethod = method;
    if (method != 'Virtual Account Bank') selectedBank = null;
    notifyListeners();
  }

  void setBank(String bankName) {
    selectedBank = bankName;
    notifyListeners();
  }

  Future<void> pickPaymentProof() async {
    try {
      final file = await _imagePickerUtil.pickFromGallery();
      if (file != null) {
        paymentProofFile = file;
        errorMessage = null;
        notifyListeners();
      }
    } catch (e) {
      errorMessage = "Gagal mengambil gambar: $e";
      notifyListeners();
    }
  }

  Future<bool> placeOrder() async {
    if (shippingMethod == 'Delivery' && deliveryAddress == null) {
      errorMessage = "Alamat pengiriman harus diisi!";
      notifyListeners();
      return false;
    }

    if (paymentMethod == 'QRIS Statis' && paymentProofFile == null) {
      errorMessage = "Harap unggah bukti pembayaran QRIS!";
      notifyListeners();
      return false;
    }

    if (paymentMethod == 'Virtual Account Bank' && selectedBank == null) {
      errorMessage = "Harap pilih Bank untuk Virtual Account!";
      notifyListeners();
      return false;
    }

    isPlacingOrder = true;
    errorMessage = null;
    notifyListeners();

    try {
      final orderData = {
        'user_id': _service.getCurrentUserId(),
        'total_price': totalPayment,
        'delivery_type': shippingMethod,
        'address_detail': shippingMethod == 'Delivery' ? deliveryAddress!['address_detail'] : null,
        'latitude': shippingMethod == 'Delivery' ? deliveryAddress!['latitude'] : null,
        'longitude': shippingMethod == 'Delivery' ? deliveryAddress!['longitude'] : null,
        'payment_method': paymentMethod,
        'status': paymentMethod == 'COD' ? 'Diproses' : 'Menunggu Pembayaran',
        'discount_applied': discount,
        'notes': 'Pesanan dari aplikasi mobile',
      };

      final orderId = await _service.placeOrder(
        orderData: orderData,
        cartItems: selectedCartItems,
      );

      CartViewModel().selectedItemIds.clear();
      CartViewModel().loadCartData(); 
      HistoryViewModel().fetchHistory(); 

      if (paymentMethod != 'COD') {
        final paymentUrl = await _midtransService.createTransaction(
          orderId: orderId,
          grossAmount: totalPayment.toInt(),
          customerName: deliveryAddress?['recipient_name'] ?? 'Customer',
          customerPhone: deliveryAddress?['phone_number'] ?? '0800000000',
        );

        if (paymentUrl != null) {
          final Uri url = Uri.parse(paymentUrl);
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
      }

      return true;
    } catch (e) {
      errorMessage = "Gagal memproses pesanan: $e";
      return false;
    } finally {
      isPlacingOrder = false;
      notifyListeners();
    }
  }
}