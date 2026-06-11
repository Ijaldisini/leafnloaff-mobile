import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/voucher_model.dart';

class CustVoucherService {
  final _supabase = Supabase.instance.client;

  Future<List<VoucherModel>> fetchActiveVouchers() async {
    final now = DateTime.now().toUtc().toIso8601String();

    final response = await _supabase
        .from('vouchers')
        .select()
        .eq('is_active', true)
        .or('expires_at.is.null,expires_at.gte.$now')
        .order('created_at', ascending: false);

    return (response as List)
        .map((data) => VoucherModel.fromJson(data))
        .toList();
  }
}
