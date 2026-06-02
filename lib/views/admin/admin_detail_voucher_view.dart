import 'package:flutter/material.dart';
import '../../models/voucher_model.dart';
import 'admin_edit_voucher_view.dart';

class AdminDetailVoucherView extends StatelessWidget {
  final VoucherModel voucher;

  const AdminDetailVoucherView({super.key, required this.voucher});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final String imageUrl = voucher.imageUrl;
    final String title = voucher.title;
    final String discount = "${voucher.discountPercentage}% Off";

    final String terms = voucher.termsAndCondition;

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
                  padding: const EdgeInsets.only(left: 15, right: 25, top: 15),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        'Detail Voucher',
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
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(
                      left: 25,
                      right: 25,
                      top: 10,
                      bottom: 120,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 121,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x3F000000),
                                blurRadius: 4,
                                offset: Offset(0, 4),
                              ),
                            ],
                            image: DecorationImage(
                              image: NetworkImage(imageUrl),
                              fit: BoxFit.cover,
                              onError: (exception, stackTrace) =>
                                  const NetworkImage(
                                    "https://placehold.co/334x121",
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDFDFD),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  color: Color(0xFF51725F),
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                discount,
                                style: const TextStyle(
                                  color: Color(0xFF2D4839),
                                  fontSize: 35,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                  height: 1.1,
                                ),
                              ),
                              const SizedBox(height: 25),
                              const Text(
                                'Terms and Conditions',
                                style: TextStyle(
                                  color: Color(0xFF2D4839),
                                  fontSize: 18,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                terms,
                                style: const TextStyle(
                                  color: Color(0xFF51725F),
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 98,
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
                    color: Color(0x3F000000),
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AdminEditVoucherView(voucher: voucher),
                      ),
                    );
                  },
                  child: Container(
                    width: 140,
                    height: 35,
                    decoration: BoxDecoration(
                      color: const Color(0xFF426E55),
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x3F000000),
                          blurRadius: 4,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Edit Voucher',
                        style: TextStyle(
                          color: Color(0xFFFBFBFB),
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
