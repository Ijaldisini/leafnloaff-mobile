import 'dart:io';
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
    if (userId == null)
      throw Exception('User not logged in. Sesi telah habis.');

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

  Future<List<ReviewModel>> fetchReviewsByOrder(String orderId) async {
    try {
      final response = await _supabase
          .from('reviews')
          .select('*')
          .eq('order_id', orderId);

      return (response as List<dynamic>)
          .map((json) => ReviewModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil ulasan: $e');
    }
  }
}
