import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

class AdminMenuManagementService {
  final _supabase = Supabase.instance.client;

  Future<List<dynamic>> getAllMenus() async {
    try {
      final response = await _supabase
          .from('menus')
          .select()
          .order('name', ascending: true);

      return response;
    } catch (e) {
      debugPrint("Error Fetching Menus: $e");
      throw Exception("Gagal mengambil data menu: $e");
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
