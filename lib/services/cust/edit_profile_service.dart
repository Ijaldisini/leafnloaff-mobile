import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfileService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<String> uploadProfileImage(File imageFile, String fileName) async {
    try {
      await _supabase.storage
          .from('profile_images')
          .upload(fileName, imageFile);

      return _supabase.storage.from('profile_images').getPublicUrl(fileName);
    } catch (e) {
      throw Exception('Gagal mengupload gambar profil: $e');
    }
  }

  Future<void> updateProfile({
    required String fullName,
    required String username,
    required String? phoneNumber,
    String? profileImageUrl,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception("User tidak sedang login");

      final updateData = {
        'full_name': fullName,
        'username': username,
        'phone_number': phoneNumber,
      };

      if (profileImageUrl != null) {
        updateData['profile_image_url'] = profileImageUrl;
      }

      await _supabase.from('profiles').update(updateData).eq('id', userId);
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
