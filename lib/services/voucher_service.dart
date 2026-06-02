import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/voucher_model.dart';

class VoucherService {
  final _supabase = Supabase.instance.client;

  Future<List<VoucherModel>> fetchVouchers() async {
    final response = await _supabase
        .from('vouchers')
        .select()
        .order('created_at', ascending: false);
    return (response as List)
        .map((data) => VoucherModel.fromJson(data))
        .toList();
  }

  Future<bool> updateVoucher({
    required String id,
    required String title,
    required int discountPercentage,
    required String termsAndCondition,
    required DateTime expiresAt, 
    String? newImageUrl,
  }) async {
    try {
      final Map<String, dynamic> updateData = {
        'title': title,
        'discount_percentage': discountPercentage,
        'terms_and_condition': termsAndCondition,
        'expires_at': expiresAt.toUtc().toIso8601String(),
      };

      if (newImageUrl != null) {
        updateData['image_url'] = newImageUrl;
      }

      await _supabase.from('vouchers').update(updateData).eq('id', id);
      return true;
    } catch (e) {
      return false;
    }
  }
}
