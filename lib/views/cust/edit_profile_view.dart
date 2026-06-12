import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../viewmodels/cust/edit_profile_viewmodel.dart';

class EditProfileView extends StatefulWidget {
  final UserModel user;

  const EditProfileView({super.key, required this.user});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final EditProfileViewModel _viewModel = EditProfileViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.initData(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3D5A4A),
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: 280,
            child: Container(color: const Color(0xFFD699AB)),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 180,
            height: 100,
            child: Container(
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
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.25),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'Edit Profile',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
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
                      const SizedBox(width: 40),
                    ],
                  ),

                  const SizedBox(height: 30),

                  ListenableBuilder(
                    listenable: _viewModel,
                    builder: (context, _) {
                      return GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            builder: (context) => SafeArea(
                              child: Wrap(
                                children: [
                                  ListTile(
                                    leading: const Icon(
                                      Icons.camera_alt,
                                      color: Color(0xFF3D5A4A),
                                    ),
                                    title: const Text(
                                      'Ambil dari Kamera',
                                      style: TextStyle(fontFamily: 'Poppins'),
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                      _viewModel.pickImageFromCamera();
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(
                                      Icons.photo_library,
                                      color: Color(0xFF3D5A4A),
                                    ),
                                    title: const Text(
                                      'Pilih dari Galeri',
                                      style: TextStyle(fontFamily: 'Poppins'),
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                      _viewModel.pickImageFromGallery();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors
                                  .grey
                                  .shade400,
                              backgroundImage: _viewModel.selectedImage != null
                                  ? FileImage(
                                      _viewModel.selectedImage!,
                                    )
                                  : (widget.user.profileImageUrl != null
                                        ? NetworkImage(
                                            widget.user.profileImageUrl!,
                                          )
                                        : null),
                              child:
                                  _viewModel.selectedImage == null &&
                                      widget.user.profileImageUrl == null
                                  ? const Icon(
                                      Icons.person,
                                      size: 60,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Color(0xFFCA748D),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  _buildLabel('Name'),
                  _buildTextField(
                    _viewModel.nameController,
                    'Masukkan Nama Lengkap',
                  ),
                  const SizedBox(height: 16),

                  _buildLabel('Username'),
                  _buildTextField(
                    _viewModel.usernameController,
                    'Masukkan Username',
                  ),
                  const SizedBox(height: 16),

                  _buildLabel('No. Whatsapp'),
                  _buildTextField(
                    _viewModel.phoneController,
                    'Contoh: 08123456789',
                    isNumber: true,
                  ),
                  const SizedBox(height: 16),

                  _buildLabel('Old Password'),
                  _buildTextField(
                    _viewModel.oldPasswordController,
                    'Masukkan Password Lama',
                    isPassword: true,
                  ),
                  const SizedBox(height: 16),

                  _buildLabel('New Password'),
                  _buildTextField(
                    _viewModel.newPasswordController,
                    'Masukkan Password Baru',
                    isPassword: true,
                  ),
                  const SizedBox(height: 40),

                  ListenableBuilder(
                    listenable: _viewModel,
                    builder: (context, _) {
                      return GestureDetector(
                        onTap: _viewModel.isLoading
                            ? null
                            : () async {
                                final updatedUser = await _viewModel
                                    .saveChanges(context, widget.user);
                                if (updatedUser != null && context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Profil berhasil diperbarui!',
                                      ),
                                    ),
                                  );
                                  Navigator.pop(context, updatedUser);
                                }
                              },
                        child: Container(
                          width: 200,
                          height: 46,
                          decoration: ShapeDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xFFD699AB), Color(0xFFCA748D)],
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            shadows: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: _viewModel.isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'Save Changes',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Align(
        alignment: Alignment.centerLeft,
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
                color: Colors.black26,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    bool isPassword = false,
    bool isNumber = false,
  }) {
    return Container(
      height: 44,
      decoration: ShapeDecoration(
        color: const Color(0xFFFDFDFD),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        shadows: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 4)),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: isNumber ? TextInputType.phone : TextInputType.text,
        style: const TextStyle(
          color: Color(0xFF2D4839),
          fontFamily: 'Poppins',
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}
