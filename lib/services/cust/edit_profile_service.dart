import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfileService {
  final _supabase = Supabase.instance.client;

  Future<void> updateProfile({
    required String userId,
    required String fullName,
    required String username,
    required String? phoneNumber,
  }) async {
    try {
      await _supabase
          .from('profiles')
          .update({
            'full_name': fullName,
            'username': username,
            'phone_number': phoneNumber,
          })
          .eq('id', userId);
    } catch (e) {
      throw Exception('Gagal mengupdate profil: $e');
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      await _supabase.auth.updateUser(UserAttributes(password: newPassword));
    } catch (e) {
      throw Exception('Gagal mengupdate password: $e');
    }
  }
}
