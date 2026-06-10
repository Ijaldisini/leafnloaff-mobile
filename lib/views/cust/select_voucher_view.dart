import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'detail_voucher_view.dart';

class SelectVoucherView extends StatefulWidget {
  final List<Map<String, dynamic>> availableVouchers;
  final Map<String, dynamic>? selectedVoucher;

  const SelectVoucherView({
    super.key,
    required this.availableVouchers,
    this.selectedVoucher,
  });

  @override
  State<SelectVoucherView> createState() => _SelectVoucherViewState();
}

class _SelectVoucherViewState extends State<SelectVoucherView> {
  Map<String, dynamic>? _currentSelected;

  @override
  void initState() {
    super.initState();
    _currentSelected = widget.selectedVoucher;
  }

  void _handleVoucherSelection(Map<String, dynamic> voucher) {
    if (_currentSelected != null && _currentSelected!['id'] == voucher['id']) {
      setState(() => _currentSelected = null);
    } else {
      setState(() => _currentSelected = voucher);
    }
    Navigator.pop(context, _currentSelected ?? {'clear': true});
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
              width: MediaQuery.of(context).size.width + 34,
              height: 289,
              decoration: const BoxDecoration(color: Color(0xFFD699AB)),
            ),
          ),
          Positioned(
            left: -17,
            top: 147,
            child: Container(
              width: MediaQuery.of(context).size.width + 34,
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
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.pop(context),
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28.0,
                    vertical: 10.0,
                  ),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDFDFD),
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 8),
                        Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                            color: Color(0xFF426E55),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            'Search voucher...',
                            style: TextStyle(
                              color: Colors.grey,
                              fontFamily: 'Poppins',
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: widget.availableVouchers.isEmpty
                      ? const Center(
                          child: Text(
                            'Tidak ada voucher tersedia.',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.only(
                            left: 28,
                            right: 28,
                            bottom: 20,
                          ),
                          physics: const BouncingScrollPhysics(),
                          itemCount: widget.availableVouchers.length,
                          itemBuilder: (context, index) {
                            final voucher = widget.availableVouchers[index];
                            final isSelected =
                                _currentSelected != null &&
                                _currentSelected!['id'] == voucher['id'];

                            String expiryText = '';
                            if (voucher['expires_at'] != null) {
                              final expiryDate = DateTime.parse(
                                voucher['expires_at'],
                              ).toLocal();
                              expiryText =
                                  'Expires on ${DateFormat('MMM dd, yyyy').format(expiryDate)}';
                            }

                            return GestureDetector(
                              onTap: () => _handleVoucherSelection(voucher),
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
                                          image: NetworkImage(
                                            voucher['image_url'] ??
                                                'https://placehold.co/334x121',
                                          ),
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
                                                  voucher['title'] ??
                                                      'Voucher’s Name',
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
                                                        _handleVoucherSelection(
                                                          voucher,
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
                                                '${voucher['discount_percentage']}% Off',
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
                                                  if (expiryText.isNotEmpty)
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
                                                  const Text(
                                                    'Terms and conditions apply',
                                                    style: TextStyle(
                                                      color: Color(0xFFCA748D),
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
                                    ),
                                  ],
                                ),
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
