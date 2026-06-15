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
        final now = DateTime.now();
        List<VoucherModel> parsedVouchers = [];

        for (var json in data) {
          final expiresAt = json['expires_at'] != null
              ? DateTime.parse(json['expires_at']).toLocal()
              : DateTime.parse(
                  json['created_at'],
                ).toLocal().add(const Duration(days: 30));

          bool isActive = json['is_active'] ?? false;

          if (isActive && now.isAfter(expiresAt)) {
            _voucherService.deactivateVoucher(json['id']);
            json['is_active'] = false;
          }

          parsedVouchers.add(VoucherModel.fromJson(json));
        }

        _vouchers = parsedVouchers;
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
    List<VoucherModel> result = List.from(_vouchers);

    if (_searchQuery.isNotEmpty) {
      result = result.where((v) {
        return v.title.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    result.sort((a, b) {
      if (a.isActive && !b.isActive) return -1;
      if (!a.isActive && b.isActive) return 1;
      return b.createdAt.compareTo(a.createdAt);
    });

    return result;
  }

  String formatExpiryDate(DateTime expiresAt) {
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
    return '${months[expiresAt.month - 1]} ${expiresAt.day.toString().padLeft(2, '0')}, ${expiresAt.year}';
  }

  @override
  void dispose() {
    _voucherSubscription?.cancel();
    super.dispose();
  }
}
