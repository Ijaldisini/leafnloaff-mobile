import 'package:flutter/material.dart';
import '../../models/voucher_model.dart';
import '../../services/admin/admin_voucher_service.dart';

class AdminVoucherViewModel extends ChangeNotifier {
  final VoucherService _voucherService = VoucherService();

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<VoucherModel> _vouchers = [];
  String _searchQuery = '';

  Future<void> fetchVouchers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _vouchers = await _voucherService.fetchVouchers();
    } catch (e) {
      _errorMessage = "Gagal memuat data voucher: $e";
      debugPrint("Error fetching vouchers: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchVoucher(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }

  List<VoucherModel> get filteredVouchers {
    if (_searchQuery.isEmpty) return _vouchers;

    return _vouchers.where((v) {
      return v.title.toLowerCase().contains(_searchQuery);
    }).toList();
  }

  String formatExpiryDate(DateTime createdAt) {
    final expiryDate = createdAt.add(const Duration(days: 30));
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[expiryDate.month - 1]} ${expiryDate.day}, ${expiryDate.year}';
  }
}
