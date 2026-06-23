import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../viewmodels/cust/history_viewmodel.dart';
import '../../services/cust/history_service.dart';
import '../../models/order_model.dart';
import 'detail_order_view.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  late final HistoryViewModel _viewModel;
  bool _isInitialLoad = true;

  @override
  void initState() {
    super.initState();
    _viewModel = HistoryViewModel(service: HistoryService());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.fetchHistory(onError: _showErrorDialog).then((_) {
        if (mounted) {
          setState(() {
            _isInitialLoad = false;
          });
        }
      });
    });
  }

  void _showErrorDialog(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.error_outline, color: Color(0xFFC23437)),
              SizedBox(width: 10),
              Text(
                'Peringatan',
                style: TextStyle(
                  color: Color(0xFF2D4839),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: const TextStyle(
              color: Color(0xFF51725F),
              fontFamily: 'Poppins',
              fontSize: 14,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC23437),
              ),
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _refreshHistory() async {
    await _viewModel.fetchHistory(onError: _showErrorDialog);
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF3D5A4A),
      body: Stack(
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
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                      const Text(
                        'History',
                        style: TextStyle(
                          color: Color(0xFFFDFDFD),
                          fontSize: 25,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w800,
                          shadows: [
                            Shadow(
                              offset: Offset(2, 2),
                              blurRadius: 4,
                              color: Colors.black26,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListenableBuilder(
                    listenable: _viewModel,
                    builder: (context, _) {
                      if (_viewModel.isLoading && _isInitialLoad) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      }
                      if (_viewModel.groupedOrders.isEmpty) {
                        return const Center(
                          child: Text(
                            'Belum ada riwayat pesanan.',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        );
                      }

                      return RefreshIndicator(
                        color: const Color(0xFFCA748D),
                        backgroundColor: Colors.white,
                        onRefresh: _refreshHistory,
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 20),
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          itemCount: _viewModel.groupedOrders.keys.length,
                          itemBuilder: (context, index) {
                            final dateKey = _viewModel.groupedOrders.keys
                                .elementAt(index);
                            final orders = _viewModel.groupedOrders[dateKey]!;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 25,
                                    vertical: 10,
                                  ),
                                  child: Text(
                                    dateKey,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                ...orders.map(
                                  (order) => _buildOrderCard(order),
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(OrderHistoryModel order) {
    bool isFinished = order.status == 'Selesai';
    final priceFormatted = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(order.totalPrice);

    int currentStep = 0;
    final s = order.status.toLowerCase();
    if (s.contains('tunggu') ||
        s.contains('bayar') ||
        s.contains('masuk') ||
        s.contains('konfirmasi'))
      currentStep = 0;
    else if (s.contains('proses') || s.contains('siap'))
      currentStep = 1;
    else if (s.contains('kirim') || s.contains('jalan') || s.contains('otw'))
      currentStep = 2;
    else if (s.contains('selesai') || s.contains('delivered'))
      currentStep = 3;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFDFDFD),
        borderRadius: BorderRadius.circular(16.69),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order #${order.id.substring(0, 8).toUpperCase()}',
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
          const SizedBox(height: 12),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: 'Product: ',
                  style: TextStyle(
                    color: Color(0xFF51725F),
                    fontSize: 13,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: order.productNames,
                  style: const TextStyle(
                    color: Color(0xFF51725F),
                    fontSize: 13,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: 'Qty: ',
                  style: TextStyle(
                    color: Color(0xFF51725F),
                    fontSize: 13,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: '${order.totalQuantity}',
                  style: const TextStyle(
                    color: Color(0xFF51725F),
                    fontSize: 13,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = constraints.maxWidth;
              final stepWidth = maxWidth / 3;
              double progressWidth = 0;
              if (currentStep == 1) progressWidth = stepWidth;
              if (currentStep == 2) progressWidth = stepWidth * 2;
              if (currentStep >= 3) progressWidth = maxWidth;

              return Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 6,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF848484),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        height: 6,
                        width: progressWidth,
                        decoration: BoxDecoration(
                          color: const Color(0xFFCA748D),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Preparing',
                        style: TextStyle(
                          color: currentStep >= 1
                              ? const Color(0xFF2D4839)
                              : Colors.grey,
                          fontSize: 11,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'On The Way',
                        style: TextStyle(
                          color: currentStep >= 2
                              ? const Color(0xFF2D4839)
                              : Colors.grey,
                          fontSize: 11,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Delivered',
                        style: TextStyle(
                          color: currentStep >= 3
                              ? const Color(0xFF2D4839)
                              : Colors.grey,
                          fontSize: 11,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),

          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailOrderView(orderId: order.id),
                ),
              ).then((_) => _viewModel.fetchHistory(onError: _showErrorDialog));
            },
            child: Container(
              width: 120,
              height: 28,
              decoration: ShapeDecoration(
                color: isFinished
                    ? const Color(0xFF333333)
                    : const Color(0xFFEED5DB),
                shape: RoundedRectangleBorder(
                  side: isFinished
                      ? BorderSide.none
                      : const BorderSide(width: 1, color: Color(0xFFCA748D)),
                  borderRadius: BorderRadius.circular(55.60),
                ),
              ),
              child: Center(
                child: Text(
                  isFinished ? 'Write a Review' : 'See Detail',
                  style: TextStyle(
                    color: isFinished
                        ? const Color(0xFFFBFBFB)
                        : const Color(0xFFCA748D),
                    fontSize: 11,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
