import 'package:supabase_flutter/supabase_flutter.dart';

class HomeService {
  final _supabase = Supabase.instance.client;

  Future<Map<String, dynamic>?> fetchActiveVoucher() async {
    try {
      final voucherData = await _supabase
          .from('vouchers')
          .select()
          .eq('is_active', true)
          .order('created_at', ascending: false)
          .limit(1);

      if (voucherData.isNotEmpty) {
        return voucherData.first;
      }
      return null;
    } catch (e) {
      throw Exception('Gagal mengambil data voucher: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchActiveMenus() async {
    try {
      final menuData = await _supabase
          .from('menus')
          .select()
          .eq('is_active', true)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(menuData);
    } catch (e) {
      throw Exception('Gagal mengambil data menu: $e');
    }
  }
}
