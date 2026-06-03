import 'package:flutter/material.dart';
import '../../viewmodels/admin/admin_add_voucher_viewmodel.dart';

class AdminAddVoucherView extends StatefulWidget {
  const AdminAddVoucherView({super.key});

  @override
  State<AdminAddVoucherView> createState() => _AdminAddVoucherViewState();
}

class _AdminAddVoucherViewState extends State<AdminAddVoucherView> {
  final AdminAddVoucherViewModel _viewModel = AdminAddVoucherViewModel();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _termsController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _expirationController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _expirationController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _onSave() async {
    final success = await _viewModel.saveVoucher(
      name: _nameController.text,
      discount: int.tryParse(_discountController.text) ?? 0,
      terms: _termsController.text,
      expiration: _expirationController.text,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Voucher berhasil ditambahkan!')),
      );
      Navigator.pop(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menyimpan voucher. Cek kembali isian Anda.'),
        ),
      );
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
                            size: 28,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),

                        const Expanded(
                          child: Text(
                            'New Voucher',
                            textAlign: TextAlign
                                .center,
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

                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: 30),

                    _buildLabel('Voucher’s Photo'),
                    const SizedBox(height: 10),

                    ListenableBuilder(
                      listenable: _viewModel,
                      builder: (context, child) {
                        return GestureDetector(
                          onTap: _viewModel.pickImage,
                          child: Container(
                            width: double.infinity,
                            height: 121,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDFDFD),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFF2D4839),
                                width: 1.5,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x3F000000),
                                  blurRadius: 4,
                                  offset: Offset(0, 4),
                                ),
                              ],
                              image: _viewModel.selectedImage != null
                                  ? DecorationImage(
                                      image: FileImage(
                                        _viewModel.selectedImage!,
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: _viewModel.selectedImage == null
                                ? const Center(
                                    child: Text(
                                      'Tap here to add photo',
                                      style: TextStyle(
                                        color: Color(0xFF2D4839),
                                        fontSize: 15,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    _buildLabel('Voucher’s Name'),
                    _buildTextField(_nameController, height: 45),

                    _buildLabel('Terms and Condition'),
                    _buildTextField(_termsController, height: 100, maxLines: 4),

                    _buildLabel('Discount (%)'),
                    _buildTextField(
                      _discountController,
                      height: 45,
                      isNumber: true,
                    ),

                    _buildLabel('Expiration Date'),
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: _buildTextField(
                          _expirationController,
                          height: 45,
                          hint: "DD/MM/YYYY",
                        ),
                      ),
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
                              onTap: _onSave,
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
    String hint = "",
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
          hintText: hint,
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
