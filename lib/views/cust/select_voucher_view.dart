import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../models/voucher_model.dart';
import '../../viewmodels/cust/select_voucher_viewmodel.dart';
import 'detail_voucher_view.dart';

class SelectVoucherView extends StatefulWidget {
  final VoucherModel? selectedVoucher;

  const SelectVoucherView({super.key, this.selectedVoucher});

  @override
  State<SelectVoucherView> createState() => _SelectVoucherViewState();
}

class _SelectVoucherViewState extends State<SelectVoucherView> {
  final SelectVoucherViewModel _viewModel = SelectVoucherViewModel();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.initVoucherData(
        widget.selectedVoucher,
        onError: _showErrorDialog,
      );
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

  Future<void> _refreshVouchers() async {
    await _viewModel.fetchVouchers(onError: _showErrorDialog);
    await Future.delayed(const Duration(milliseconds: 300));
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
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: GestureDetector(
                            onTap: () => Navigator.pop(
                              context,
                              _viewModel.selectedVoucher ?? 'clear',
                            ),
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
                      ),
                      const Text(
                        'Select Voucher',
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
                    builder: (context, child) {
                      if (_viewModel.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      }
                      if (_viewModel.vouchers.isEmpty) {
                        return const Center(
                          child: Text(
                            'Tidak ada voucher tersedia.',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        );
                      }

                      return RefreshIndicator(
                        color: const Color(0xFFCA748D),
                        backgroundColor: Colors.white,
                        onRefresh: _refreshVouchers,
                        child: ListView.builder(
                          padding: const EdgeInsets.only(
                            left: 28,
                            right: 28,
                            bottom: 20,
                          ),
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          itemCount: _viewModel.vouchers.length,
                          itemBuilder: (context, index) {
                            final voucher = _viewModel.vouchers[index];
                            final isSelected =
                                _viewModel.selectedVoucher?.id == voucher.id;
                            final expiryText =
                                'Expires on ${DateFormat('MMM dd, yyyy').format(voucher.expiresAt)}';

                            return GestureDetector(
                              onTap: () {
                                _viewModel.toggleVoucherSelection(voucher);
                                Navigator.pop(
                                  context,
                                  _viewModel.selectedVoucher ?? 'clear',
                                );
                              },
                              child: Container(
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
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
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
                                                  GestureDetector(
                                                    onTap: () async {
                                                      final useVoucher =
                                                          await Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  DetailVoucherView(
                                                                    voucher:
                                                                        voucher,
                                                                  ),
                                                            ),
                                                          );
                                                      if (useVoucher == true) {
                                                        _viewModel
                                                            .toggleVoucherSelection(
                                                              voucher,
                                                            );
                                                        Navigator.pop(
                                                          context,
                                                          _viewModel
                                                              .selectedVoucher,
                                                        );
                                                      }
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 2,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                          0xFFFDFDFD,
                                                        ),
                                                        border: Border.all(
                                                          color: const Color(
                                                            0xFF426E55,
                                                          ),
                                                          width: 0.85,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              53,
                                                            ),
                                                      ),
                                                      child: const Text(
                                                        'More Info',
                                                        style: TextStyle(
                                                          color: Color(
                                                            0xFF426E55,
                                                          ),
                                                          fontSize: 10,
                                                          fontFamily: 'Poppins',
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Container(
                                                    width: 20,
                                                    height: 20,
                                                    decoration: BoxDecoration(
                                                      color: isSelected
                                                          ? const Color(
                                                              0xFF426E55,
                                                            )
                                                          : Colors.transparent,
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color: const Color(
                                                          0xFF426E55,
                                                        ),
                                                        width: 2,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
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
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Row(
                                                    children: [
                                                      SvgPicture.asset(
                                                        'assets/images/jam.svg',
                                                        width: 12,
                                                        height: 12,
                                                        colorFilter:
                                                            const ColorFilter.mode(
                                                              Color(0xFFCA748D),
                                                              BlendMode.srcIn,
                                                            ),
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        expiryText,
                                                        style: const TextStyle(
                                                          color: Color(
                                                            0xFFCA748D,
                                                          ),
                                                          fontSize: 10,
                                                          fontFamily: 'Poppins',
                                                          fontWeight:
                                                              FontWeight.w600,
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
                                                        colorFilter:
                                                            const ColorFilter.mode(
                                                              Color(0xFFCA748D),
                                                              BlendMode.srcIn,
                                                            ),
                                                      ),
                                                      const SizedBox(width: 4),
                                                      const Text(
                                                        'Terms and conditions apply',
                                                        style: TextStyle(
                                                          color: Color(
                                                            0xFFCA748D,
                                                          ),
                                                          fontSize: 10,
                                                          fontFamily: 'Poppins',
                                                          fontWeight:
                                                              FontWeight.w600,
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
                              ),
                            );
                          },
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
}
