import 'dart:io';
import 'package:flutter/material.dart';
import '../../utils/image_picker_util.dart';
import '../../services/cust/checkout_service.dart';
import 'cart_viewmodel.dart';
import 'package:geolocator/geolocator.dart';
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
  Map<String, double>? adminLocation;

  double subTotal = 0;
  double shippingCost = 0;
  double discount = 0;
  double get totalPayment => subTotal + shippingCost - discount;

  final Map<String, String> bankCodes = {
    'BCA Virtual Account': 'bca',
    'Mandiri Virtual Account': 'echannel',
    'BNI Virtual Account': 'bni',
    'BRI Virtual Account': 'bri',
  };

  Future<void> initCheckoutData({VoucherModel? initialVoucher}) async {
    isLoading = true;
    notifyListeners();

    try {
      final cartVM = CartViewModel();
      selectedCartItems = cartVM.cartItems
          .where((item) => cartVM.selectedItemIds.contains(item.id))
          .toList();

      subTotal = 0;
      for (var item in selectedCartItems) {
        subTotal += (item.menuPrice * item.quantity);
      }

      adminLocation = await _service.fetchAdminLocation();
      deliveryAddress = await _service.fetchDefaultAddress();

      if (initialVoucher != null) selectedVoucher = initialVoucher;

      _calculateShippingCost();
      _recalculateDiscount();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void updateSelectedAddress(dynamic newAddress) {
    if (newAddress is AddressModel) {
      deliveryAddress = newAddress;
    } else if (newAddress is Map<String, dynamic>) {
      deliveryAddress = AddressModel.fromJson(newAddress);
    }
    _calculateShippingCost();
    _recalculateDiscount();
    notifyListeners();
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
      final double storeLatitude = adminLocation?['latitude'] ?? -8.1689;
      final double storeLongitude = adminLocation?['longitude'] ?? 113.7020;

      if (deliveryAddress!.latitude == 0.0 &&
          deliveryAddress!.longitude == 0.0) {
        shippingCost = 0;
        return;
      }

      double distanceInMeters = Geolocator.distanceBetween(
        storeLatitude,
        storeLongitude,
        deliveryAddress!.latitude,
        deliveryAddress!.longitude,
      );

      double distanceInKm = distanceInMeters / 1000;
      shippingCost = distanceInKm <= 5.0
          ? 0
          : (distanceInKm - 5.0).ceil() * 10000.0;
    } catch (e) {
      shippingCost = 0;
    }
  }

  void selectVoucher(VoucherModel? voucher) {
    selectedVoucher = voucher;
    _recalculateDiscount();
    notifyListeners();
  }

  void _recalculateDiscount() {
    discount = selectedVoucher != null
        ? (subTotal * selectedVoucher!.discountPercentage / 100)
        : 0;
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

  Future<Map<String, dynamic>?> placeOrder() async {
    if (shippingMethod == 'Delivery' && deliveryAddress == null) {
      errorMessage = "Alamat pengiriman harus diisi!";
      notifyListeners();
      return null;
    }
    if (paymentMethod == 'QRIS Statis' && paymentProofFile == null) {
      errorMessage = "Harap unggah bukti pembayaran QRIS!";
      notifyListeners();
      return null;
    }
    if (paymentMethod == 'Virtual Account Bank' && selectedBank == null) {
      errorMessage = "Harap pilih bank terlebih dahulu!";
      notifyListeners();
      return null;
    }

    isPlacingOrder = true;
    errorMessage = null;
    notifyListeners();

    try {
      String? proofUrl;
      if (paymentMethod == 'QRIS Statis' && paymentProofFile != null) {
        proofUrl = await _service.uploadPaymentProof(paymentProofFile!);
      }

      final orderData = {
        'user_id': _service.getCurrentUserId(),
        'total_price': totalPayment,
        'delivery_type': shippingMethod,
        'address_detail': shippingMethod == 'Delivery'
            ? deliveryAddress!.addressDetail
            : null,
        'latitude': shippingMethod == 'Delivery'
            ? deliveryAddress!.latitude
            : null,
        'longitude': shippingMethod == 'Delivery'
            ? deliveryAddress!.longitude
            : null,
        'payment_method': paymentMethod,
        'payment_proof_url': proofUrl,
        'status': paymentMethod == 'COD' ? 'Diproses' : 'Menunggu Pembayaran',
        'notes': paymentMethod == 'Virtual Account Bank'
            ? 'Pesanan ($selectedBank)'
            : 'Pesanan aplikasi',
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
          if (vaNumbers != null && vaNumbers.isNotEmpty)
            vaNumber = vaNumbers[0]['va_number'];
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
      errorMessage = e.toString().replaceAll('Exception: ', '');
      return null;
    } finally {
      isPlacingOrder = false;
      notifyListeners();
    }
  }
}
