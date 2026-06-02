import 'package:flutter/material.dart';
import '../../viewmodels/admin_add_menu_viewmodel.dart';

class AdminAddMenuView extends StatefulWidget {
  const AdminAddMenuView({super.key});

  @override
  State<AdminAddMenuView> createState() => _AdminAddMenuViewState();
}

class _AdminAddMenuViewState extends State<AdminAddMenuView> {
  final AdminAddMenuViewModel _viewModel = AdminAddMenuViewModel();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF3D5A4A),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, child) {
          return Stack(
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
                    const SizedBox(height: 20),
                    const Text(
                      'New Menu',
                      style: TextStyle(
                        color: Color(0xFFFDFDFD),
                        fontSize: 25,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w800,
                        shadows: [
                          Shadow(
                            offset: Offset(2, 2),
                            blurRadius: 4,
                            color: Color(0x40000000),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Item’s Name'),
                            _buildTextField(
                              controller: _viewModel.nameController,
                            ),

                            _buildLabel('Category'),
                            _buildDropdown(),

                            _buildLabel('Description'),
                            _buildTextField(
                              controller: _viewModel.descController,
                              height: 125,
                              borderRadius: 10,
                              maxLines: 4,
                            ),

                            _buildLabel('Price'),
                            _buildTextField(
                              controller: _viewModel.priceController,
                              keyboardType: TextInputType.number,
                            ),

                            _buildLabel('Stock Amount'),
                            _buildTextField(
                              controller: _viewModel.stockController,
                              keyboardType: TextInputType.number,
                            ),

                            _buildLabel('Upload Photo'),
                            _buildPhotoPicker(),

                            const SizedBox(height: 40),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildButton(
                                  text: 'Discard',
                                  colors: [
                                    const Color(0xFFF26F71),
                                    const Color(0xFFC23437),
                                  ],
                                  onTap: () => Navigator.pop(context),
                                ),
                                _buildButton(
                                  text: _viewModel.isLoading
                                      ? 'Saving...'
                                      : 'Save',
                                  colors: [
                                    const Color(0xFFD699AB),
                                    const Color(0xFFCA748D),
                                  ],
                                  onTap: _viewModel.isLoading
                                      ? null
                                      : () async {
                                          bool success = await _viewModel
                                              .saveMenu(context);
                                          if (success && context.mounted) {
                                            Navigator.pop(context, true);
                                          }
                                        },
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPhotoPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_viewModel.selectedImage != null)
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 150,
                margin: const EdgeInsets.only(bottom: 15),
                decoration: ShapeDecoration(
                  color: Colors.black12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  image: DecorationImage(
                    image: FileImage(_viewModel.selectedImage!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: GestureDetector(
                  onTap: _viewModel.removeSelectedImage,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),

        Row(
          children: [
            GestureDetector(
              onTap: _viewModel.pickFromGallery,
              child: Container(
                width: 68,
                height: 68,
                decoration: ShapeDecoration(
                  color: const Color(0xFFFDFDFD),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 4,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.photo_library,
                      color: Color(0xFF3D5A4A),
                      size: 28,
                    ),
                    Text(
                      'Gallery',
                      style: TextStyle(
                        color: Color(0xFF3D5A4A),
                        fontSize: 10,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 15),
            GestureDetector(
              onTap: _viewModel.pickFromCamera,
              child: Container(
                width: 68,
                height: 68,
                decoration: ShapeDecoration(
                  color: const Color(0xFFFDFDFD),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 4,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt, color: Color(0xFF3D5A4A), size: 28),
                    Text(
                      'Camera',
                      style: TextStyle(
                        color: Color(0xFF3D5A4A),
                        fontSize: 10,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 15),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFFDFDFD),
          fontSize: 18,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700,
          shadows: [
            Shadow(
              offset: Offset(2, 2),
              blurRadius: 4,
              color: Color(0x40000000),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    double height = 38,
    double borderRadius = 108.57,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? hintText,
  }) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: ShapeDecoration(
        color: const Color(0xFFFDFDFD),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
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
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: maxLines > 1 ? 12 : 10,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      width: double.infinity,
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: ShapeDecoration(
        color: const Color(0xFFFDFDFD),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(108.57),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _viewModel.selectedCategory,
          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF3D5A4A)),
          isExpanded: true,
          style: const TextStyle(
            color: Color(0xFF3D5A4A),
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          onChanged: (String? newValue) {
            if (newValue != null) {
              _viewModel.setCategory(newValue);
            }
          },
          items: _viewModel.categories.map<DropdownMenuItem<String>>((
            String value,
          ) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required List<Color> colors,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        height: 35,
        alignment: Alignment.center,
        decoration: ShapeDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: colors,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(85.71),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 3.16,
              offset: Offset(0, 3.16),
            ),
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFFFBFBFB),
            fontSize: 15.79,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            shadows: [
              Shadow(
                offset: Offset(2, 2),
                blurRadius: 3,
                color: Color(0x40000000),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
