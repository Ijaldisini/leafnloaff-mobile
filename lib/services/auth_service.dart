import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  Future<String> register(
    String email,
    String password,
    String fullName,
    String username,
  ) async {
    try {
      final otpSecret = _generateTOTPSecret();

      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        await _supabase.from('profiles').insert({
          'id': response.user!.id,
          'full_name': fullName,
          'username': username,
          'email': email,
          'otp_secret': otpSecret,
        });
      }

      return otpSecret;
    } catch (e) {
      throw Exception('Gagal register: ${e.toString()}');
    }
  }

  Future<AuthResponse> login(String email, String password) async {
    try {
      return await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Gagal login: ${e.toString()}');
    }
  }
}
