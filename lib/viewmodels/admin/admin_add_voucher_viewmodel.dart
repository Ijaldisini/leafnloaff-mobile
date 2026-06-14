import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/admin/admin_voucher_service.dart';

class AdminAddVoucherViewModel extends ChangeNotifier {
  final VoucherService _voucherService = VoucherService();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  File? _selectedImage;
  File? get selectedImage => _selectedImage;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      _selectedImage = File(image.path);
      notifyListeners();
    }
  }

  Future<String?> saveVoucher({
    required String name,
    required int discount,
    required String terms,
    required String expiration,
  }) async {
    if (name.isEmpty || expiration.isEmpty) {
      return 'Nama dan tanggal kedaluwarsa wajib diisi!';
    }
    if (discount <= 0 || discount > 100) {
      return 'Diskon harus berupa angka antara 1 hingga 100!';
    }

    _isLoading = true;
    notifyListeners();

    try {
      DateTime expiresAt;
      try {
        final parts = expiration.split('/');
        expiresAt = DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
      } catch (e) {
        _isLoading = false;
        notifyListeners();
        return 'Format tanggal tidak valid. Gunakan DD/MM/YYYY.';
      }

      String? imageUrl;
      if (_selectedImage != null) {
        imageUrl = await _voucherService.uploadImage(_selectedImage!);
      }

      await _voucherService.createVoucher(
        title: name,
        discountPercentage: discount,
        termsAndCondition: terms,
        expiresAt: expiresAt,
        imageUrl: imageUrl,
      );

      _isLoading = false;
      notifyListeners();
      return null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.toString().replaceAll('Exception: ', ''); 
    }
  }
}
