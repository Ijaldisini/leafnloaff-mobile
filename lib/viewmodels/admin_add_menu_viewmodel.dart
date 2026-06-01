import 'dart:io';
import 'package:flutter/material.dart';
import '../services/admin_add_menu_service.dart';
import '../utils/image_picker_util.dart';

class AdminAddMenuViewModel extends ChangeNotifier {
  final AdminAddMenuService _service = AdminAddMenuService();
  final ImagePickerUtil _imagePickerUtil = ImagePickerUtil();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();

  File? _selectedImage;
  File? get selectedImage => _selectedImage;

  String _selectedCategory = 'Makanan';
  String get selectedCategory => _selectedCategory;
  final List<String> categories = ['Makanan', 'Minuman', 'Snack'];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setCategory(String value) {
    _selectedCategory = value;
    notifyListeners();
  }

  Future<void> pickFromGallery() async {
    _selectedImage = await _imagePickerUtil.pickFromGallery();
    notifyListeners();
  }

  Future<void> pickFromCamera() async {
    _selectedImage = await _imagePickerUtil.pickFromCamera();
    notifyListeners();
  }

  void removeSelectedImage() {
    _selectedImage = null;
    notifyListeners();
  }

  Future<bool> saveMenu(BuildContext context) async {
    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        stockController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama, Harga, dan Stok wajib diisi!')),
      );
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      await _service.addMenu(
        name: nameController.text.trim(),
        description: descController.text.trim(),
        price: double.parse(priceController.text.trim()),
        stock: int.parse(stockController.text.trim()),
        category: _selectedCategory,
        imageFile: _selectedImage,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Gagal menyimpan data, periksa koneksi atau format angka!',
          ),
        ),
      );
      return false;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    priceController.dispose();
    stockController.dispose();
    super.dispose();
  }
}
