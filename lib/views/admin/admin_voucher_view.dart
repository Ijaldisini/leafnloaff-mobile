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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 25, right: 25, top: 15),
                    child: Text(
                      'Voucher',
                      style: TextStyle(
                        color: Color(0xFFFDFDFD),
                        fontSize: 25,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w800,
                        shadows: [
                          Shadow(
                            offset: Offset(2, 2),
                            blurRadius: 4,
                            color: Color(0x3F000000),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 36,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFFDFDFD),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(103.61),
                              ),
                              shadows: const [
                                BoxShadow(
                                  color: Color(0x3F000000),
                                  blurRadius: 4,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: TextField(
                              onChanged: _viewModel.searchVoucher,
                              style: const TextStyle(
                                color: Color(0xFF2D4839),
                                fontSize: 13,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Search vouchers...',
                                hintStyle: TextStyle(
                                  color: Color(0xFF73986F),
                                  fontSize: 13,
                                  fontFamily: 'Poppins',
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Color(0xFF426E55),
                                  size: 20,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),

                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const AdminAddVoucherView(),
                              ),
                            ).then((_) {
                              _viewModel.fetchVouchers();
                            });
                          },
                          child: Container(
                            width: 37,
                            height: 37,
                            decoration: const ShapeDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomRight,
                                end: Alignment.topLeft,
                                colors: [Color(0xFF73986F), Color(0xFFFDFDFD)],
                              ),
                              shape: OvalBorder(),
                              shadows: [
                                BoxShadow(
                                  color: Color(0x3F000000),
                                  blurRadius: 4,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF2D4839),
                                    width: 2.64,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  size: 16,
                                  color: Color(0xFF2D4839),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),

                  Expanded(
                    child: ListenableBuilder(
                      listenable: _viewModel,
                      builder: (context, child) {
                        if (_viewModel.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          );
                        }

                        if (_viewModel.errorMessage != null) {
                          return Center(
                            child: Text(
                              _viewModel.errorMessage!,
                              style: const TextStyle(
                                color: Colors.redAccent,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          );
                        }

                        final listData = _viewModel.filteredVouchers;

                        if (listData.isEmpty) {
                          return const Center(
                            child: Text(
                              "Tidak ada voucher yang sesuai pencarian.",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.only(
                            left: 25,
                            right: 25,
                            bottom: 120,
                          ),
                          physics: const BouncingScrollPhysics(),
                          itemCount: listData.length,
                          itemBuilder: (context, index) {
                            return _buildVoucherCard(listData[index]);
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
    );
  }

  Widget _buildVoucherCard(VoucherModel voucher) {
    String imageUrl = voucher.imageUrl;
    String title = voucher.title;
    String discount = "${voucher.discountPercentage}% Off";
    String expiry = _viewModel.formatExpiryDate(voucher.createdAt);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdminDetailVoucherView(voucher: voucher),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 25),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            colors: [Color(0xFFD699AB), Color(0xFFFDFDFD)],
          ),
          borderRadius: BorderRadius.circular(20),
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
            Container(
              height: 121,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFCA748D)),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) =>
                      const NetworkImage("https://placehold.co/334x121"),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Color(0xFFCA748D),
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          discount,
                          style: const TextStyle(
                            color: Color(0xFFCA748D),
                            fontSize: 35,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            height: 1.1,
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
                          horizontal: 12,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDFDFD),
                          borderRadius: BorderRadius.circular(50),
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
                        'Expires on $expiry',
                        style: const TextStyle(
                          color: Color(0xFFCA748D),
                          fontSize: 10,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Text(
                        'Terms and conditions apply',
                        style: TextStyle(
                          color: Color(0xFFCA748D),
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
  }
}
