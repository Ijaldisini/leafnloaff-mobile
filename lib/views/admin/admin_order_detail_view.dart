import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class AdminOrderDetailView extends StatefulWidget {
  final String orderId;

  const AdminOrderDetailView({super.key, required this.orderId});

  @override
  State<AdminOrderDetailView> createState() => _AdminOrderDetailViewState();
}

class _AdminOrderDetailViewState extends State<AdminOrderDetailView> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  Map<String, dynamic>? _orderData;

  @override
  void initState() {
    super.initState();
    _fetchOrderDetail();
  }

  Future<void> _fetchOrderDetail() async {
    try {
      final response = await _supabase
          .from('orders')
          .select('''
        id, created_at, status, total_price, notes, payment_method, address_detail,
        profiles:user_id ( full_name, phone_number ),
        order_items (
          quantity,
          menus ( name, price, image_url )
        )
      ''')
          .eq('id', widget.orderId)
          .single();

      if (mounted) {
        setState(() {
          _orderData = response;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error Fetching Order Detail: $e");
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFFFDFDFD)),
                  )
                : _orderData == null
                ? const Center(
                    child: Text(
                      "Data pesanan tidak ditemukan",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : Column(
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
                                    'Order ID: ${_orderData!['id'].toString().substring(0, 8).toUpperCase()}',
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
                            _buildStatusCard(_orderData!['status'] ?? ''),
                            const SizedBox(height: 20),
                            _buildCustomerInfoCard(_orderData!),
                            const SizedBox(height: 20),
                            _buildOrderItemsList(_orderData!['order_items']),
                            const SizedBox(height: 20),
                            _buildSummaryCard(_orderData!),
                            const SizedBox(height: 20),
                            _buildPaymentCard(_orderData!),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
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

  Widget _buildCustomerInfoCard(Map<String, dynamic> orderData) {
    final profile = orderData['profiles'];

    final name = profile?['full_name'] ?? 'Guest Customer';
    final phone = profile?['phone_number'] ?? '-';
    final address = orderData['address_detail'] ?? 'Pickup / Tidak ada alamat';

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
          _buildInfoRow('Customer’s Name', name),
          const SizedBox(height: 5),
          _buildInfoRow('Phone Number', phone),
          const SizedBox(height: 5),
          _buildInfoRow('Address', address),
          const SizedBox(height: 15),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: ShapeDecoration(
                color: const Color(0xFFEED5DB),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Color(0xFFCA748D)),
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
        ],
      ),
    );
  }

  Widget _buildOrderItemsList(List<dynamic> items) {
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
          final menu = item['menus'] ?? {};
          final qty = item['quantity']?.toString() ?? '1';
          final price = NumberFormat.currency(
            locale: 'id_ID',
            symbol: 'Rp. ',
            decimalDigits: 0,
          ).format(menu['price'] ?? 0);
          final imageUrl = menu['image_url'];

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
                    child: imageUrl != null && imageUrl.toString().isNotEmpty
                        ? Image.network(
                            imageUrl,
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
                          menu['name'] ?? 'Unknown Item',
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
                              'Qty: $qty',
                              style: const TextStyle(
                                color: Color(0xFF426E55),
                                fontSize: 9,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              price,
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

  Widget _buildSummaryCard(Map<String, dynamic> orderData) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 0,
    );
    final total = formatCurrency.format(orderData['total_price'] ?? 0);
    final notes = orderData['notes'] ?? '-';

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
                  notes,
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

  Widget _buildPaymentCard(Map<String, dynamic> orderData) {
    final method = (orderData['payment_method'] ?? 'QRIS')
        .toString()
        .toUpperCase();

    final isPaid =
        orderData['status']?.toString().toLowerCase() != 'menunggu pembayaran';

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
              _buildPill(method),
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
              _buildPill(isPaid ? 'Paid' : 'Unpaid'),
            ],
          ),
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

  Widget _buildPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: ShapeDecoration(
        color: const Color(0xFFEED5DB),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFCA748D)),
          borderRadius: BorderRadius.circular(62.50),
        ),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFFCA748D),
          fontSize: 11.39,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
