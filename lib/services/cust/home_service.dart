import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeService {
  final _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchActiveVouchers() async {
    try {
      final voucherData = await _supabase
          .from('vouchers')
          .select()
          .eq('is_active', true)
          .order('created_at', ascending: false);

      final now = DateTime.now();
      List<Map<String, dynamic>> validVouchers = [];

      for (var v in voucherData) {
        final expiresAt = v['expires_at'] != null
            ? DateTime.parse(v['expires_at']).toLocal()
            : DateTime.parse(
                v['created_at'],
              ).toLocal().add(const Duration(days: 30));

        if (now.isAfter(expiresAt)) {
          _supabase
              .from('vouchers')
              .update({'is_active': false})
              .eq('id', v['id']);
        } else {
          validVouchers.add(v);
        }
      }

      return validVouchers;
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

  Future<String?> fetchDefaultAddress() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return null;

      final addressData = await _supabase
          .from('user_addresses')
          .select('address_detail')
          .eq('user_id', user.id)
          .order('is_default', ascending: false)
          .order('created_at', ascending: false)
          .limit(1);

      if (addressData.isNotEmpty) {
        return addressData.first['address_detail'] as String;
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching address: $e');
      return null;
    }
  }
}
