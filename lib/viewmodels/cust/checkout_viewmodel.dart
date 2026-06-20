import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import '../../utils/image_picker_util.dart';
import '../../services/cust/checkout_service.dart';
import 'cart_viewmodel.dart';
import 'dart:math' as math;
import '../../services/payments/midtrans_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/voucher_model.dart';
import '../../models/cart_model.dart';
import '../../models/address_model.dart';

class CheckoutViewModel extends ChangeNotifier {
  final CheckoutService _service = CheckoutService();
  final ImagePickerUtil _imagePickerUtil = ImagePickerUtil();
  final MidtransService _midtransService = MidtransService();

  bool isLoading = false;
  bool isPlacingOrder = false;
  String? errorMessage;

  String shippingMethod = 'Delivery';
  String paymentMethod = 'COD';
  String? selectedBank;

  File? paymentProofFile;

  AddressModel? deliveryAddress;
  List<CartItemModel> selectedCartItems = [];

  VoucherModel? selectedVoucher;

  double subTotal = 0;
  double shippingCost = 0;
  double discount = 0;
  double get totalPayment => subTotal + shippingCost - discount;

  double _calculateDistanceInMeters(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const p = 0.017453292519943295;
    var a =
        0.5 -
        math.cos((lat2 - lat1) * p) / 2 +
        math.cos(lat1 * p) *
            math.cos(lat2 * p) *
            (1 - math.cos((lon2 - lon1) * p)) /
            2;
    return 12742 * math.asin(math.sqrt(a)) * 1000;
  }

  final Map<String, String> bankCodes = {
    'BCA': 'bca',
    'BNI': 'bni',
    'BRI': 'bri',
    'Mandiri': 'echannel',
    'Permata': 'permata',
  };

  Future<void> initCheckoutData({VoucherModel? initialVoucher}) async {
    isLoading = true;
    notifyListeners();

    try {
      deliveryAddress = await _service.fetchDefaultAddress();

      final cartVM = CartViewModel();
      await cartVM.loadCartData();

      selectedCartItems = cartVM.cartItems
          .where((item) => cartVM.selectedItemIds.contains(item.id))
          .toList();

      selectedVoucher = initialVoucher;

      _calculateSummary();
      _calculateDistance();
    } catch (e) {
      errorMessage = "Gagal memuat data checkout: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void selectVoucher(VoucherModel? voucher) {
    selectedVoucher = voucher;
    _calculateSummary();
    notifyListeners();
  }

  void setShippingMethod(String method) {
    shippingMethod = method;
    if (method == 'Pickup') {
      shippingCost = 0;
    } else {
      _calculateDistance();
    }
    _calculateSummary();
    notifyListeners();
  }

  void setPaymentMethod(String method) {
    paymentMethod = method;
    if (method != 'Virtual Account Bank') {
      selectedBank = null;
    }
    notifyListeners();
  }

  void setBank(String? bank) {
    selectedBank = bank;
    notifyListeners();
  }

  void updateSelectedAddress(AddressModel? address) {
    deliveryAddress = address;
    if (shippingMethod == 'Delivery') {
      _calculateDistance();
    }
    notifyListeners();
  }

  Future<void> pickPaymentProof() async {
    final file = await _imagePickerUtil.pickFromGallery();
    if (file != null) {
      paymentProofFile = file;
      notifyListeners();
    }
  }

  void _calculateSummary() {
    subTotal = selectedCartItems.fold(
      0,
      (sum, item) => sum + (item.menuPrice * item.quantity),
    );

    if (selectedVoucher != null) {
      discount = subTotal * (selectedVoucher!.discountPercentage / 100);
    } else {
      discount = 0;
    }
  }

  void _calculateDistance() {
    if (deliveryAddress == null) {
      shippingCost = 0;
      _calculateSummary();
      return;
    }

    final double adminLat = -8.164506;
    final double adminLng = 113.716869;

    try {
      double distanceInMeters = _calculateDistanceInMeters(
        deliveryAddress!.latitude,
        deliveryAddress!.longitude,
        adminLat,
        adminLng,
      );

      double distanceInKm = distanceInMeters / 1000;

      if (distanceInKm <= 5) {
        shippingCost = 0;
      } else {
        int extraKm = distanceInKm.ceil() - 5;
        shippingCost = (extraKm * 10000).toDouble();
      }
    } catch (e) {
      debugPrint('Error calculating distance: $e');
      shippingCost = 0;
    }

    _calculateSummary();
  }

  Future<Map<String, dynamic>?> placeOrder() async {
    if (shippingMethod == 'Delivery' && deliveryAddress == null) {
      errorMessage = 'Silakan pilih alamat pengiriman';
      notifyListeners();
      return null;
    }

    if (paymentMethod == 'Transfer Bank' && paymentProofFile == null) {
      errorMessage = 'Silakan unggah bukti pembayaran';
      notifyListeners();
      return null;
    }

    if (paymentMethod == 'Virtual Account Bank' && selectedBank == null) {
      errorMessage = 'Silakan pilih bank untuk Virtual Account';
      notifyListeners();
      return null;
    }

    isPlacingOrder = true;
    errorMessage = null;
    notifyListeners();

    try {
      String? proofUrl;
      if (paymentProofFile != null) {
        proofUrl = await _service.uploadPaymentProof(paymentProofFile!);
      }

      final userId = _service.getCurrentUserId();

      final orderData = {
        'user_id': userId,
        'total_price': totalPayment,
        'delivery_type': shippingMethod,
        'status': 'Menunggu Pembayaran',
        'notes': selectedCartItems.map((e) => e.notes).join(', '),
        'address_detail': shippingMethod == 'Delivery'
            ? deliveryAddress!.addressDetail
            : 'Diambil di Toko',
        'payment_method': paymentMethod,
        'payment_proof_url': proofUrl,
        'latitude': shippingMethod == 'Delivery'
            ? deliveryAddress!.latitude
            : null,
        'longitude': shippingMethod == 'Delivery'
            ? deliveryAddress!.longitude
            : null,
        'voucher_id': selectedVoucher?.id,
        'discount_applied': discount,
      };

      final orderId = await _service.placeOrder(
        orderData: orderData,
        cartItems: selectedCartItems,
      );

      if (paymentMethod == 'Virtual Account Bank') {
        final transactionResponse = await _midtransService.createTransaction(
          orderId: orderId,
          grossAmount: totalPayment.toInt(),
          customerName: deliveryAddress?.recipientName ?? 'Customer',
          customerPhone: deliveryAddress?.phoneNumber ?? '0800000000',
          bank: bankCodes[selectedBank!]!,
        );

        String vaNumber = 'Gagal membuat VA';
        if (bankCodes[selectedBank!] == 'echannel') {
          vaNumber =
              '${transactionResponse['biller_code'] ?? ''} ${transactionResponse['bill_key'] ?? ''}';
        } else {
          final vaNumbers = transactionResponse['va_numbers'] as List<dynamic>?;
          if (vaNumbers != null && vaNumbers.isNotEmpty) {
            vaNumber = vaNumbers[0]['va_number'];
          }
        }

        await Supabase.instance.client
            .from('orders')
            .update({
              'va_number': vaNumber,
              'va_expiry_time': DateTime.now()
                  .add(const Duration(hours: 1))
                  .toIso8601String(),
            })
            .eq('id', orderId);
      }

      return {'orderId': orderId};
    } catch (e) {
      errorMessage = e.toString();
      return null;
    } finally {
      isPlacingOrder = false;
      notifyListeners();
    }
  }
}
