import 'package:flutter/material.dart';
import '../../services/cust/profile_service.dart';

class ProfileViewModel extends ChangeNotifier {
  static final ProfileViewModel _instance = ProfileViewModel._internal();
  factory ProfileViewModel() => _instance;
  ProfileViewModel._internal();

  final ProfileService _service = ProfileService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _service.logout();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Error logout: $e");
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
