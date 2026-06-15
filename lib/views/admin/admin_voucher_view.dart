import 'package:flutter/material.dart';
import '../../viewmodels/admin/admin_voucher_viewmodel.dart';
import 'admin_add_voucher_view.dart';
import 'admin_detail_voucher_view.dart';
import '../../models/voucher_model.dart';

class AdminVoucherView extends StatefulWidget {
  const AdminVoucherView({super.key});

  @override
  State<AdminVoucherView> createState() => _AdminVoucherViewState();
}

class _AdminVoucherViewState extends State<AdminVoucherView> {
  final AdminVoucherViewModel _viewModel = AdminVoucherViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.fetchVouchers();
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
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
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
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                      left: 25.0,
                      top: 20.0,
                      bottom: 20.0,
                    ),
                    child: Text(
                      'Voucher Management',
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
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        onChanged: _viewModel.searchVoucher,
                        style: const TextStyle(
                          color: Color(0xFF2D4839),
                          fontFamily: 'Poppins',
                          fontSize: 14,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Search voucher...',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Poppins',
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Color(0xFF426E55),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListenableBuilder(
                      listenable: _viewModel,
                      builder: (context, _) {
                        if (_viewModel.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          );
                        }

                        if (_viewModel.errorMessage != null &&
                            _viewModel.filteredVouchers.isEmpty) {
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

                        if (_viewModel.filteredVouchers.isEmpty) {
                          return const Center(
                            child: Text(
                              "Belum ada voucher.",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          );
                        }

                        return ListView.separated(
                          padding: const EdgeInsets.only(
                            left: 24,
                            right: 24,
                            bottom: 100,
                          ),
                          physics: const BouncingScrollPhysics(),
                          itemCount: _viewModel.filteredVouchers.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final voucher = _viewModel.filteredVouchers[index];
                            return _buildVoucherCard(voucher);
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
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFCA748D),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminAddVoucherView(),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildVoucherCard(VoucherModel voucher) {
    final expiry = _viewModel.formatExpiryDate(voucher.expiresAt);
    final bool isExpired = !voucher.isActive;

    Widget cardContent = GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdminDetailVoucherView(voucher: voucher),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Image.network(
                voucher.imageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 120,
                  color: Colors.grey.shade300,
                  child: const Icon(
                    Icons.broken_image,
                    color: Colors.grey,
                    size: 40,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          voucher.title,
                          style: const TextStyle(
                            color: Color(0xFF2D4839),
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Discount ${voucher.discountPercentage}%',
                          style: const TextStyle(
                            color: Color(0xFF51725F),
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEED5DB),
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: const Color(0xFF426E55),
                            width: 0.85,
                          ),
                        ),
                        child: const Text(
                          'More Info',
                          style: TextStyle(
                            color: Color(0xFF426E55),
                            fontSize: 9.68,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        isExpired ? 'Expired' : 'Expires on $expiry',
                        style: TextStyle(
                          color: isExpired
                              ? Colors.grey.shade700
                              : const Color(0xFFCA748D),
                          fontSize: 10,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Terms and conditions apply',
                        style: TextStyle(
                          color: isExpired
                              ? Colors.grey.shade700
                              : const Color(0xFFCA748D),
                          fontSize: 10,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (isExpired) {
      return Opacity(
        opacity: 0.65,
        child: ColorFiltered(
          colorFilter: const ColorFilter.matrix(<double>[
            0.2126,
            0.7152,
            0.0722,
            0,
            0,
            0.2126,
            0.7152,
            0.0722,
            0,
            0,
            0.2126,
            0.7152,
            0.0722,
            0,
            0,
            0,
            0,
            0,
            1,
            0,
          ]),
          child: cardContent,
        ),
      );
    }

    return cardContent;
  }
}
