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

  @override
  void initState() {
    super.initState();
    _viewModel = HistoryViewModel(service: HistoryService());

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
                        padding: const EdgeInsets.only(bottom: 20),
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
                              ...orders.map((order) => _buildOrderCard(order)),
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

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
      child: Column(
        children: [
          Container(
            width: 340,
            height: 165,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    width: 340,
                    height: 165,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFFDFDFD),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.69),
                      ),
                    ),
                  ),
                ),
                
                Positioned(
                  left: 14,
                  top: 135,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailOrderView(orderId: order.id),
                        ),
                      ).then((_) {
                        _viewModel.fetchHistory();
                      });
                    },
                    child: Container(
                      width: 98,
                      height: 20,
                      decoration: ShapeDecoration(
                        color: isFinished
                            ? const Color(0xFF333333)
                            : const Color(0xFFEED5DB),
                        shape: RoundedRectangleBorder(
                          side: isFinished
                              ? BorderSide.none
                              : BorderSide(
                                  width: 1,
                                  color: const Color(0xFFCA748D),
                                ),
                          borderRadius: BorderRadius.circular(55.60),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          isFinished ? 'Write a Review' : 'See Detail',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isFinished
                                ? const Color(0xFFFBFBFB)
                                : const Color(0xFFCA748D),
                            fontSize: 10.59,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            height: 1.10,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                
                Positioned(
                  left: 18,
                  top: 102,
                  child: Container(
                    width: 308,
                    height: 6,
                    decoration: ShapeDecoration(
                      color: const Color(0xFF848484),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7500.95),
                      ),
                    ),
                  ),
                ),
                
                Positioned(
                  left: 18,
                  top: 102,
                  child: Container(
                    width: 308,
                    height: 6,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFCA748D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7500.95),
                      ),
                    ),
                  ),
                ),
                
                Positioned(
                  left: 18,
                  top: 111,
                  child: Text(
                    'Preparing',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: const Color(0xFF2D4839),
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      height: 1.10,
                    ),
                  ),
                ),
                
                Positioned(
                  left: 135,
                  top: 111,
                  child: Text(
                    'On The Way',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: const Color(0xFF2D4839),
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      height: 1.10,
                    ),
                  ),
                ),
                
                Positioned(
                  left: 267,
                  top: 111,
                  child: Text(
                    'Delivered',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: const Color(0xFF2D4839),
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      height: 1.10,
                    ),
                  ),
                ),
                
                Positioned(
                  left: 14,
                  top: 13,
                  child: Text(
                    'Order #${order.id.substring(0, 8)}',
                    style: TextStyle(
                      color: const Color(0xFF2D4839),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      height: 1.10,
                    ),
                  ),
                ),
                
                Positioned(
                  left: 253,
                  top: 13,
                  child: Text(
                    priceFormatted,
                    style: TextStyle(
                      color: const Color(0xFF2D4839),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      height: 1.10,
                    ),
                  ),
                ),
                
                Positioned(
                  left: 14,
                  top: 34,
                  child: SizedBox(
                    width: 222,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Product: ',
                            style: TextStyle(
                              color: const Color(0xFF51725F),
                              fontSize: 13,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              height: 1.10,
                            ),
                          ),
                          TextSpan(
                            text: order.productNames,
                            style: TextStyle(
                              color: const Color(0xFF51725F),
                              fontSize: 13,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              height: 1.10,
                            ),
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                
                Positioned(
                  left: 14,
                  top: 67,
                  child: SizedBox(
                    width: 222,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Qty:',
                            style: TextStyle(
                              color: const Color(0xFF51725F),
                              fontSize: 13,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              height: 1.10,
                            ),
                          ),
                          TextSpan(
                            text: ' ${order.totalQuantity}',
                            style: TextStyle(
                              color: const Color(0xFF51725F),
                              fontSize: 13,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              height: 1.10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
