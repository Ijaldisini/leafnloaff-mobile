import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../models/order_model.dart';
import '../../viewmodels/cust/detail_order_viewmodel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  bool _isInitialLoad = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _viewModel.fetchOrder(widget.orderId, onError: _showErrorDialog);
      if (mounted) setState(() => _isInitialLoad = false);

      if (mounted && _viewModel.orderDetail != null) {
        final expiryTime = _viewModel.orderDetail!.vaExpiryTime;
        if (expiryTime != null) _startTimer(expiryTime);
      }
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

  Future<void> _refreshOrder() async {
    await _viewModel.fetchOrder(widget.orderId, onError: _showErrorDialog);
    await Future.delayed(const Duration(milliseconds: 300));
  }

  void _startTimer(DateTime expiryTime) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      final now = DateTime.now();
      if (expiryTime.isAfter(now)) {
        setState(() => _timeLeft = expiryTime.difference(now));
      } else {
        setState(() => _timeLeft = Duration.zero);
        timer.cancel();
      }
    });
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
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: IconButton(
                          icon: SvgPicture.asset(
                            'assets/images/back.svg',
                            width: 24,
                            height: 24,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
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
                                fontWeight: FontWeight.w900,
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
                      if (_viewModel.isLoading && _isInitialLoad) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      }
                      if (_viewModel.orderDetail == null) {
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

                      return RefreshIndicator(
                        color: const Color(0xFFCA748D),
                        backgroundColor: Colors.white,
                        onRefresh: _refreshOrder,
                        child: ListView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 10,
                          ),
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          children: [
                            _buildOrderStatus(status),
                            const SizedBox(height: 16),
                            _buildCustomerInformation(order),
                            const SizedBox(height: 16),
                            _buildCustomerNotes(order),
                            const SizedBox(height: 16),
                            _buildOrderDetail(order.items),
                            const SizedBox(height: 20),
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

  Widget _buildOrderStatus(String status) {
    int currentStep = 0;
    final s = status.toLowerCase();
    if (s.contains('tunggu') || s.contains('bayar') || s.contains('masuk'))
      currentStep = 0;
    else if (s.contains('proses') || s.contains('siap'))
      currentStep = 1;
    else if (s.contains('kirim') || s.contains('jalan') || s.contains('otw'))
      currentStep = 2;
    else if (s.contains('selesai') || s.contains('delivered'))
      currentStep = 3;

    Widget buildIcon(String iconName, bool isActive) {
      return Center(
        child: SvgPicture.asset(
          'assets/images/$iconName',
          width: 32,
          height: 32,
          colorFilter: ColorFilter.mode(
            isActive ? const Color(0xFF2D4839) : Colors.grey,
            BlendMode.srcIn,
          ),
        ),
      );
    }

    Widget buildText(String label, bool isActive) {
      return Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: isActive ? const Color(0xFF2D4839) : Colors.grey,
          fontSize: 11,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700,
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFDFDFD),
        borderRadius: BorderRadius.circular(16.69),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Order Status',
            style: TextStyle(
              color: Color(0xFF2D4839),
              fontSize: 18,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = constraints.maxWidth;
              double progressWidth = 0;

              if (currentStep == 0) progressWidth = maxWidth * (1 / 8);
              if (currentStep == 1) progressWidth = maxWidth * (3 / 8);
              if (currentStep == 2) progressWidth = maxWidth * (5 / 8);
              if (currentStep >= 3) progressWidth = maxWidth;

              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: buildIcon('Waiting.svg', currentStep >= 0),
                      ),
                      Expanded(child: buildIcon('bell.svg', currentStep >= 1)),
                      Expanded(
                        child: buildIcon('pickup.svg', currentStep >= 2),
                      ),
                      Expanded(
                        child: buildIcon('deliverid.svg', currentStep >= 3),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Stack(
                    children: [
                      Container(
                        height: 6,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEED5DB),
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
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: buildText('Waiting', currentStep >= 0)),
                      Expanded(child: buildText('Preparing', currentStep >= 1)),
                      Expanded(
                        child: buildText('On The Way', currentStep >= 2),
                      ),
                      Expanded(child: buildText('Delivered', currentStep >= 3)),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOrderDetail(List<OrderItemModel> items) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFDFDFD),
        borderRadius: BorderRadius.circular(16.69),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Detail',
              style: TextStyle(
                color: Color(0xFF2D4839),
                fontSize: 20,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _buildOrderItem(item),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(OrderItemModel item) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFDFDFD),
        border: Border.all(color: const Color(0xFFCA748D)),
        borderRadius: BorderRadius.circular(11.68),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(11.68),
              bottomLeft: Radius.circular(11.68),
            ),
            child: Image.network(
              item.menuImageUrl ?? 'https://placehold.co/92x81',
              width: 90,
              height: 85,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.menuName,
                    style: const TextStyle(
                      color: Color(0xFF2D4839),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w800,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Notes: ',
                          style: TextStyle(
                            color: Color(0xFF426E55),
                            fontSize: 10,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: item.notes ?? '-',
                          style: const TextStyle(
                            color: Color(0xFF426E55),
                            fontSize: 10,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Qty: ${item.quantity}',
                    style: const TextStyle(
                      color: Color(0xFF426E55),
                      fontSize: 10,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Rp. ${item.priceAtTime}',
                    style: const TextStyle(
                      color: Color(0xFF2D4839),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerInformation(OrderDetailModel order) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFDFDFD),
        borderRadius: BorderRadius.circular(16.69),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Customer Information',
            style: TextStyle(
              color: Color(0xFF2D4839),
              fontSize: 20,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              SvgPicture.asset(
                'assets/images/person.svg',
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF426E55),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  order.profile.fullName,
                  style: const TextStyle(
                    color: Color(0xFF426E55),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              SvgPicture.asset(
                'assets/images/telepon.svg',
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF426E55),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  order.profile.phoneNumber,
                  style: const TextStyle(
                    color: Color(0xFF426E55),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                'assets/images/locations.svg',
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF426E55),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  order.addressDetail,
                  style: const TextStyle(
                    color: Color(0xFF426E55),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () async {
              if (order.latitude != null && order.longitude != null) {
                final Uri url = Uri.parse(
                  'https://www.google.com/maps/search/?api=1&query=${order.latitude},${order.longitude}',
                );
                if (await canLaunchUrl(url))
                  await launchUrl(url, mode: LaunchMode.externalApplication);
              }
            },
            child: Container(
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: ShapeDecoration(
                color: const Color(0xFFEED5DB),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Color(0xFFCA748D)),
                  borderRadius: BorderRadius.circular(62.50),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.map, size: 16, color: Color(0xFFCA748D)),
                  SizedBox(width: 6),
                  Text(
                    'View Maps',
                    style: TextStyle(
                      color: Color(0xFFCA748D),
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerNotes(OrderDetailModel order) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFDFDFD),
        borderRadius: BorderRadius.circular(16.69),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Catatan Pesanan',
              style: TextStyle(
                color: Color(0xFF2D4839),
                fontSize: 20,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.sticky_note_2_outlined,
                  color: Color(0xFF426E55),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    order.notes.isNotEmpty &&
                            order.notes.toLowerCase() != 'null'
                        ? order.notes
                        : 'Tidak ada catatan.',
                    style: const TextStyle(
                      color: Color(0xFF426E55),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
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
              fontSize: 20,
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
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                _formatCurrency(_viewModel.totalPayment),
                style: const TextStyle(
                  color: Color(0xFF426E55),
                  fontSize: 18,
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
            fontSize: 15,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF426E55),
            fontSize: 16,
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
          paymentMethod.toLowerCase() == 'virtual account')
        displayMethod = "Virtual Account";
      else {
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
              fontSize: 20,
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
                  fontSize: 16,
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
                  order.vaNumber ?? '8808123456789012',
                  style: const TextStyle(
                    color: Color(0xFF2D4839),
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w900,
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
                  fontSize: 16,
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
                  fontSize: 16,
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
    final s = status.toLowerCase();
    if (s == 'dibatalkan' || s == 'cancelled') {
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
    if (s == 'selesai' || s == 'delivered') {
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
            ).then(
              (_) => _viewModel.fetchOrder(
                widget.orderId,
                onError: _showErrorDialog,
              ),
            );
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

    bool isBeforeDikirim =
        s.contains('tunggu') ||
        s.contains('bayar') ||
        s.contains('proses') ||
        s.contains('siap') ||
        s.contains('masuk');
    bool isDikirim =
        s.contains('kirim') || s.contains('jalan') || s.contains('otw');

    if (isBeforeDikirim) {
      return Center(
        child: GestureDetector(
          onTap: () async =>
              await _viewModel.cancelOrder(onError: _showErrorDialog),
          child: Container(
            width: double.infinity,
            height: 40,
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
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      );
    } else if (isDikirim) {
      return Center(
        child: GestureDetector(
          onTap: () async =>
              await _viewModel.receiveOrder(onError: _showErrorDialog),
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
            child: const Text(
              'Order Received',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
