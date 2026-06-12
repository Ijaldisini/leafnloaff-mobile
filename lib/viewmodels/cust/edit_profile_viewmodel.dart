import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/user_model.dart';
import '../../services/cust/edit_profile_service.dart';
import '../../utils/image_picker_util.dart';

class EditProfileViewModel extends ChangeNotifier {
  final EditProfileService _service = EditProfileService();
  final ImagePickerUtil _imagePickerUtil = ImagePickerUtil();

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

  Future<UserModel?> saveChanges(
    BuildContext context,
    UserModel currentUser,
  ) async {
    if (nameController.text.trim().isEmpty ||
        usernameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama dan Username tidak boleh kosong')),
      );
      return null;
    }

    _isLoading = true;
    notifyListeners();

    try {
      String? imageUrl = currentUser.profileImageUrl;

      if (_selectedImage != null) {
        final fileExt = _selectedImage!.path.split('.').last;
        final fileName =
            '${currentUser.id}_${DateTime.now().millisecondsSinceEpoch}.$fileExt';

        await Supabase.instance.client.storage
            .from('profile_images')
            .upload(fileName, _selectedImage!);

        imageUrl = Supabase.instance.client.storage
            .from('profile_images')
            .getPublicUrl(fileName);
      }

      await Supabase.instance.client
          .from('profiles')
          .update({
            'full_name': nameController.text.trim(),
            'username': usernameController.text.trim(),
            'phone_number': phoneController.text.trim(),
            'profile_image_url': imageUrl,
          })
          .eq('id', currentUser.id);

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
      if (!context.mounted) return null;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
      );
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
