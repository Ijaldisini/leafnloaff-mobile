import 'package:supabase_flutter/supabase_flutter.dart';

class AddressService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchUserAddresses() async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User belum login.');

    final response = await _supabase
        .from('user_addresses')
        .select('*')
        .eq('user_id', user.id)
        .order('is_default', ascending: false)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> saveNewAddress(Map<String, dynamic> addressData) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User belum login.');

    addressData['user_id'] = user.id;

    final existing = await fetchUserAddresses();
    if (existing.isEmpty) {
      addressData['is_default'] = true;
    }

    await _supabase.from('user_addresses').insert(addressData);
  }

  Future<void> updateAddress(
    String id,
    Map<String, dynamic> addressData,
  ) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User belum login.');

    await _supabase
        .from('user_addresses')
        .update(addressData)
        .eq('id', id)
        .eq('user_id', user.id);
  }

  Future<void> deleteAddress(String id) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User belum login.');

    await _supabase
        .from('user_addresses')
        .delete()
        .eq('id', id)
        .eq('user_id', user.id);
  }
}
