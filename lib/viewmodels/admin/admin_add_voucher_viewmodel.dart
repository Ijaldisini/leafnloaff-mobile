import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class AdminAddVoucherViewModel extends ChangeNotifier {
  final _supabase = Supabase.instance.client;

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

  Future<bool> saveVoucher({
    required String name,
    required int discount,
    required String terms,
    required String expiration,
  }) async {
    if (name.isEmpty || discount <= 0) return false;

    _isLoading = true;
    notifyListeners();

    try {
      String? imageUrl;

      if (_selectedImage != null) {
        final fileExt = _selectedImage!.path.split('.').last;
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';

        await _supabase.storage
            .from('voucher_images')
            .upload(
              fileName,
              _selectedImage!,
              fileOptions: const FileOptions(
                cacheControl: '3600',
                upsert: false,
              ),
            );

        imageUrl = _supabase.storage
            .from('voucher_images')
            .getPublicUrl(fileName);
      }

      await _supabase.from('vouchers').insert({
        'title': name,
        'discount_percentage': discount,
        'image_url':
            imageUrl ?? 'https://placehold.co/334x121',
        'is_active': true,
        'terms_and_condition': terms,
      });

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Error saving voucher: $e");
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
