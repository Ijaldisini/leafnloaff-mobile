import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/review_model.dart';

class AdminReviewService {
  final _supabase = Supabase.instance.client;

  Future<List<dynamic>> getMenuRatings(String menuId) async {
    try {
      return await _supabase
          .from('reviews')
          .select('rating')
          .eq('menu_id', menuId);
    } catch (e) {
      debugPrint("Error fetching ratings: $e");
      throw Exception("Gagal mengambil rating menu.");
    }
  }

  Future<List<ReviewModel>> getMenuReviewsDetail(String menuId) async {
    try {
      final response = await _supabase
          .from('reviews')
          .select('*, profiles(full_name)')
          .eq('menu_id', menuId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((data) => ReviewModel.fromJson(data))
          .toList();
    } catch (e) {
      debugPrint("Error fetching review details: $e");
      throw Exception("Gagal mengambil detail ulasan.");
    }
  }
}
