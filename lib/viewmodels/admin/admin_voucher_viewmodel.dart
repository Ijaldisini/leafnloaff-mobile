import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/voucher_model.dart';
import '../../services/admin/admin_voucher_service.dart';

class AdminVoucherViewModel extends ChangeNotifier {
  final VoucherService _voucherService = VoucherService();

  StreamSubscription<List<Map<String, dynamic>>>? _voucherSubscription;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<VoucherModel> _vouchers = [];
  String _searchQuery = '';

  AdminVoucherViewModel() {
    _listenToVouchers();
  }

  void _listenToVouchers() {
    _voucherSubscription = _voucherService.streamVouchers().listen(
      (data) {
        _vouchers = data.map((json) => VoucherModel.fromJson(json)).toList();
        _errorMessage = null;

        if (_isLoading) {
          _isLoading = false;
        }
        notifyListeners();
      },
      onError: (error) {
        _errorMessage = "Gagal memuat data voucher: $error";
        debugPrint("Error streaming vouchers: $error");

        if (_isLoading) {
          _isLoading = false;
        }
        notifyListeners();
      },
    );
  }

  Future<void> fetchVouchers() async {
    await Future.delayed(const Duration(milliseconds: 300));
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
    return '${months[expiryDate.month - 1]} ${expiryDate.day.toString().padLeft(2, '0')}, ${expiryDate.year}';
  }

  @override
  void dispose() {
    _voucherSubscription?.cancel();
    super.dispose();
  }
}
