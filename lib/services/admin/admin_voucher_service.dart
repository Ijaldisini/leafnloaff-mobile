import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import '../../models/voucher_model.dart';

class VoucherService {
  final _supabase = Supabase.instance.client;

  Stream<List<Map<String, dynamic>>> streamVouchers() {
    return _supabase
        .from('vouchers')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false);
  }

  Future<List<VoucherModel>> fetchVouchers() async {
    try {
      final response = await _supabase
          .from('vouchers')
          .select()
          .order('created_at', ascending: false);
      return (response as List)
          .map((data) => VoucherModel.fromJson(data))
          .toList();
    } catch (e) {
      debugPrint("Error Fetching Vouchers: $e");
      throw Exception("Gagal memuat voucher");
    }
  }

  Future<String?> uploadImage(File imageFile) async {
    try {
      final fileExt = imageFile.path.split('.').last;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';

      await _supabase.storage
          .from('voucher_images')
          .upload(
            fileName,
            imageFile,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      return _supabase.storage.from('voucher_images').getPublicUrl(fileName);
    } catch (e) {
      debugPrint("Error Uploading Image: $e");
      return null;
    }
  }

  Future<void> createVoucher({
    required String title,
    required int discountPercentage,
    required String termsAndCondition,
    required DateTime expiresAt,
    String? imageUrl,
  }) async {
    try {
      await _supabase.from('vouchers').insert({
        'title': title,
        'discount_percentage': discountPercentage,
        'image_url': imageUrl ?? 'https://placehold.co/334x121',
        'is_active': true,
        'terms_and_condition': termsAndCondition,
        'expires_at': expiresAt.toUtc().toIso8601String(),
      });
    } catch (e) {
      debugPrint("Error Creating Voucher: $e");
      throw Exception(e.toString());
    }
  }

  Future<void> updateVoucher({
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
    } catch (e) {
      debugPrint("Error Updating Voucher: $e");
      throw Exception("Gagal memperbarui voucher");
    }
  }

  Future<void> deactivateVoucher(String id) async {
    try {
      await _supabase
          .from('vouchers')
          .update({'is_active': false})
          .eq('id', id);
    } catch (e) {
      debugPrint("Error Deactivating Voucher: $e");
    }
  }
}
