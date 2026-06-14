import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/order_model.dart';
import '../../services/admin/admin_order_service.dart';
import '../../services/pdf/pdf_export_service.dart';

class AdminOrderManagementViewModel extends ChangeNotifier {
  final AdminOrderService _service = AdminOrderService();

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<OrderManagementModel> _todayOrders = [];
  List<OrderManagementModel> get todayOrders => _todayOrders;

  List<OrderManagementModel> _yesterdayOrders = [];
  List<OrderManagementModel> get yesterdayOrders => _yesterdayOrders;

  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  bool get isFiltering => selectedStartDate != null && selectedEndDate != null;

  List<OrderManagementModel> _filteredOrders = [];
  List<OrderManagementModel> get filteredOrders => _filteredOrders;

  Future<void> fetchOrders({DateTime? start, DateTime? end}) async {
    _isLoading = true;

    if (start != null && end != null) {
      selectedStartDate = start;
      selectedEndDate = DateTime(end.year, end.month, end.day, 23, 59, 59);
    } else {
      selectedStartDate = null;
      selectedEndDate = null;
    }
    notifyListeners();

    try {
      final response = await _service.getAllOrders(
        startDate: selectedStartDate,
        endDate: selectedEndDate,
      );

      List<OrderManagementModel> tempParsed = (response as List)
          .map((data) => OrderManagementModel.fromJson(data))
          .toList();

      if (isFiltering) {
        _filteredOrders = tempParsed;
      } else {
        final now = DateTime.now();
        final todayStart = DateTime(now.year, now.month, now.day);

        List<OrderManagementModel> tempToday = [];
        List<OrderManagementModel> tempYesterday = [];

        for (var orderModel in tempParsed) {
          if (orderModel.createdAt.isAfter(todayStart) ||
              orderModel.createdAt.isAtSameMomentAs(todayStart)) {
            tempToday.add(orderModel);
          } else {
            tempYesterday.add(orderModel);
          }
        }
        _todayOrders = tempToday;
        _yesterdayOrders = tempYesterday;
      }
    } catch (e) {
      debugPrint("Error fetching admin orders: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearFilter() => fetchOrders();

  String getTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return "Just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes} Mins Ago";
    if (diff.inHours < 24) return "${diff.inHours} Hours Ago";
    return DateFormat('EEEE, MMM d, yyyy').format(date);
  }

  String formatCurrency(double amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 0,
    ).format(amount);
  }

  final PdfExportService _pdfService = PdfExportService();

  Future<void> exportToPdf() async {
    try {
      final allOrders = isFiltering
          ? filteredOrders
          : [...todayOrders, ...yesterdayOrders];
      if (allOrders.isEmpty)
        throw Exception('Tidak ada data pesanan untuk di-export.');
      await _pdfService.exportOrdersToPdf(allOrders);
    } catch (e) {
      debugPrint("Gagal Export PDF: $e");
      rethrow;
    }
  }
}
