import 'package:flutter/material.dart';
import '../../models/voucher_model.dart';
import '../../viewmodels/admin/admin_edit_voucher_viewmodel.dart';

class AdminEditVoucherView extends StatefulWidget {
  final VoucherModel voucher;

  const AdminEditVoucherView({super.key, required this.voucher});

  @override
  State<AdminEditVoucherView> createState() => _AdminEditVoucherViewState();
}

class _AdminEditVoucherViewState extends State<AdminEditVoucherView> {
  final AdminEditVoucherViewModel _viewModel = AdminEditVoucherViewModel();

  late TextEditingController _nameController;
  late TextEditingController _termsController;
  late TextEditingController _discountController;

  @override
  void initState() {
    super.initState();
    _viewModel.initExpiryDate(widget.voucher.expiresAt);

    _nameController = TextEditingController(text: widget.voucher.title);
    _termsController = TextEditingController(
      text: widget.voucher.termsAndCondition,
    );
    _discountController = TextEditingController(
      text: widget.voucher.discountPercentage.toString(),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _termsController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _viewModel.selectedExpiryDate ?? widget.voucher.expiresAt,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFF3D5A4A),
            colorScheme: const ColorScheme.light(primary: Color(0xFF3D5A4A)),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      _viewModel.setExpiryDate(picked);
    }
  }

  void _onUpdate() async {
    final errorMsg = await _viewModel.updateVoucherData(
      id: widget.voucher.id,
      name: _nameController.text,
      discount: int.tryParse(_discountController.text) ?? 0,
      terms: _termsController.text,
      expiresAt: _viewModel.selectedExpiryDate!,
    );

    if (!mounted) return;

    if (errorMsg == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Voucher berhasil diperbarui!')),
      );
      Navigator.pop(context, true);
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMsg)));
    }
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
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          alignment: Alignment.centerLeft,
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Text(
                          'Edit Voucher',
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
                    const SizedBox(height: 20),
                    _buildLabel('Voucher’s Photo'),
                    const SizedBox(height: 10),
                    ListenableBuilder(
                      listenable: _viewModel,
                      builder: (context, child) {
                        return Center(
                          child: Stack(
                            alignment: Alignment.bottomCenter,
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
                                  image: _viewModel.newSelectedImage != null
                                      ? DecorationImage(
                                          image: FileImage(
                                            _viewModel.newSelectedImage!,
                                          ),
                                          fit: BoxFit.cover,
                                        )
                                      : DecorationImage(
                                          image: NetworkImage(
                                            widget.voucher.imageUrl,
                                          ),
                                          fit: BoxFit.cover,
                                          onError: (exception, stackTrace) =>
                                              const NetworkImage(
                                                "https://placehold.co/334x121.png",
                                              ),
                                        ),
                                ),
                              ),
                              Positioned(
                                bottom: -10,
                                child: GestureDetector(
                                  onTap: _viewModel.pickNewImage,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color(0xFFD699AB),
                                          Color(0xFFCA748D),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(53),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color(0x3F000000),
                                          blurRadius: 4,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: const Text(
                                      'Change Photo',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    _buildLabel('Voucher’s Name'),
                    _buildTextField(_nameController, height: 45),
                    _buildLabel('Terms and Condition'),
                    _buildTextField(_termsController, height: 120, maxLines: 5),
                    _buildLabel('Discount (%)'),
                    _buildTextField(
                      _discountController,
                      height: 45,
                      isNumber: true,
                    ),

                    _buildLabel('Expiration Date'),
                    ListenableBuilder(
                      listenable: _viewModel,
                      builder: (context, child) {
                        return GestureDetector(
                          onTap: () => _selectDate(context),
                          child: Container(
                            height: 45,
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDFDFD),
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x3F000000),
                                  blurRadius: 4,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _viewModel.formattedSelectedExpiryDate,
                                  style: const TextStyle(
                                    color: Color(0xFF2D4839),
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                  ),
                                ),
                                const Icon(
                                  Icons.calendar_month,
                                  color: Color(0xFF426E55),
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 40),
                    ListenableBuilder(
                      listenable: _viewModel,
                      builder: (context, child) {
                        if (_viewModel.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          );
                        }
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                width: 140,
                                height: 40,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xFFF26F71),
                                      Color(0xFFC23437),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(85),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x3F000000),
                                      blurRadius: 3,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Text(
                                    'Discard',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            GestureDetector(
                              onTap: _onUpdate,
                              child: Container(
                                width: 140,
                                height: 40,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xFFD699AB),
                                      Color(0xFFCA748D),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(85),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x3F000000),
                                      blurRadius: 3,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Text(
                                    'Save',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 15),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFFDFDFD),
          fontSize: 16,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700,
          shadows: [
            Shadow(
              offset: Offset(1, 1),
              blurRadius: 2,
              color: Color(0x3F000000),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller, {
    required double height,
    int maxLines = 1,
    bool isNumber = false,
  }) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFFDFDFD),
        borderRadius: BorderRadius.circular(maxLines > 1 ? 10 : 50),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: const TextStyle(
          color: Color(0xFF2D4839),
          fontFamily: 'Poppins',
          fontSize: 14,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: maxLines > 1 ? 12 : 0,
          ),
        ),
      ),
    );
  }
}
