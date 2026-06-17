import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; 
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
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextField(
                              onChanged: _viewModel.searchVoucher,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                color: Color(0xFF2D4839),
                              ),
                              decoration: InputDecoration(
                                hintText: 'Search voucher...',
                                hintStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'Poppins',
                                ),
                                prefixIcon: Container(
                                  margin: const EdgeInsets.all(4),
                                  width: 32,
                                  height: 32,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF426E55),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      'assets/images/Search.svg',
                                      width: 16,
                                      height: 16,
                                      colorFilter: const ColorFilter.mode(
                                        Colors.white,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AdminAddVoucherView(),
                              ),
                            );
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment(1.00, 1.00),
                                end: Alignment(0.00, 0.00),
                                colors: [
                                  Color(0xFF73986F),
                                  Color(0xFFFDFDFD),
                                ],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  blurRadius: 4,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/lingkaran hijau.svg',
                                    width: 28,
                                    height: 28,
                                  ),
                                  SvgPicture.asset(
                                    'assets/images/tambah.svg',
                                    width: 14,
                                    height: 14,
                                    colorFilter: const ColorFilter.mode(
                                      Color.fromARGB(255, 59, 88, 62),
                                      BlendMode.srcIn,
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
    );
  }

  Widget _buildVoucherCard(VoucherModel voucher) {
    final expiry = _viewModel.formatExpiryDate(voucher.expiresAt);
    final bool isExpired = !voucher.isActive;

    Widget cardContent = Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
          colors: [
            Color(0xFFD699AB),
            Color(0xFFFDFDFD),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ✅ GAMBAR VOUCHER
          Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFCA748D),
                width: 1,
              ),
              image: DecorationImage(
                image: NetworkImage(voucher.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // ✅ KONTEN VOUCHER
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        voucher.title,
                        style: const TextStyle(
                          color: Color(0xFFCA748D),
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        // ✅ TOMBOL MORE INFO
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdminDetailVoucherView(voucher: voucher),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDFDFD),
                              border: Border.all(
                                color: const Color(0xFF426E55),
                                width: 0.85,
                              ),
                              borderRadius: BorderRadius.circular(53),
                            ),
                            child: const Text(
                              'More Info',
                              style: TextStyle(
                                color: Color(0xFF426E55),
                                fontSize: 10,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        
                        // GestureDetector(
                        //   onTap: () => _showDeleteConfirmation(voucher),
                        //   child: SvgPicture.asset(
                        //     'assets/images/sampah.svg',
                        //     width: 20,
                        //     height: 20,
                        //     colorFilter: const ColorFilter.mode(
                        //       Color(0xFFC23437),
                        //       BlendMode.srcIn,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${voucher.discountPercentage}% Off',
                      style: const TextStyle(
                        color: Color(0xFFCA748D),
                        fontSize: 32,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        height: 1.0,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/images/jam.svg',
                              width: 12,
                              height: 12,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFFCA748D),
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Expires on $expiry',
                              style: const TextStyle(
                                color: Color(0xFFCA748D),
                                fontSize: 10,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/images/catatan.svg',
                              width: 12,
                              height: 12,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFFCA748D),
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 4),
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
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (isExpired) {
      return Opacity(
        opacity: 0.65,
        child: ColorFiltered(
          colorFilter: const ColorFilter.matrix(<double>[
            0.2126, 0.7152, 0.0722, 0, 0,
            0.2126, 0.7152, 0.0722, 0, 0,
            0.2126, 0.7152, 0.0722, 0, 0,
            0, 0, 0, 1, 0,
          ]),
          child: cardContent,
        ),
      );
    }

    return cardContent;
  }
  // void _showDeleteConfirmation(VoucherModel voucher) {
  //   showDialog(
  //     context: context,
  //     builder: (dialogContext) => AlertDialog(
  //       backgroundColor: const Color(0xFFFDFDFD),
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //       title: const Row(
  //         children: [
  //           Icon(Icons.delete_outline, color: Color(0xFFC23437)),
  //           SizedBox(width: 10),
  //           Text(
  //             'Hapus Voucher?',
  //             style: TextStyle(
  //               fontFamily: 'Poppins',
  //               fontWeight: FontWeight.w800,
  //               color: Color(0xFF2D4839),
  //               fontSize: 16,
  //             ),
  //           ),
  //         ],
  //       ),
  //       content: Text(
  //         'Voucher "${voucher.title}" akan dihapus secara permanen.',
  //         style: const TextStyle(
  //           fontFamily: 'Poppins',
  //           fontSize: 13,
  //           color: Color(0xFF51725F),
  //         ),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(dialogContext),
  //           child: const Text(
  //             'Batal',
  //             style: TextStyle(
  //               color: Colors.grey,
  //               fontFamily: 'Poppins',
  //               fontWeight: FontWeight.w600,
  //             ),
  //           ),
  //         ),
  //         TextButton(
  //           onPressed: () async {
  //             Navigator.pop(dialogContext);
  //             final success = await _viewModel.deleteVoucher(voucher.id);
  //             if (mounted) {
  //               if (success) {
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   const SnackBar(
  //                     content: Text('Voucher berhasil dihapus'),
  //                     backgroundColor: Color(0xFF73986F),
  //                   ),
  //                 );
  //               } else {
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   const SnackBar(
  //                     content: Text('Gagal menghapus voucher'),
  //                     backgroundColor: Color(0xFFC23437),
  //                   ),
  //                 );
  //               }
  //             }
  //           },
  //           style: TextButton.styleFrom(
  //             backgroundColor: const Color(0xFFB94F4F).withValues(alpha: 0.1),
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(10),
  //             ),
  //           ),
  //           child: const Text(
  //             'Hapus',
  //             style: TextStyle(
  //               color: Color(0xFFB94F4F),
  //               fontFamily: 'Poppins',
  //               fontWeight: FontWeight.w700,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}