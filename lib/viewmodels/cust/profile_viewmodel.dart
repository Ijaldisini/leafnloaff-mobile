import 'package:flutter/material.dart';
import '../../services/cust/profile_service.dart';

class ProfileViewModel extends ChangeNotifier {
  final ProfileService _service;

  ProfileViewModel({required ProfileService service}) : _service = service;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _service.logout();
      return true;
    } catch (e) {
      debugPrint("Error logout: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
