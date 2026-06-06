import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  String _generateTOTPSecret() {
    const length = 16;
    const base32Chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
    final random = Random.secure();
    return List.generate(length, (index) {
      return base32Chars[random.nextInt(base32Chars.length)];
    }).join();
  }

  Future<String> register(UserModel user, String password) async {
    try {
      final otpSecret = _generateTOTPSecret();

      final response = await _supabase.auth.signUp(
        email: user.email,
        password: password,
      );

      if (response.user != null) {
        final completedUser = UserModel(
          id: response.user!.id,
          fullName: user.fullName,
          username: user.username,
          email: user.email,
          otpSecret: otpSecret,
        );

        await _supabase.from('profiles').insert(completedUser.toMap());
      }

      return otpSecret;
    } catch (e) {
      throw Exception('Gagal register: ${e.toString()}');
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

        return UserModel.fromMap(profileData);
      }

      throw Exception('User tidak ditemukan');
    } catch (e) {
      throw Exception('Gagal login: ${e.toString()}');
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
