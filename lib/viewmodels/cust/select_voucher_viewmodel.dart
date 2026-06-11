import 'package:flutter/material.dart';
import '../../models/voucher_model.dart';
import '../../services/cust/voucher_service.dart';

class SelectVoucherViewModel extends ChangeNotifier {
  final CustVoucherService _service = CustVoucherService();

  bool isLoading = false;
  String? errorMessage;

  List<VoucherModel> vouchers = [];
  VoucherModel? selectedVoucher;

  void initVoucherData(VoucherModel? initialVoucher) {
    selectedVoucher = initialVoucher;
    fetchVouchers();
  }

  Future<void> fetchVouchers() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      vouchers = await _service.fetchActiveVouchers();
    } catch (e) {
      errorMessage = "Gagal memuat voucher: $e";
      debugPrint(errorMessage);
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
