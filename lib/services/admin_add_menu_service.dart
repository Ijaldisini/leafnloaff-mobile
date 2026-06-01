import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

class AdminAddMenuService {
  final _supabase = Supabase.instance.client;

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
}
