import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/cust/edit_profile_service.dart';

class EditProfileViewModel extends ChangeNotifier {
  final EditProfileService _service = EditProfileService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void initData(UserModel user) {
    nameController.text = user.fullName;
    usernameController.text = user.username;
    phoneController.text = user.phoneNumber ?? '';
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
      await _service.updateProfile(
        fullName: nameController.text.trim(),
        username: usernameController.text.trim(),
        phoneNumber: phoneController.text.trim(),
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
      );
    } catch (e) {
      _isLoading = false;
      notifyListeners();
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
