import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../viewmodels/cust/checkout_viewmodel.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../models/cart_model.dart';
import 'address_view.dart';
import '../cust/detail_order_view.dart';
import '../cust/select_voucher_view.dart';
import '../../models/voucher_model.dart';

class CheckoutView extends StatefulWidget {
  final VoucherModel? initialVoucher;

  const CheckoutView({super.key, this.initialVoucher});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  final CheckoutViewModel _viewModel = CheckoutViewModel();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.initCheckoutData(initialVoucher: widget.initialVoucher);
    });
  }

  String _formatCurrency(double amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 0,
    ).format(amount);
  }

  @override
  void dispose() {
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
                      Row(
                        children: [
                          const SizedBox(width: 25),
                          GestureDetector(
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
                        ],
                      ),
                      const Text(
                        'Checkout',
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

                      return ListView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 10,
                        ),
                        physics: const BouncingScrollPhysics(),
                        children: [
                          if (_viewModel.errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Text(
                                _viewModel.errorMessage!,
                                style: const TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          _buildShippingOption(),
                          const SizedBox(height: 20),
                          _buildPaymentMethod(),
                          const SizedBox(height: 20),
                          _buildVoucherOption(),
                          const SizedBox(height: 20),
                          const Text(
                            'Order Items',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ..._viewModel.selectedCartItems.map(
                            (item) => _buildItemCard(item),
                          ),
                          const SizedBox(height: 220),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ListenableBuilder(
              listenable: _viewModel,
              builder: (context, _) {
                return Container(
                  height: 194,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 20,
                  ),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFD699AB), Color(0xFFCA748D)],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPriceRow('Sub Total', _viewModel.subTotal),
                      const SizedBox(height: 6),
                      _buildPriceRow('Shipping Cost', _viewModel.shippingCost),
                      const SizedBox(height: 6),
                      _buildPriceRow('Discount', _viewModel.discount),
                      const Spacer(),
                      const Text(
                        'Total Payment',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            _formatCurrency(_viewModel.totalPayment),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          GestureDetector(
                            onTap: _viewModel.isPlacingOrder
                                ? null
                                : () async {
                                    final result = await _viewModel
                                        .placeOrder();

                                    if (result != null && context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Pesanan berhasil dibuat!',
                                          ),
                                          backgroundColor: Color(0xFF426E55),
                                        ),
                                      );
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailOrderView(
                                            orderId: result['orderId'],
                                          ),
                                        ),
                                      );
                                    } else if (result == null &&
                                        context.mounted &&
                                        _viewModel.errorMessage != null) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            _viewModel.errorMessage!,
                                            style: const TextStyle(
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                          backgroundColor: const Color(
                                            0xFFC23437,
                                          ),
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    }
                                  },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF51725F),
                                    Color(0xFF2D4839),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: BorderRadius.circular(100),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: _viewModel.isPlacingOrder
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'Place Order',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(CartItemModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFFFDFDFD),
        borderRadius: BorderRadius.circular(16.69),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16.69),
              bottomLeft: Radius.circular(16.69),
            ),
            child: Image.network(
              item.menuImageUrl ?? 'https://placehold.co/113x100',
              width: 110,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.menuName,
                    style: const TextStyle(
                      color: Color(0xFF2D4839),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'Notes: ${item.notes ?? '-'}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF51725F),
                      fontSize: 10,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Qty: ${item.quantity}',
                    style: const TextStyle(
                      color: Color(0xFF51725F),
                      fontSize: 10,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _formatCurrency(item.menuPrice),
                    style: const TextStyle(
                      color: Color(0xFF2D4839),
                      fontSize: 16,
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

  Widget _buildShippingOption() {
    final isDelivery = _viewModel.shippingMethod == 'Delivery';
    return Container(
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
            children: [
              SvgPicture.asset(
                'assets/images/pickup.svg',
                width: 25,
                height: 25,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF2D4839),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Shipping Option',
                style: TextStyle(
                  color: Color(0xFF2D4839),
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              _buildTogglePill(
                'Pickup',
                !isDelivery,
                () => _viewModel.setShippingMethod('Pickup'),
              ),
              const SizedBox(width: 10),
              _buildTogglePill(
                'Delivery',
                isDelivery,
                () => _viewModel.setShippingMethod('Delivery'),
              ),
            ],
          ),
          if (isDelivery) ...[
            const SizedBox(height: 15),
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF2D4839)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _viewModel.deliveryAddress?.recipientName ??
                            "Recipient's Name",
                        style: const TextStyle(
                          color: Color(0xFF2D4839),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _viewModel.deliveryAddress?.addressDetail ??
                            'Belum ada alamat, silakan tambahkan',
                        style: const TextStyle(
                          color: Color(0xFF51725F),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Text(
                        'Contact: ${_viewModel.deliveryAddress?.phoneNumber ?? '-'}',
                        style: const TextStyle(
                          color: Color(0xFF51725F),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: () async {
                      final selectedAddress = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddressView(),
                        ),
                      );
                      if (selectedAddress != null) {
                        _viewModel.updateSelectedAddress(selectedAddress);
                      }
                    },
                    child: SvgPicture.asset(
                      'assets/images/Pencil.svg',
                      width: 14,
                      height: 14,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF2D4839),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTogglePill(String text, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF2D4839) : Colors.transparent,
          border: Border.all(color: const Color(0xFF2D4839)),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? Colors.white : const Color(0xFF2D4839),
            fontSize: 11,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethod() {
    return Container(
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
            children: [
              SvgPicture.asset(
                'assets/images/uang.svg',
                width: 22,
                height: 22,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF2D4839),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Payment Method',
                style: TextStyle(
                  color: Color(0xFF2D4839),
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _buildPaymentSelectableBox('Cash On Delivery', 'COD'),
          const SizedBox(height: 10),
          _buildPaymentSelectableBox('QRIS', 'QRIS Statis'),
          if (_viewModel.paymentMethod == 'QRIS Statis') _buildQRISSection(),
          const SizedBox(height: 10),
          _buildPaymentSelectableBox('Virtual Account', 'Virtual Account Bank'),
          if (_viewModel.paymentMethod == 'Virtual Account Bank')
            _buildVASection(),
        ],
      ),
    );
  }

  Widget _buildPaymentSelectableBox(String title, String methodValue) {
    final isActive = _viewModel.paymentMethod == methodValue;
    return GestureDetector(
      onTap: () => _viewModel.setPaymentMethod(methodValue),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF2D4839) : Colors.transparent,
          border: Border.all(color: const Color(0xFF2D4839)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : const Color(0xFF2D4839),
            fontSize: 12,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildQRISSection() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF2D4839)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Scan code to pay',
            style: TextStyle(
              color: Color(0xFF2D4839),
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.45,
                maxWidth: MediaQuery.of(context).size.width * 0.85,
              ),
              child: Image.asset(
                'assets/images/qris.jpg',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey.shade200,
                  alignment: Alignment.center,
                  child: const Text(
                    'assets/images/qris.jpg\nTidak Ditemukan',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          GestureDetector(
            onTap: _viewModel.pickPaymentProof,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFEED5DB),
                border: Border.all(color: const Color(0xFFCA748D)),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Text(
                _viewModel.paymentProofFile != null
                    ? 'Proof Uploaded ✔'
                    : 'Upload proof of payment',
                style: const TextStyle(
                  color: Color(0xFFCA748D),
                  fontSize: 11,
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

  Widget _buildVASection() {
    final banks = [
      'BCA Virtual Account',
      'Mandiri Virtual Account',
      'BNI Virtual Account',
      'BRI Virtual Account',
    ];
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF2D4839)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: banks.map((bank) {
          final isSelected = _viewModel.selectedBank == bank;
          return GestureDetector(
            onTap: () => _viewModel.setBank(bank),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF2D4839)
                          : Colors.transparent,
                      border: Border.all(
                        color: const Color(0xFF2D4839),
                        width: 1.5,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    bank,
                    style: const TextStyle(
                      color: Color(0xFF2D4839),
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildVoucherOption() {
    return Container(
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
            children: [
              SvgPicture.asset(
                'assets/images/voucher.svg',
                width: 22,
                height: 22,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF2D4839),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Voucher',
                style: TextStyle(
                  color: Color(0xFF2D4839),
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () async {
              final selected = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SelectVoucherView(
                    selectedVoucher: _viewModel.selectedVoucher,
                  ),
                ),
              );

              if (selected != null) {
                if (selected == 'clear') {
                  _viewModel.selectVoucher(null);
                } else if (selected is VoucherModel) {
                  _viewModel.selectVoucher(selected);
                }
              }
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF2D4839)),
                borderRadius: BorderRadius.circular(10),
                color: _viewModel.selectedVoucher != null
                    ? const Color(0xFFEED5DB)
                    : Colors.transparent,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _viewModel.selectedVoucher != null
                        ? '${_viewModel.selectedVoucher!.title} (${_viewModel.selectedVoucher!.discountPercentage}% Off)'
                        : 'Select Voucher',
                    style: const TextStyle(
                      color: Color(0xFF2D4839),
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_right,
                    color: Color(0xFF2D4839),
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String title, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          _formatCurrency(amount),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
