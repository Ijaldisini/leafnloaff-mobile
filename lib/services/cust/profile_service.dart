import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> logout() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw Exception('Gagal melakukan logout: $e');
    }
  }

  Future<void> deleteAccount() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId != null) {
        await _supabase.from('profiles').update({
          'is_active': false,
        }).eq('id', userId);

        await _supabase.auth.signOut();
      }
    } catch (e) {
      throw Exception('Gagal menghapus akun: $e');
    }
  }
}
