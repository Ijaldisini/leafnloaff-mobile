import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> register(UserModel user, String password) async {
    try {
      final response = await _supabase.auth.signUp(
        email: user.email,
        password: password,
      );

      if (response.user != null) {
        final completedUser = user.copyWith(id: response.user!.id);
        await _supabase.from('profiles').insert(completedUser.toMap());
      }
    } catch (e) {
      throw Exception('Gagal register: ${e.toString()}');
    }
  }

  Future<void> verifyEmailOtp(String email, String token) async {
    try {
      debugPrint("Memverifikasi: Email=$email, Token=$token");

      final AuthResponse res = await _supabase.auth.verifyOTP(
        email: email,
        token: token,
        type: OtpType.email,
      );

      if (res.session == null) {
        throw Exception('Sesi tidak terbentuk. Kode mungkin tidak valid.');
      }
    } on AuthException catch (e) {
      debugPrint("Auth Error: ${e.message}");
      throw Exception(e.message);
    } catch (e) {
      debugPrint("General Error: $e");
      throw Exception('Verifikasi gagal: ${e.toString()}');
    }
  }

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        final profileData = await _supabase
            .from('profiles')
            .select()
            .eq('id', response.user!.id)
            .single();

        final userModel = UserModel.fromMap(profileData);

        if (!userModel.isActive) {
          await _supabase.auth.signOut();
          throw Exception('Akun telah terhapus');
        }

        return userModel;
      }

      throw Exception(
        'Akun tidak ditemukan. Silakan periksa kembali email Anda.',
      );
    } on AuthException catch (e) {
      if (e.message.contains('Invalid login credentials')) {
        throw Exception('Email atau password yang Anda masukkan salah.');
      } else if (e.message.contains('Email not confirmed')) {
        throw Exception(
          'Email Anda belum diverifikasi. Silakan cek kotak masuk email Anda.',
        );
      }
      throw Exception(
        'Gagal masuk. Silakan periksa koneksi internet Anda dan coba lagi.',
      );
    } catch (e) {
      if (e.toString().contains('Akun telah terhapus')) {
        throw Exception('Akun telah terhapus');
      }
      throw Exception('Sistem sedang sibuk. Silakan coba beberapa saat lagi.');
    }
  }

  Future<UserModel?> getCurrentUser() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    try {
      final profileData = await _supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      return UserModel.fromMap(profileData);
    } catch (e) {
      return null;
    }
  }
}
