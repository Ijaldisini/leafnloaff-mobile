import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../viewmodels/admin/admin_order_management_viewmodel.dart';
import '../../models/order_model.dart';
import 'admin_order_detail_view.dart';

class AdminOrderManagementView extends StatefulWidget {
  const AdminOrderManagementView({super.key});

  @override
  State<AdminOrderManagementView> createState() =>
      _AdminOrderManagementViewState();
}

class _AdminOrderManagementViewState extends State<AdminOrderManagementView> {
  final AdminOrderManagementViewModel _viewModel =
      AdminOrderManagementViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.fetchOrders();
  }

  Future<void> _handlePdfExport() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Menyiapkan file PDF...'),
          duration: Duration(seconds: 1),
          backgroundColor: Color(0xFF51725F),
        ),
      );

      await _viewModel.exportToPdf();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: const Color(0xFFC23437),
          ),
        );
      }
    }
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFCA748D),
              onPrimary: Colors.white,
              onSurface: Color(0xFF2D4839),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      _viewModel.fetchOrders(start: picked.start, end: picked.end);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF3D5A4A),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, child) {
          if (_viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFD699AB)),
            );
          }

          String periodText = 'Select period';
          if (_viewModel.isFiltering) {
            final startStr = DateFormat(
              'dd MMM yyyy',
            ).format(_viewModel.selectedStartDate!);
            final endStr = DateFormat(
              'dd MMM yyyy',
            ).format(_viewModel.selectedEndDate!);
            periodText = '$startStr - $endStr';
          }

          return Stack(
            children: [
              Positioned(
                left: -17,
                top: -30,
                child: Container(
                  width: screenWidth + 34,
                  height: 289,
                  decoration: const BoxDecoration(color: Color(0xFFD699AB)),
                ),
              ),
              Positioned(
                left: -17,
                top: 147,
                child: Container(
                  width: screenWidth + 34,
                  height: 114,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x003D5A4A), Color(0xFF3D5A4A)],
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: RefreshIndicator(
                  onRefresh: () => _viewModel.fetchOrders(),
                  color: const Color(0xFFCA748D),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(25, 20, 25, 120),
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order Management',
                            style: TextStyle(
                              color: const Color(0xFFFDFDFD),
                              fontSize: 25,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w800,
                              shadows: [
                                Shadow(
                                  offset: const Offset(2, 2),
                                  blurRadius: 4,
                                  color: Colors.black.withValues(alpha: 0.25),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: _handlePdfExport,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: ShapeDecoration(
                                color: const Color(0xFFEED5DB),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                shadows: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.15),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.picture_as_pdf,
                                    color: Color(0xFFCA748D),
                                    size: 18,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'PDF',
                                    style: TextStyle(
                                      color: Color(0xFFCA748D),
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      GestureDetector(
                        onTap: _selectDateRange,
                        child: Container(
                          height: 36,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: ShapeDecoration(
                            color: const Color(0xFFFDFDFD),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(103),
                            ),
                            shadows: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.25),
                                blurRadius: 4,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Text(
                                  periodText,
                                  style: const TextStyle(
                                    color: Color(0xFF51725F),
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              if (_viewModel.isFiltering)
                                GestureDetector(
                                  onTap: _viewModel.clearFilter,
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFC23437),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              else
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF426E55),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.calendar_month,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      if (_viewModel.isFiltering) ...[
                        Text(
                          'Filtered Results',
                          style: TextStyle(
                            color: const Color(0xFFFDFDFD),
                            fontSize: 17,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w800,
                            shadows: [
                              Shadow(
                                offset: const Offset(2, 2),
                                blurRadius: 4,
                                color: Colors.black.withValues(alpha: 0.25),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (_viewModel.filteredOrders.isEmpty)
                          const Text(
                            "Tidak ada order pada periode ini.",
                            style: TextStyle(
                              color: Colors.white70,
                              fontFamily: 'Poppins',
                            ),
                          )
                        else
                          ..._viewModel.filteredOrders.map(
                            (o) => _buildOrderCard(o),
                          ),
                      ] else ...[
                        Text(
                          'Today',
                          style: TextStyle(
                            color: const Color(0xFFFDFDFD),
                            fontSize: 17,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w800,
                            shadows: [
                              Shadow(
                                offset: const Offset(2, 2),
                                blurRadius: 4,
                                color: Colors.black.withValues(alpha: 0.25),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (_viewModel.todayOrders.isEmpty)
                          const Text(
                            "Belum ada order hari ini.",
                            style: TextStyle(
                              color: Colors.white70,
                              fontFamily: 'Poppins',
                            ),
                          )
                        else
                          ..._viewModel.todayOrders.map(
                            (o) => _buildOrderCard(o),
                          ),
                        const SizedBox(height: 25),
                        Text(
                          'Yesterday',
                          style: TextStyle(
                            color: const Color(0xFFFDFDFD),
                            fontSize: 17,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w800,
                            shadows: [
                              Shadow(
                                offset: const Offset(2, 2),
                                blurRadius: 4,
                                color: Colors.black.withValues(alpha: 0.25),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (_viewModel.yesterdayOrders.isEmpty)
                          const Text(
                            "Tidak ada order kemarin.",
                            style: TextStyle(
                              color: Colors.white70,
                              fontFamily: 'Poppins',
                            ),
                          )
                        else
                          ..._viewModel.yesterdayOrders.map(
                            (o) => _buildOrderCard(o),
                          ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(OrderManagementModel order) {
    final statusRaw = order.status;
    final isCanceled =
        statusRaw.toLowerCase() == 'dibatalkan' ||
        statusRaw.toLowerCase() == 'cancelled';
    final isActive = !isCanceled && statusRaw.toLowerCase() != 'selesai';

    final orderIdStr = order.id.length >= 8
        ? order.id.substring(0, 8).toUpperCase()
        : order.id.toUpperCase();
    final timeStr = _viewModel.getTimeAgo(order.createdAt);
    final priceFormatted = _viewModel.formatCurrency(order.totalPrice);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdminOrderDetailView(orderId: order.id),
          ),
        ).then((_) {
          _viewModel.fetchOrders();
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(15),
        decoration: ShapeDecoration(
          color: const Color(0xFFFDFDFD),
          shape: RoundedRectangleBorder(
            side: isActive
                ? const BorderSide(width: 1, color: Color(0xFF73986F))
                : BorderSide.none,
            borderRadius: BorderRadius.circular(16.69),
          ),
          shadows: [
            if (isActive)
              const BoxShadow(color: Color(0xFF73986F), blurRadius: 7)
            else
              const BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 4,
                offset: Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  timeStr,
                  style: const TextStyle(
                    color: Color(0xFF51725F),
                    fontSize: 10,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Text(
                  'See Details',
                  style: TextStyle(
                    color: Color(0xFF51725F),
                    fontSize: 10,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ID: $orderIdStr',
                  style: const TextStyle(
                    color: Color(0xFF2D4839),
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  priceFormatted,
                  style: const TextStyle(
                    color: Color(0xFF2D4839),
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'Product: ',
                    style: TextStyle(
                      color: Color(0xFF51725F),
                      fontSize: 11,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text: order.productDesc,
                    style: const TextStyle(
                      color: Color(0xFF51725F),
                      fontSize: 11,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Qty: ',
                        style: TextStyle(
                          color: Color(0xFF51725F),
                          fontSize: 11,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text: '${order.totalQty}',
                        style: const TextStyle(
                          color: Color(0xFF51725F),
                          fontSize: 11,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isCanceled)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFFFD1D2),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1,
                          color: Color(0xFFC33537),
                        ),
                        borderRadius: BorderRadius.circular(41),
                      ),
                    ),
                    child: const Text(
                      'Canceled',
                      style: TextStyle(
                        color: Color(0xFFC33537),
                        fontSize: 9,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
              ],
            ),
            if (!isCanceled) ...[
              const SizedBox(height: 15),
              _buildStatusTracker(statusRaw),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusTracker(String status) {
    double barWidthFactor;
    String statusStr = status.toLowerCase();

    if (statusStr.contains('tunggu') || statusStr.contains('bayar')) {
      barWidthFactor = 0.15;
    } else if (statusStr.contains('proses') || statusStr.contains('siap')) {
      barWidthFactor = 0.45;
    } else if (statusStr.contains('kirim') || statusStr.contains('jalan')) {
      barWidthFactor = 0.75;
    } else if (statusStr.contains('selesai')) {
      barWidthFactor = 1.0;
    } else {
      barWidthFactor = 0.0;
    }

    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 6,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF848484),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7500),
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: constraints.maxWidth * barWidthFactor,
                  height: 6,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF333333),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7500),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 6),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Waiting', style: _trackerTextStyle),
            Text('Preparing', style: _trackerTextStyle),
            Text('On The Way', style: _trackerTextStyle),
            Text('Delivered', style: _trackerTextStyle),
          ],
        ),
      ],
    );
  }

  static const TextStyle _trackerTextStyle = TextStyle(
    color: Color(0xFF333333),
    fontSize: 10,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w700,
  );
}
