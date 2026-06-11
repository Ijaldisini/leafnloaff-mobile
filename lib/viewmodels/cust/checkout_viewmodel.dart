import 'dart:io';
import 'package:flutter/material.dart';
import '../../utils/image_picker_util.dart';
import '../../services/cust/checkout_service.dart';
import 'cart_viewmodel.dart';
import 'package:geolocator/geolocator.dart';
import '../../services/payments/midtrans_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/voucher_model.dart';

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
  String? paymentProofUrl;

  Map<String, dynamic>? deliveryAddress;
  List<Map<String, dynamic>> selectedCartItems = [];

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

      adminLocation = await _service.fetchAdminLocation();
      deliveryAddress = await _service.fetchDefaultAddress();

      _calculateShippingCost();
      _recalculateDiscount();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void updateSelectedAddress(Map<String, dynamic> newAddress) {
    deliveryAddress = newAddress;
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

      if (deliveryAddress!['latitude'] == null ||
          deliveryAddress!['longitude'] == null) {
        shippingCost = 0;
        debugPrint('Koordinat alamat customer kosong!');
        return;
      }

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
      shippingCost = 0;
    }
  }

  void selectVoucher(VoucherModel? voucher) {
    selectedVoucher = voucher;
    _recalculateDiscount();
    notifyListeners();
  }

  void _recalculateDiscount() {
    if (selectedVoucher != null) {
      final percentage = (selectedVoucher!.discountPercentage).toDouble();
      discount = (subTotal * percentage / 100);
    } else {
      discount = 0;
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
            ? deliveryAddress!['address_detail']
            : null,
        'latitude': shippingMethod == 'Delivery'
            ? deliveryAddress!['latitude']
            : null,
        'longitude': shippingMethod == 'Delivery'
            ? deliveryAddress!['longitude']
            : null,
        'payment_method': paymentMethod,
        'payment_proof_url': proofUrl,
        'status': paymentMethod == 'COD' ? 'Diproses' : 'Menunggu Pembayaran',
        'notes': 'Pesanan dari aplikasi mobile',
        // ID DIAMBIL DARI MODEL VOUCHER
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
          customerName: deliveryAddress?['recipient_name'] ?? 'Customer',
          customerPhone: deliveryAddress?['phone_number'] ?? '0800000000',
          bank: bankCodes[selectedBank!]!,
        );

        String vaNumber = 'Gagal membuat VA';

        if (bankCodes[selectedBank!] == 'echannel') {
          final billerCode = transactionResponse['biller_code'] ?? '';
          final billKey = transactionResponse['bill_key'] ?? '';
          vaNumber = '$billerCode $billKey';
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
      errorMessage = "Gagal memproses pesanan: $e";
      return null;
    } finally {
      isPlacingOrder = false;
      notifyListeners();
    }
  }
}
