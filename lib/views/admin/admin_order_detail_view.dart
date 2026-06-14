import 'package:flutter/material.dart';
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 20,
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Order Details',
                                style: TextStyle(
                                  color: Color(0xFFFDFDFD),
                                  fontSize: 25,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w800,
                                  height: 1.10,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(2, 2),
                                      blurRadius: 4,
                                      color: Color(0x3F000000),
                                    ),
                                  ],
                                ),
                              ),
                              Opacity(
                                opacity: 0.70,
                                child: Text(
                                  'Order ID: ${order.id.length >= 8 ? order.id.substring(0, 8).toUpperCase() : order.id.toUpperCase()}',
                                  style: const TextStyle(
                                    color: Color(0xFFFDFDFD),
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(25, 10, 25, 40),
                        physics: const BouncingScrollPhysics(),
                        children: [
                          _buildStatusCard(order.status),
                          const SizedBox(height: 20),
                          _buildCustomerInfoCard(order),
                          const SizedBox(height: 20),
                          _buildOrderItemsList(order.items),
                          const SizedBox(height: 20),
                          _buildSummaryCard(order),
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
          child: Text(
            'View Review',
            style: TextStyle(
              color: const Color(0xFFFBFBFB),
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w800,
              shadows: [
                Shadow(
                  offset: const Offset(2, 2),
                  blurRadius: 2,
                  color: Colors.black.withValues(alpha: 0.25),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final nextStatusText = _viewModel.getNextStatusText(order.status);
    final nextStatusValue = _viewModel.getNextStatusValue(order.status);

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
              child: Text(
                'Cancel Order',
                style: TextStyle(
                  color: const Color(0xFFFBFBFB),
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w800,
                  shadows: [
                    Shadow(
                      offset: const Offset(2, 2),
                      blurRadius: 2,
                      color: Colors.black.withValues(alpha: 0.25),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          flex: 6,
          child: nextStatusValue != null
              ? GestureDetector(
                  onTap: () async {
                    final success = await _viewModel.changeOrderStatus(
                      order.id,
                      nextStatusValue,
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
                      nextStatusText ?? '',
                      style: TextStyle(
                        color: const Color(0xFFFBFBFB),
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w800,
                        shadows: [
                          Shadow(
                            offset: const Offset(2, 2),
                            blurRadius: 2,
                            color: Colors.black.withValues(alpha: 0.25),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Container(
                  height: 45,
                  decoration: ShapeDecoration(
                    color: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(87.79),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Waiting for Customer',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildStatusCard(String status) {
    String statusStr = status.toLowerCase();
    double progress = 0.0;

    if (statusStr.contains('tunggu') || statusStr.contains('bayar')) {
      progress = 0.25;
    } else if (statusStr.contains('proses') || statusStr.contains('siap')) {
      progress = 0.50;
    } else if (statusStr.contains('kirim') || statusStr.contains('jalan')) {
      progress = 0.75;
    } else if (statusStr.contains('selesai')) {
      progress = 1.0;
    }

    return _buildWhiteContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Status',
            style: TextStyle(
              color: Color(0xFF2D4839),
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 15),
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 6,
                decoration: ShapeDecoration(
                  color: const Color(0xFFEED5DB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7500.95),
                  ),
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    width: constraints.maxWidth * progress,
                    height: 6,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFCA748D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7500.95),
                      ),
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
              Text('Waiting', style: _statusLabelStyle),
              Text('Preparing', style: _statusLabelStyle),
              Text('On The Way', style: _statusLabelStyle),
              Text('Delivered', style: _statusLabelStyle),
            ],
          ),
        ],
      ),
    );
  }

  static const TextStyle _statusLabelStyle = TextStyle(
    color: Color(0xFF2D4839),
    fontSize: 10,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w700,
  );

  Widget _buildCustomerInfoCard(OrderDetailModel order) {
    bool hasLocation = order.latitude != null && order.longitude != null;

    return _buildWhiteContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Customer Information',
            style: TextStyle(
              color: Color(0xFF2D4839),
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          _buildInfoRow('Customer’s Name', order.profile.fullName),
          const SizedBox(height: 5),
          _buildInfoRow('Phone Number', order.profile.phoneNumber),
          const SizedBox(height: 5),
          _buildInfoRow('Address', order.addressDetail),
          if (hasLocation) ...[
            const SizedBox(height: 15),
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () =>
                    _viewModel.openMap(order.latitude!, order.longitude!),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 5,
                  ),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFEED5DB),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        width: 1,
                        color: Color(0xFFCA748D),
                      ),
                      borderRadius: BorderRadius.circular(62.50),
                    ),
                  ),
                  child: const Text(
                    'View Maps',
                    style: TextStyle(
                      color: Color(0xFFCA748D),
                      fontSize: 11.39,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOrderItemsList(List<OrderItemModel> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Order Detail',
          style: TextStyle(
            color: Color(0xFF2D4839),
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        ...items.map((item) {
          final priceFormatted = _viewModel.formatCurrency(item.menuPrice);

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            height: 85,
            decoration: ShapeDecoration(
              color: const Color(0xFFFDFDFD),
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: Color(0xFFCA748D)),
                borderRadius: BorderRadius.circular(11.68),
              ),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(11),
                    bottomLeft: Radius.circular(11),
                  ),
                  child: SizedBox(
                    width: 90,
                    height: double.infinity,
                    child:
                        item.menuImageUrl != null &&
                            item.menuImageUrl!.isNotEmpty
                        ? Image.network(
                            item.menuImageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.network(
                                "https://placehold.co/92x81/png?text=No+Image",
                                fit: BoxFit.cover,
                              );
                            },
                          )
                        : Image.network(
                            "https://placehold.co/92x81/png?text=No+Image",
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item.menuName,
                          style: const TextStyle(
                            color: Color(0xFF2D4839),
                            fontSize: 12,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w800,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Qty: ${item.quantity}',
                              style: const TextStyle(
                                color: Color(0xFF426E55),
                                fontSize: 9,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              priceFormatted,
                              style: const TextStyle(
                                color: Color(0xFF2D4839),
                                fontSize: 13,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSummaryCard(OrderDetailModel order) {
    final total = _viewModel.formatCurrency(order.totalPrice);

    return _buildWhiteContainer(
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
          const SizedBox(height: 10),
          _buildSummaryRow('Sub Total', total),
          const SizedBox(height: 5),
          _buildSummaryRow('Shipping Cost', 'Rp. 0'),
          const SizedBox(height: 5),
          _buildSummaryRow('Discount', 'Rp. 0'),
          const SizedBox(height: 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Notes',
                style: TextStyle(
                  color: Color(0xFF426E55),
                  fontSize: 13,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              Expanded(
                child: Text(
                  order.notes,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Color(0xFF426E55),
                    fontSize: 13,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          const Divider(color: Color(0xFFEED5DB), thickness: 1, height: 20),
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
                total,
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

    return _buildWhiteContainer(
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
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Payment Method',
                style: TextStyle(
                  color: Color(0xFF426E55),
                  fontSize: 13,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: _buildPill(displayMethod, isPaidStyle: false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Payment Status',
                style: TextStyle(
                  color: Color(0xFF426E55),
                  fontSize: 13,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              _buildPill(isPaid ? 'Paid' : 'Unpaid', isPaidStyle: isPaid),
            ],
          ),

          if (isQris && order.paymentProofUrl != null) ...[
            const SizedBox(height: 15),
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
                child: _buildPill('See proof of payment', isPaidStyle: false),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWhiteContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: ShapeDecoration(
        color: const Color(0xFFFDFDFD),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.69),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF426E55),
            fontSize: 11,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF426E55),
            fontSize: 13,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
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

  Widget _buildPill(String text, {bool isPaidStyle = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: ShapeDecoration(
        color: const Color(0xFFEED5DB),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: isPaidStyle
                ? const Color(0xFF426E55)
                : const Color(0xFFCA748D),
          ),
          borderRadius: BorderRadius.circular(62.50),
        ),
      ),
      child: Text(
        text,
        textAlign: TextAlign.right,
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
