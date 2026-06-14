import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

class AdminDashboardService {
  final _supabase = Supabase.instance.client;

  Future<List<dynamic>> getOrdersToday(
    String startOfDay,
    String endOfDay,
  ) async {
    try {
      return await _supabase
          .from('orders')
          .select('id, total_price, status, created_at')
          .gte('created_at', startOfDay)
          .lte('created_at', endOfDay);
    } catch (e) {
      debugPrint("Service Error (getOrdersToday): $e");
      throw Exception("Gagal mengambil data order hari ini.");
    }
  }

  Future<List<dynamic>> getNewCustomersThisWeek(String startOfWeek) async {
    try {
      return await _supabase
          .from('profiles')
          .select('id')
          .eq('role', 'customer')
          .gte('created_at', startOfWeek);
    } catch (e) {
      debugPrint("Service Error (getNewCustomers): $e");
      throw Exception("Gagal mengambil data pelanggan baru.");
    }
  }

  Future<List<dynamic>> getOrderItemsToday(
    String startOfDay,
    String endOfDay,
  ) async {
    try {
      return await _supabase
          .from('order_items')
          .select('menu_id, quantity, menus(name)')
          .gte('created_at', startOfDay)
          .lte('created_at', endOfDay);
    } catch (e) {
      debugPrint("Service Error (getOrderItemsToday): $e");
      throw Exception("Gagal mengambil detail item terjual hari ini.");
    }
  }

  Future<List<dynamic>> getRecentOrders() async {
    try {
      return await _supabase
          .from('orders')
          .select('''
            id,
            status,
            created_at,
            total_price,
            notes,
            order_items (
              quantity,
              menus (name)
            )
          ''')
          .order('created_at', ascending: false)
          .limit(3);
    } catch (e) {
      debugPrint("Service Error (getRecentOrders): $e");
      throw Exception("Gagal mengambil pesanan terbaru.");
    }
  }

  Future<void> logout() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      debugPrint("Service Error (logout): $e");
      throw Exception("Gagal melakukan proses logout.");
    }
  }
}
