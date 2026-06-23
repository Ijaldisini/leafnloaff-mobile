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
      throw Exception(
        'Gagal menyimpan foto profil. Pastikan koneksi internet Anda lancar dan coba lagi.',
      );
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
      if (userId == null)
        throw Exception(
          "Sesi Anda telah berakhir, silakan login kembali terlebih dahulu.",
        );

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
      if (e.toString().contains('duplicate key') ||
          e.toString().contains('unique constraint')) {
        throw Exception(
          'Username atau nomor telepon tersebut sudah digunakan. Silakan gunakan yang lain.',
        );
      }
      throw Exception(
        'Data profil gagal diperbarui. Silakan coba beberapa saat lagi.',
      );
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      await _supabase.auth.updateUser(UserAttributes(password: newPassword));
    } catch (e) {
      throw Exception(
        'Gagal mengubah password. Pastikan format password Anda valid dan koneksi stabil.',
      );
    }
  }
}
