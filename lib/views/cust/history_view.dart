import 'package:flutter/material.dart';
import '/models/order_detail_model.dart';
import '/viewmodels/cust/history_viewmodel.dart';

class HistoryView extends StatefulWidget {
  final String userId;

  const HistoryView({super.key, required this.userId});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  final HistoryViewModel _viewModel = HistoryViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.fetchHistory(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3D5A4A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
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
        centerTitle: true,
      ),
      body: AnimatedBuilder(
        animation: _viewModel,
        builder: (context, child) {
          if (_viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFD699AB)),
            );
          }

          if (_viewModel.errorMessage != null) {
            return Center(
              child: Text(
                _viewModel.errorMessage!,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                ),
              ),
            );
          }

          if (_viewModel.orders.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada riwayat pesanan.',
                style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            itemCount: _viewModel.orders.length,
            itemBuilder: (context, index) {
              final order = _viewModel.orders[index];
              final dateString = _viewModel.getFormattedDate(order.createdAt);

              bool showDateHeader = true;
              if (index > 0) {
                final prevOrder = _viewModel.orders[index - 1];
                if (_viewModel.getFormattedDate(prevOrder.createdAt) ==
                    dateString) {
                  showDateHeader = false;
                }
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showDateHeader)
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 15),
                      child: Text(
                        dateString,
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
                  _buildOrderCard(order),
                  const SizedBox(height: 20),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(OrderDetailModel order) {
    bool isDelivered = order.status.toLowerCase() == 'delivered';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFDFDFD),
        borderRadius: BorderRadius.circular(16.69),
        border: Border.all(color: const Color(0xFFCA748D), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFCA748D),
            blurRadius: 10,
            offset: Offset(0, 0),
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
                'Order ID #${order.id.substring(0, 5)}',
                style: const TextStyle(
                  color: Color(0xFF2D4839),
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Rp. ${order.totalPrice.toInt()}',
                style: const TextStyle(
                  color: Color(0xFF2D4839),
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          ...order.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: Color(0xFF51725F),
                    fontSize: 13,
                    fontFamily: 'Poppins',
                  ),
                  children: [
                    const TextSpan(
                      text: 'Product: ',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextSpan(
                      text: item.menuName,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                color: Color(0xFF51725F),
                fontSize: 13,
                fontFamily: 'Poppins',
              ),
              children: [
                const TextSpan(
                  text: 'Qty: ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      '${order.items.fold(0, (sum, item) => sum + item.quantity)} items',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          _buildTrackingBar(order.status),
          const SizedBox(height: 20),

          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {
              },
              child: Container(
                width: 98,
                height: 25,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isDelivered
                      ? const Color(0xFF333333)
                      : const Color(0xFFEED5DB),
                  borderRadius: BorderRadius.circular(55),
                  border: isDelivered
                      ? null
                      : Border.all(color: const Color(0xFFCA748D)),
                ),
                child: Text(
                  isDelivered ? 'Write a Review' : 'See Detail',
                  style: TextStyle(
                    color: isDelivered
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

  Widget _buildTrackingBar(String status) {
    double progress = 0.15;
    if (status.toLowerCase() == 'on the way') progress = 0.50;
    if (status.toLowerCase() == 'delivered') progress = 1.0;

    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 6,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF848484).withOpacity(0.5),
                borderRadius: BorderRadius.circular(7500),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  height: 6,
                  width: constraints.maxWidth * progress,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCA748D),
                    borderRadius: BorderRadius.circular(7500),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Preparing',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF2D4839),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'On The Way',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF2D4839),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Delivered',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF2D4839),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
