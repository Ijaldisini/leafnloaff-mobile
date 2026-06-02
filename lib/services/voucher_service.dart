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
}
