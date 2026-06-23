import 'package:flutter/material.dart';
import '../../models/voucher_model.dart';
import '../../services/cust/voucher_service.dart';

class SelectVoucherViewModel extends ChangeNotifier {
  final CustVoucherService _service = CustVoucherService();

  bool isLoading = false;

  List<VoucherModel> vouchers = [];
  VoucherModel? selectedVoucher;

  void initVoucherData(
    VoucherModel? initialVoucher, {
    Function(String)? onError,
  }) {
    selectedVoucher = initialVoucher;
    fetchVouchers(onError: onError);
  }

  Future<void> fetchVouchers({Function(String)? onError}) async {
    isLoading = true;
    notifyListeners();

    try {
      vouchers = await _service.fetchActiveVouchers();
    } catch (e) {
      debugPrint("Gagal memuat voucher: $e");
      onError?.call("Gagal memuat voucher: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void toggleVoucherSelection(VoucherModel voucher) {
    if (selectedVoucher != null && selectedVoucher!.id == voucher.id) {
      selectedVoucher = null;
    } else {
      selectedVoucher = voucher;
    }
    notifyListeners();
  }
}
