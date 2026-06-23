import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/cust/edit_profile_service.dart';
import '../../utils/image_picker_util.dart';

class EditProfileViewModel extends ChangeNotifier {
  final EditProfileService _service;
  final ImagePickerUtil _imagePickerUtil;

  EditProfileViewModel({
    required EditProfileService service,
    ImagePickerUtil? imagePickerUtil,
  }) : _service = service,
       _imagePickerUtil = imagePickerUtil ?? ImagePickerUtil();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  File? _selectedImage;
  File? get selectedImage => _selectedImage;

  void initData(UserModel user) {
    nameController.text = user.fullName;
    usernameController.text = user.username;
    phoneController.text = user.phoneNumber ?? '';
  }

  Future<void> pickImageFromGallery() async {
    final file = await _imagePickerUtil.pickFromGallery();
    if (file != null) {
      _selectedImage = file;
      notifyListeners();
    }
  }

  Future<void> pickImageFromCamera() async {
    final file = await _imagePickerUtil.pickFromCamera();
    if (file != null) {
      _selectedImage = file;
      notifyListeners();
    }
  }

  Future<UserModel?> saveProfile(
    UserModel currentUser, {
    Function(String)? onError,
  }) async {
    if (nameController.text.trim().isEmpty ||
        usernameController.text.trim().isEmpty) {
      onError?.call('Nama dan Username tidak boleh kosong!');
      return null;
    }

    _isLoading = true;
    notifyListeners();

    try {
      String? imageUrl = currentUser.profileImageUrl;

      if (_selectedImage != null) {
        final fileName =
            '${currentUser.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';
        imageUrl = await _service.uploadProfileImage(_selectedImage!, fileName);
      }

      await _service.updateProfile(
        fullName: nameController.text.trim(),
        username: usernameController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        profileImageUrl: imageUrl,
      );

      if (newPasswordController.text.isNotEmpty) {
        await _service.updatePassword(newPasswordController.text);
      }

      _isLoading = false;
      notifyListeners();

      return currentUser.copyWith(
        fullName: nameController.text.trim(),
        username: usernameController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        profileImageUrl: imageUrl,
      );
    } catch (e) {
      _isLoading = false;
      notifyListeners();

      onError?.call(e.toString().replaceAll('Exception: ', ''));
      return null;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    phoneController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }
}
