import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../models/order_model.dart';
import '../../viewmodels/cust/detail_order_viewmodel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'write_review_view.dart';
import 'see_review_view.dart';

class DetailOrderView extends StatefulWidget {
  final String orderId;

  const DetailOrderView({super.key, required this.orderId});

  @override
  State<DetailOrderView> createState() => _DetailOrderViewState();
}

class _DetailOrderViewState extends State<DetailOrderView> {
  final DetailOrderViewModel _viewModel = DetailOrderViewModel();
  Timer? _timer;
  Duration _timeLeft = Duration.zero;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _viewModel.fetchOrder(widget.orderId);

      if (mounted && _viewModel.orderDetail != null) {
        final expiryTime = _viewModel.orderDetail!.vaExpiryTime;
        if (expiryTime != null) {
          _startTimer(expiryTime);
        }
      }
    });
  }

  void _startTimer(DateTime expiryTime) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      final now = DateTime.now();
      if (expiryTime.isAfter(now)) {
        setState(() {
          _timeLeft = expiryTime.difference(now);
        });
      } else {
        setState(() {
          _timeLeft = Duration.zero;
        });
        timer.cancel();
      }
    });

    final now = DateTime.now();
    if (expiryTime.isAfter(now)) {
      setState(() {
        _timeLeft = expiryTime.difference(now);
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatCurrency(double amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3D5A4A),
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: -30,
            height: 186,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFD699AB), Color(0xFFD699AB)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            const Text(
                              'Order Details',
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
                            Text(
                              widget.orderId.substring(0, 8).toUpperCase(),
                              style: TextStyle(
                                color: const Color(
                                  0xFFFDFDFD,
                                ).withValues(alpha: 0.7),
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 48),
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
                      if (_viewModel.errorMessage != null ||
                          _viewModel.orderDetail == null) {
                        return const Center(
                          child: Text(
                            "Gagal memuat detail pesanan",
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      final order = _viewModel.orderDetail!;
                      final paymentMethod = order.paymentMethod;
                      final status = order.status;

                      bool isPaid = [
                        'Diproses',
                        'Dikirim',
                        'Selesai',
                      ].contains(status);

                      return ListView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 10,
                        ),
                        physics: const BouncingScrollPhysics(),
                        children: [
                          _buildOrderSummary(),
                          const SizedBox(height: 20),
                          _buildPaymentInformation(
                            paymentMethod,
                            isPaid,
                            order,
                          ),
                          const SizedBox(height: 30),
                          _buildActionButtons(status, order.items),
                          const SizedBox(height: 40),
                        ],
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

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      decoration: BoxDecoration(
        color: const Color(0xFFFDFDFD),
        borderRadius: BorderRadius.circular(16.69),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(
              color: Color(0xFF2D4839),
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 15),
          _buildSummaryRow('Sub Total', _formatCurrency(_viewModel.subTotal)),
          const SizedBox(height: 6),
          _buildSummaryRow(
            'Shipping Cost',
            _formatCurrency(_viewModel.shippingCost),
          ),
          const SizedBox(height: 6),
          _buildSummaryRow('Discount', _formatCurrency(_viewModel.discount)),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Payment',
                style: TextStyle(
                  color: Color(0xFF426E55),
                  fontSize: 15,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                _formatCurrency(_viewModel.totalPayment),
                style: const TextStyle(
                  color: Color(0xFF426E55),
                  fontSize: 15,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF426E55),
            fontSize: 13,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF426E55),
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentInformation(
    String paymentMethod,
    bool isPaid,
    OrderDetailModel order,
  ) {
    bool isVA = paymentMethod.toLowerCase().contains('virtual account');
    String displayMethod = paymentMethod;

    if (isVA) {
      if (paymentMethod.toLowerCase() == 'virtual account bank' ||
          paymentMethod.toLowerCase() == 'virtual account') {
        displayMethod = "Virtual Account";
      } else {
        String bankName = paymentMethod
            .toLowerCase()
            .replaceAll('virtual account', '')
            .replaceAll('bank', '')
            .trim();
        displayMethod = "Bank ${bankName.toUpperCase()}";
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      decoration: BoxDecoration(
        color: const Color(0xFFFDFDFD),
        borderRadius: BorderRadius.circular(16.69),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Information',
            style: TextStyle(
              color: Color(0xFF2D4839),
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 20),

          if (isVA && !isPaid) ...[
            Center(
              child: Text(
                displayMethod,
                style: const TextStyle(
                  color: Color(0xFF2D4839),
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  order.vaNumber ?? 'N/A',
                  style: const TextStyle(
                    color: Color(0xFF2D4839),
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    if (order.vaNumber != null) {
                      Clipboard.setData(ClipboardData(text: order.vaNumber!));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Nomor VA disalin!'),
                          backgroundColor: Color(0xFF426E55),
                        ),
                      );
                    }
                  },
                  child: const Icon(
                    Icons.copy,
                    color: Color(0xFF2D4839),
                    size: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Payment code will expired in',
                  style: TextStyle(
                    color: Color(0xFF426E55),
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _viewModel.formattedRemainingTime,
                  style: const TextStyle(
                    color: Color(0xFFC23437),
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Payment Method',
                style: TextStyle(
                  color: Color(0xFF426E55),
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              _buildPill(displayMethod, false),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Payment Status',
                style: TextStyle(
                  color: Color(0xFF426E55),
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              _buildPill(isPaid ? 'Paid' : 'Unpaid', isPaid),
            ],
          ),

          if (paymentMethod == 'COD') ...[
            const SizedBox(height: 20),
            const Text(
              'Please prepare the exact payment amount and complete the payment once your order has been delivered.',
              style: TextStyle(
                color: Color(0xFF426E55),
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                height: 1.3,
              ),
            ),
          ] else if (paymentMethod == 'QRIS Statis' &&
              order.paymentProofUrl != null) ...[
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () async {
                  final Uri url = Uri.parse(order.paymentProofUrl!);
                  await launchUrl(url, mode: LaunchMode.inAppBrowserView);
                },
                child: _buildPill('See proof of payment', false),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPill(String text, bool isPaidStyle) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFEED5DB),
        borderRadius: BorderRadius.circular(62.50),
        border: Border.all(
          color: isPaidStyle
              ? const Color(0xFF426E55)
              : const Color(0xFFCA748D),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isPaidStyle
              ? const Color(0xFF426E55)
              : const Color(0xFFCA748D),
          fontSize: 11.39,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildActionButtons(String status, List<OrderItemModel> items) {
    if (status == 'Dibatalkan') {
      return const Center(
        child: Text(
          "Pesanan Dibatalkan",
          style: TextStyle(
            color: Color(0xFFF26F71),
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w800,
          ),
        ),
      );
    }

    if (status == 'Selesai') {
      return GestureDetector(
        onTap: () {
          if (_viewModel.isReviewed) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    SeeReviewView(orderId: widget.orderId, orderItems: items),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    WriteReviewView(orderId: widget.orderId, orderItems: items),
              ),
            ).then((_) {
              _viewModel.fetchOrder(widget.orderId);
            });
          }
        },
        child: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFD699AB), Color(0xFFCA748D)],
            ),
            borderRadius: BorderRadius.circular(87.79),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            _viewModel.isReviewed ? 'See Review' : 'Write Review',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () async => await _viewModel.cancelOrder(),
          child: Container(
            width: 140,
            height: 35,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF26F71), Color(0xFFC23437)],
              ),
              borderRadius: BorderRadius.circular(87.79),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const Text(
              'Cancel Order',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: status == 'Dikirim'
              ? () async => await _viewModel.receiveOrder()
              : null,
          child: Container(
            width: 140,
            height: 35,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: status == 'Dikirim'
                    ? [const Color(0xFFD699AB), const Color(0xFFCA748D)]
                    : [Colors.grey, Colors.grey.shade600],
              ),
              borderRadius: BorderRadius.circular(87.79),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const Text(
              'Order Received',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
