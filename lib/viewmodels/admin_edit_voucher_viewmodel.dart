import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/voucher_service.dart';

class AdminEditVoucherViewModel extends ChangeNotifier {
  final VoucherService _voucherService = VoucherService();
  final _supabase = Supabase.instance.client;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  File? _newSelectedImage;
  File? get newSelectedImage => _newSelectedImage;

  DateTime? _selectedExpiryDate;
  DateTime? get selectedExpiryDate => _selectedExpiryDate;

  void initExpiryDate(DateTime initialDate) {
    _selectedExpiryDate = initialDate;
  }

  Future<void> pickExpiryDate(
    BuildContext context,
    DateTime minimumDate,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedExpiryDate ?? minimumDate,
      firstDate: minimumDate,
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFF3D5A4A),
            colorScheme: const ColorScheme.light(primary: Color(0xFF3D5A4A)),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedExpiryDate) {
      _selectedExpiryDate = picked;
      notifyListeners();
    }
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

  Future<bool> updateVoucherData({
    required String id,
    required String name,
    required int discount,
    required String terms,
    required DateTime expiresAt,
  }) async {
    if (name.isEmpty || discount <= 0) return false;

    _isLoading = true;
    notifyListeners();

    try {
      String? newImageUrl;

      if (_newSelectedImage != null) {
        final fileExt = _newSelectedImage!.path.split('.').last;
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';

        await _supabase.storage
            .from('voucher_images')
            .upload(
              fileName,
              _newSelectedImage!,
              fileOptions: const FileOptions(
                cacheControl: '3600',
                upsert: false,
              ),
            );

        newImageUrl = _supabase.storage
            .from('voucher_images')
            .getPublicUrl(fileName);
      }

      final success = await _voucherService.updateVoucher(
        id: id,
        title: name,
        discountPercentage: discount,
        termsAndCondition: terms,
        expiresAt: expiresAt,
        newImageUrl: newImageUrl,
      );

      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      debugPrint("Error updating voucher: $e");
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
