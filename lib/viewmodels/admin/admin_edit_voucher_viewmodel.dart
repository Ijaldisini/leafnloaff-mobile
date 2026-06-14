import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/admin/admin_voucher_service.dart';

class AdminEditVoucherViewModel extends ChangeNotifier {
  final VoucherService _voucherService = VoucherService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  File? _newSelectedImage;
  File? get newSelectedImage => _newSelectedImage;

  DateTime? _selectedExpiryDate;
  DateTime? get selectedExpiryDate => _selectedExpiryDate;

  void initExpiryDate(DateTime initialDate) {
    _selectedExpiryDate = initialDate;
  }

  void setExpiryDate(DateTime date) {
    _selectedExpiryDate = date;
    notifyListeners();
  }

  String get formattedSelectedExpiryDate {
    if (_selectedExpiryDate == null) return '';
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[_selectedExpiryDate!.month - 1]} ${_selectedExpiryDate!.day}, ${_selectedExpiryDate!.year}';
  }

  Future<void> pickNewImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      _newSelectedImage = File(image.path);
      notifyListeners();
    }
  }

  Future<String?> updateVoucherData({
    required String id,
    required String name,
    required int discount,
    required String terms,
    required DateTime expiresAt,
  }) async {
    if (name.isEmpty || discount <= 0) {
      return 'Data tidak boleh kosong atau tidak valid.';
    }

    _isLoading = true;
    notifyListeners();

    try {
      String? newImageUrl;

      if (_newSelectedImage != null) {
        newImageUrl = await _voucherService.uploadImage(_newSelectedImage!);
      }

      await _voucherService.updateVoucher(
        id: id,
        title: name,
        discountPercentage: discount,
        termsAndCondition: terms,
        expiresAt: expiresAt,
        newImageUrl: newImageUrl,
      );

      _isLoading = false;
      notifyListeners();
      return null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return 'Gagal menyimpan perubahan. Coba lagi.';
    }
  }
}
