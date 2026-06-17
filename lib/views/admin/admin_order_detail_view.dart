import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:leafnloaff/viewmodels/admin/admin_order_detail_viewmodel.dart';
import 'package:leafnloaff/models/order_model.dart';
import 'package:leafnloaff/views/admin/admin_order_review_view.dart';

class AdminOrderDetailView extends StatefulWidget {
  final String orderId;

  const AdminOrderDetailView({super.key, required this.orderId});

  @override
  State<AdminOrderDetailView> createState() => _AdminOrderDetailViewState();
}

class _AdminOrderDetailViewState extends State<AdminOrderDetailView> {
  final AdminOrderDetailViewModel _viewModel = AdminOrderDetailViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.fetchOrderDetail(widget.orderId);
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
            child: ListenableBuilder(
              listenable: _viewModel,
              builder: (context, child) {
                if (_viewModel.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFFFDFDFD)),
                  );
                }

                if (_viewModel.orderDetail == null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Data pesanan tidak ditemukan",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Kembali'),
                        ),
                      ],
                    ),
                  );
                }

                final order = _viewModel.orderDetail!;

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: SvgPicture.asset(
                                'assets/images/back.svg',
                                width: 24,
                                height: 24,
                                colorFilter: const ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
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
                                  order.id.substring(0, 8).toUpperCase(),
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
                      child: ListView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 10,
                        ),
                        physics: const BouncingScrollPhysics(),
                        children: [
                          _buildOrderStatus(order.status),
                          const SizedBox(height: 16),
                          _buildCustomerInformation(order),
                          const SizedBox(height: 16),
                          _buildOrderDetail(order.items),
                          const SizedBox(height: 20),
                          _buildOrderSummary(order),
                          const SizedBox(height: 20),
                          _buildPaymentCard(order),
                          const SizedBox(height: 30),
                          _buildActionButtons(order),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderStatus(String status) {
    int getCurrentStep() {
      final statusStr = status.toLowerCase();
      if (statusStr.contains('tunggu') || statusStr.contains('waiting')) {
        return 0;
      } else if (statusStr.contains('proses') ||
          statusStr.contains('preparing')) {
        return 1;
      } else if (statusStr.contains('kirim') ||
          statusStr.contains('on the way')) {
        return 2;
      } else if (statusStr.contains('selesai') ||
          statusStr.contains('delivered')) {
        return 3;
      }
      return 0;
    }

    final currentStep = getCurrentStep();

    return Container(
      width: 338,
      height: 123,
      decoration: BoxDecoration(
        color: const Color(0xFFFDFDFD),
        borderRadius: BorderRadius.circular(16.69),
        boxShadow: [
          BoxShadow(
            color: const Color(0x3F000000),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          const Positioned(
            left: 110,
            top: 11,
            child: SizedBox(
              width: 134,
              height: 23.76,
              child: Text(
                'Order Status',
                style: TextStyle(
                  color: Color(0xFF2D4839),
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w800,
                  height: 1.10,
                ),
              ),
            ),
          ),
          Positioned(
            left: 25,
            top: 50,
            child: SvgPicture.asset(
              'assets/images/Waiting.svg',
              width: 32,
              height: 32,
              colorFilter: ColorFilter.mode(
                currentStep >= 0 ? const Color(0xFF2D4839) : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
          ),
          Positioned(
            left: 105,
            top: 50,
            child: SvgPicture.asset(
              'assets/images/bell.svg',
              width: 32,
              height: 32,
              colorFilter: ColorFilter.mode(
                currentStep >= 1 ? const Color(0xFF2D4839) : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
          ),
          Positioned(
            left: 195,
            top: 50,
            child: SvgPicture.asset(
              'assets/images/pickup.svg',
              width: 32,
              height: 32,
              colorFilter: ColorFilter.mode(
                currentStep >= 2 ? const Color(0xFF2D4839) : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
          ),
          Positioned(
            left: 280,
            top: 50,
            child: SvgPicture.asset(
              'assets/images/deliverid.svg',
              width: 32,
              height: 32,
              colorFilter: ColorFilter.mode(
                currentStep >= 3 ? const Color(0xFF2D4839) : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
          ),
          const Positioned(
            left: 16,
            top: 88.50,
            child: SizedBox(
              width: 310,
              height: 6,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Color(0xFFEED5DB),
                  borderRadius: BorderRadius.all(Radius.circular(7500.95)),
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            top: 88.50,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: currentStep >= 0 ? 62 : 0,
              height: 6,
              decoration: const BoxDecoration(
                color: Color(0xFFCA748D),
                borderRadius: BorderRadius.all(Radius.circular(7500.95)),
              ),
            ),
          ),
          const Positioned(
            left: 16,
            top: 97.50,
            child: Text(
              'Waiting',
              style: TextStyle(
                color: Color(0xFF2D4839),
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                height: 1.10,
              ),
            ),
          ),
          const Positioned(
            left: 87,
            top: 97.50,
            child: Text(
              'Preparing',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Color(0xFF2D4839),
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                height: 1.10,
              ),
            ),
          ),
          const Positioned(
            left: 171,
            top: 97.50,
            child: Text(
              'On The Way',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Color(0xFF2D4839),
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                height: 1.10,
              ),
            ),
          ),
          const Positioned(
            left: 267,
            top: 97.50,
            child: Text(
              'Delivered',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Color(0xFF2D4839),
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                height: 1.10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerInformation(OrderDetailModel order) {
    return Container(
      width: 338,
      decoration: BoxDecoration(
        color: const Color(0xFFFDFDFD),
        borderRadius: BorderRadius.circular(16.69),
        boxShadow: [
          BoxShadow(
            color: const Color(0x3F000000),
            blurRadius: 4,
            offset: const Offset(0, 4),
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
              crossAxisAlignment: CrossAxisAlignment.center,
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
              crossAxisAlignment: CrossAxisAlignment.center,
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
            if (order.latitude != null && order.longitude != null)
              GestureDetector(
                onTap: () =>
                    _viewModel.openMap(order.latitude!, order.longitude!),
                child: Container(
                  height: 32,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFEED5DB),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        color: const Color(0xFFCA748D),
                      ),
                      borderRadius: BorderRadius.circular(62.50),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
      ),
    );
  }

  Widget _buildOrderDetail(List<OrderItemModel> items) {
    return Container(
      width: 338,
      decoration: BoxDecoration(
        color: const Color(0xFFFDFDFD),
        borderRadius: BorderRadius.circular(16.69),
        boxShadow: [
          BoxShadow(
            color: const Color(0x3F000000),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 188,
              height: 24,
              child: Text(
                'Order Detail',
                style: TextStyle(
                  color: Color(0xFF2D4839),
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w800,
                  height: 1.10,
                ),
              ),
            ),
            const SizedBox(height: 12),
            ...items
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _buildOrderItem(item),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(OrderItemModel item) {
    return Container(
      width: 314,
      height: 81,
      decoration: ShapeDecoration(
        color: const Color(0xFFFDFDFD),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: const Color(0xFFCA748D)),
          borderRadius: BorderRadius.circular(11.68),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 91.53,
              height: 81,
              decoration: ShapeDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    item.menuImageUrl ?? 'https://placehold.co/92x81',
                  ),
                  fit: BoxFit.cover,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(11.68),
                    bottomLeft: Radius.circular(11.68),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 95,
            top: 5,
            child: Text(
              item.menuName,
              style: const TextStyle(
                color: Color(0xFF2D4839),
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w800,
                height: 1.10,
              ),
            ),
          ),
          Positioned(
            left: 95,
            top: 21,
            child: SizedBox(
              width: 213,
              child: Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Notes: ',
                      style: TextStyle(
                        color: Color(0xFF426E55),
                        fontSize: 8,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        height: 1.10,
                      ),
                    ),
                    TextSpan(
                      text: item.notes ?? '-',
                      style: const TextStyle(
                        color: Color(0xFF426E55),
                        fontSize: 8,
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
            left: 95,
            top: 42,
            child: SizedBox(
              width: 120.40,
              child: Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Qty:',
                      style: TextStyle(
                        color: Color(0xFF426E55),
                        fontSize: 8,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        height: 1.10,
                      ),
                    ),
                    TextSpan(
                      text: ' ${item.quantity}',
                      style: const TextStyle(
                        color: Color(0xFF426E55),
                        fontSize: 8,
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
          Positioned(
            left: 95,
            top: 59,
            child: Text(
              'Rp. ${item.priceAtTime.toInt()}',
              style: const TextStyle(
                color: Color(0xFF2D4839),
                fontSize: 13,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w800,
                height: 1.10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(OrderDetailModel order) {
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
          _buildSummaryRow(
            'Sub Total',
            _viewModel.formatCurrency(order.totalPrice),
          ),
          const SizedBox(height: 6),
          _buildSummaryRow('Shipping Cost', 'Rp. 0'),
          const SizedBox(height: 6),
          _buildSummaryRow('Discount', 'Rp. 0'),
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
                _viewModel.formatCurrency(order.totalPrice),
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

  Widget _buildPaymentCard(OrderDetailModel order) {
    final methodStr = order.paymentMethod;
    final isCOD = methodStr.toUpperCase() == 'COD';
    final isQris = methodStr.toLowerCase().contains('qris');
    final isVA = methodStr.toLowerCase().contains('virtual account');

    bool isPaid = true;
    if (isCOD) {
      isPaid =
          order.status.toLowerCase().contains('selesai') ||
          order.status.toLowerCase().contains('delivered');
    } else if (isVA) {
      isPaid =
          order.status.toLowerCase().contains('diproses') ||
          order.status.toLowerCase().contains('dikirim') ||
          order.status.toLowerCase().contains('selesai');
    }

    String displayMethod = methodStr;
    if (isVA) {
      if (methodStr.toLowerCase() == 'virtual account bank' ||
          methodStr.toLowerCase() == 'virtual account') {
        displayMethod = "Virtual Account";
      } else {
        String bankName = methodStr
            .toLowerCase()
            .replaceAll('virtual account', '')
            .replaceAll('bank', '')
            .trim();
        displayMethod = "Bank ${bankName.toUpperCase()}";
      }
    }
    
    Widget _buildPill(String text, bool isHighlight) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: ShapeDecoration(
          color: isHighlight
              ? const Color(0xFF73986F)
              : const Color(0xFFEED5DB),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isHighlight ? Colors.white : const Color(0xFF426E55),
            fontSize: 12,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
      );
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
          if (isQris && order.paymentProofUrl != null) ...[
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FullScreenImagePage(imageUrl: order.paymentProofUrl!),
                    ),
                  );
                },
                child: _buildPill('See proof of payment', false),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons(OrderDetailModel order) {
    final statusStr = order.status.toLowerCase();
    final isDelivered =
        statusStr.contains('selesai') || statusStr.contains('delivered');
    final isCanceled =
        statusStr.contains('batal') || statusStr.contains('cancel');

    if (isCanceled) {
      return const SizedBox();
    }

    if (isDelivered) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdminOrderReviewView(orderId: order.id),
            ),
          );
        },
        child: Container(
          width: double.infinity,
          height: 45,
          decoration: ShapeDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFD699AB), Color(0xFFCA748D)],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(87.79),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 3.51,
                offset: Offset(0, 3.51),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: const Text(
            'View Review',
            style: TextStyle(
              color: Color(0xFFFBFBFB),
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          flex: 4,
          child: GestureDetector(
            onTap: () async {
              final success = await _viewModel.changeOrderStatus(
                order.id,
                'Dibatalkan',
              );
              if (context.mounted) {
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Order dibatalkan!'),
                      backgroundColor: Color(0xFF73986F),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Gagal cancel! Cek RLS Supabase.'),
                      backgroundColor: Color(0xFFC23437),
                    ),
                  );
                }
              }
            },
            child: Container(
              height: 45,
              decoration: ShapeDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFF26F71), Color(0xFFC23437)],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(87.79),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 3.51,
                    offset: Offset(0, 3.51),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const Text(
                'Cancel Order',
                style: TextStyle(
                  color: Color(0xFFFBFBFB),
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),

        Expanded(
          flex: 6,
          child: GestureDetector(
            onTap: () async {
              String nextStatus =
                  _viewModel.getNextStatusValue(order.status) ?? 'Diproses';
              final success = await _viewModel.changeOrderStatus(
                order.id,
                nextStatus,
              );
              if (context.mounted) {
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Status berhasil diupdate!'),
                      backgroundColor: Color(0xFF73986F),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Gagal update! Cek RLS Supabase.'),
                      backgroundColor: Color(0xFFC23437),
                    ),
                  );
                }
              }
            },
            child: Container(
              height: 45,
              decoration: ShapeDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFD699AB), Color(0xFFCA748D)],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(87.79),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 3.51,
                    offset: Offset(0, 3.51),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                _viewModel.getNextStatusText(order.status) ?? 'Update Status',
                style: const TextStyle(
                  color: Color(0xFFFBFBFB),
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class FullScreenImagePage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImagePage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 0.5,
          maxScale: 4.0,
          child: Image.network(
            imageUrl,
            errorBuilder: (context, error, stackTrace) {
              return const Text(
                "Gagal memuat gambar bukti pembayaran",
                style: TextStyle(color: Colors.white),
              );
            },
          ),
        ),
      ),
    );
  }
}
