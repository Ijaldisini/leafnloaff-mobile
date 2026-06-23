import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../models/user_model.dart';
import '../../viewmodels/cust/edit_profile_viewmodel.dart';
import '../../services/cust/edit_profile_service.dart';
import '../../utils/image_picker_util.dart';

class EditProfileView extends StatefulWidget {
  final UserModel user;

  const EditProfileView({super.key, required this.user});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  late final EditProfileViewModel _viewModel;

  bool _showOldPassword = false;
  bool _showNewPassword = false;

  @override
  void initState() {
    super.initState();
    _viewModel = EditProfileViewModel(
      service: EditProfileService(),
      imagePickerUtil: ImagePickerUtil(),
    );
    _viewModel.initData(widget.user);
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
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
            child: RefreshIndicator(
              color: const Color(0xFFCA748D),
              backgroundColor: Colors.white,
              onRefresh: _refreshData,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
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
                                backgroundColor: Colors.grey.shade400,
                                backgroundImage:
                                    _viewModel.selectedImage != null
                                    ? FileImage(_viewModel.selectedImage!)
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
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  shape: BoxShape.circle,
                                ),
                                child: SvgPicture.asset(
                                  'assets/images/Pencil.svg',
                                  width: 18,
                                  height: 18,
                                  colorFilter: const ColorFilter.mode(
                                    Color.fromARGB(255, 64, 95, 69),
                                    BlendMode.srcIn,
                                  ),
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
                      isPasswordVisible: _showOldPassword,
                      onToggleVisibility: () {
                        setState(() {
                          _showOldPassword = !_showOldPassword;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    _buildLabel('New Password'),
                    _buildTextField(
                      _viewModel.newPasswordController,
                      'Masukkan Password Baru',
                      isPassword: true,
                      isPasswordVisible: _showNewPassword,
                      onToggleVisibility: () {
                        setState(() {
                          _showNewPassword = !_showNewPassword;
                        });
                      },
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
                                      .saveProfile(
                                        widget.user,
                                        onError: _showErrorDialog,
                                      );

                                  if (updatedUser != null && context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Profil berhasil disimpan!',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        backgroundColor: Color(0xFF426E55),
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
    bool isPasswordVisible = false,
    VoidCallback? onToggleVisibility,
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
        obscureText: isPassword ? !isPasswordVisible : false,
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
          suffixIcon: isPassword
              ? GestureDetector(
                  onTap: onToggleVisibility,
                  child: Icon(
                    !isPasswordVisible
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 19,
                    color: const Color(0xFFCA748D),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
