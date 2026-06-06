import 'package:flutter/material.dart';
import '../../viewmodels/cust/history_viewmodel.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  final HistoryViewModel _viewModel = HistoryViewModel();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.fetchHistory();
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3D5A4A),
      body: Stack(
        children: [
          Positioned(
            left: -17,
            top: -30,
            child: Container(
              width: 422,
              height: 289,
              decoration: const BoxDecoration(color: Color(0xFFD699AB)),
            ),
          ),
          Positioned(
            left: -17,
            top: 147,
            child: Container(
              width: 422,
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                            onPressed: () {
                              Navigator.pop(context);
                            },
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
                    builder: (context, child) {
                      if (_viewModel.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      }
                      if (_viewModel.errorMessage != null) {
                        return Center(
                          child: Text(
                            _viewModel.errorMessage!,
                            style: const TextStyle(color: Colors.white),
                          ),
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

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25.0,
                          vertical: 10.0,
                        ),
                        itemCount: _viewModel.groupedOrders.length,
                        itemBuilder: (context, index) {
                          String dateKey = _viewModel.groupedOrders.keys
                              .elementAt(index);
                          List<Map<String, dynamic>> orders =
                              _viewModel.groupedOrders[dateKey]!;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                ),
                                child: Text(
                                  dateKey,
                                  style: const TextStyle(
                                    color: Color(0xFFFDFDFD),
                                    fontSize: 17,
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
                              ),
                              ...orders
                                  .map((order) => _buildOrderCard(order))
                                  .toList(),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Container(
                height: 130,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Color(0xFF1C3628), Color(0x003E5A4A)],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final status = order['status'] ?? 'Menunggu Pembayaran';
    final progress = _viewModel.getProgress(status);
    final orderItems = order['order_items'] as List<dynamic>? ?? [];
    final productNames = _viewModel.extractProductNames(orderItems);
    final totalQty = _viewModel.calculateTotalQty(orderItems);
    final isFinished = status == 'Selesai';

    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFDFDFD),
        borderRadius: BorderRadius.circular(16.69),
        border: !isFinished
            ? Border.all(color: const Color(0xFFCA748D), width: 1)
            : null,
        boxShadow: !isFinished
            ? [
                const BoxShadow(
                  color: Color(0xFFCA748D),
                  blurRadius: 10,
                  offset: Offset(0, 0),
                  spreadRadius: 0,
                ),
              ]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order ID: ${order['id'].toString().substring(0, 8)}',
                style: const TextStyle(
                  color: Color(0xFF2D4839),
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                _viewModel.formatCurrency(order['total_price']),
                style: const TextStyle(
                  color: Color(0xFF2D4839),
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: 'Product: ',
                  style: TextStyle(
                    color: Color(0xFF51725F),
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: productNames,
                  style: const TextStyle(
                    color: Color(0xFF51725F),
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: 'Qty: ',
                  style: TextStyle(
                    color: Color(0xFF51725F),
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: '$totalQty',
                  style: const TextStyle(
                    color: Color(0xFF51725F),
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Stack(
            children: [
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: isFinished
                      ? const Color(0xFF848484)
                      : const Color(0xFFEED5DB),
                  borderRadius: BorderRadius.circular(7500.95),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: isFinished
                        ? const Color(0xFF333333)
                        : const Color(0xFFCA748D),
                    borderRadius: BorderRadius.circular(7500.95),
                  ),
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
                  color: isFinished
                      ? const Color(0xFF333333)
                      : const Color(0xFF2D4839),
                  fontSize: 10,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'On The Way',
                style: TextStyle(
                  color: isFinished
                      ? const Color(0xFF333333)
                      : const Color(0xFF2D4839),
                  fontSize: 10,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Delivered',
                style: TextStyle(
                  color: isFinished
                      ? const Color(0xFF333333)
                      : const Color(0xFF2D4839),
                  fontSize: 10,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: () {
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isFinished
                      ? const Color(0xFF333333)
                      : const Color(0xFFEED5DB),
                  border: isFinished
                      ? null
                      : Border.all(color: const Color(0xFFCA748D)),
                  borderRadius: BorderRadius.circular(55.60),
                ),
                child: Text(
                  isFinished ? 'Write a Review' : 'See Detail',
                  style: TextStyle(
                    color: isFinished
                        ? const Color(0xFFFBFBFB)
                        : const Color(0xFFCA748D),
                    fontSize: 10.59,
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
