import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

class AdminMenuService {
  final _supabase = Supabase.instance.client;

  Stream<List<Map<String, dynamic>>> streamAllMenus() {
    return _supabase
        .from('menus')
        .stream(primaryKey: ['id'])
        .order('name', ascending: true);
  }

  Future<List<dynamic>> getAllMenus() async {
    try {
      return await _supabase
          .from('menus')
          .select()
          .order('name', ascending: true);
    } catch (e) {
      debugPrint("Error Fetching Menus: $e");
      throw Exception("Gagal mengambil data menu: $e");
    }
  }

  Future<void> addMenu({
    required String name,
    required String description,
    required double price,
    required int stock,
    required String category,
    File? imageFile,
  }) async {
    try {
      String? finalImageUrl;

      if (imageFile != null) {
        final extension = imageFile.path.split('.').last;
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${name.replaceAll(' ', '_')}.$extension';

        await _supabase.storage.from('menu_images').upload(fileName, imageFile);
        finalImageUrl = _supabase.storage
            .from('menu_images')
            .getPublicUrl(fileName);
      }

      await _supabase.from('menus').insert({
        'name': name,
        'description': description,
        'price': price,
        'stock': stock,
        'category': category,
        'image_url': finalImageUrl,
        'is_active': true,
      });
    } catch (e) {
      debugPrint("Error Inserting Menu: $e");
      throw Exception("Gagal menyimpan menu: $e");
    }
  }

  Future<void> updateMenu({
    required String id,
    required String name,
    required String description,
    required double price,
    required int stock,
    required String category,
    File? newImageFile,
    String? existingImageUrl,
  }) async {
    try {
      String? finalImageUrl = existingImageUrl;

      if (newImageFile != null) {
        final extension = newImageFile.path.split('.').last;
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${name.replaceAll(' ', '_')}.$extension';

        await _supabase.storage
            .from('menu_images')
            .upload(fileName, newImageFile);
        finalImageUrl = _supabase.storage
            .from('menu_images')
            .getPublicUrl(fileName);
      }

      await _supabase
          .from('menus')
          .update({
            'name': name,
            'description': description,
            'price': price,
            'stock': stock,
            'category': category,
            'image_url': finalImageUrl,
          })
          .eq('id', id);
    } catch (e) {
      debugPrint("Error Updating Menu: $e");
      throw Exception("Gagal mengubah menu: $e");
    }
  }

  Future<void> deleteMenu(String id) async {
    try {
      await _supabase.from('menus').update({'is_active': false}).eq('id', id);
    } catch (e) {
      debugPrint("Error Deleting/Deactivating Menu: $e");
      throw Exception("Gagal menonaktifkan menu: $e");
    }
  }
}
