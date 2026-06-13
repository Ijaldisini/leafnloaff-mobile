import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/review_model.dart';

class ReviewOrderService {
  final _supabase = Supabase.instance.client;

  String? getCurrentUserId() {
    return _supabase.auth.currentUser?.id;
  }

  Future<String?> uploadReviewMedia(File mediaFile) async {
    try {
      final fileExt = mediaFile.path.split('.').last;
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${getCurrentUserId()}.$fileExt';

      await _supabase.storage.from('review_images').upload(fileName, mediaFile);
      return _supabase.storage.from('review_images').getPublicUrl(fileName);
    } catch (e) {
      throw Exception('Gagal mengupload media: $e');
    }
  }

  Future<void> submitReview(
    String orderId,
    ReviewSubmitModel reviewData,
  ) async {
    final userId = getCurrentUserId();
    if (userId == null) {
      throw Exception('User not logged in. Sesi telah habis.');
    }

    List<String> uploadedUrls = [];

    for (var file in reviewData.mediaFiles) {
      String? url = await uploadReviewMedia(file);
      if (url != null) {
        uploadedUrls.add(url);
      }
    }

    String? finalImageUrl = uploadedUrls.isNotEmpty
        ? uploadedUrls.join(',')
        : null;

    await _supabase.from('reviews').insert({
      'order_id': orderId,
      'menu_id': reviewData.menuId,
      'user_id': userId,
      'rating': reviewData.rating,
      'comment': reviewData.comment,
      if (finalImageUrl != null) 'image_url': finalImageUrl,
    });
  }

  Future<void> sendReviewNotificationToAdmin(String orderId) async {
    try {
      await _supabase.from('notifications').insert({
        'user_id': null,
        'order_id': orderId,
        'title': 'Ulasan Baru!',
        'message': 'Customer baru saja memberikan ulasan untuk pesanannya.',
      });
    } catch (e) {
      debugPrint('Gagal mengirim notif ulasan ke admin: $e');
    }
  }

  Future<List<ReviewModel>> fetchReviewsByOrder(String orderId) async {
    try {
      final response = await _supabase
          .from('reviews')
          .select('*, profiles:user_id(full_name)')
          .eq('order_id', orderId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((data) => ReviewModel.fromJson(data))
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil ulasan: $e');
    }
  }
}
