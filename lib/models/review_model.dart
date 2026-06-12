import 'dart:io';

class ReviewModel {
  final String id;
  final String orderId;
  final String menuId;
  final String userId;
  final int rating;
  final String? comment;
  final String? imageUrl;
  final DateTime createdAt;

  ReviewModel({
    required this.id,
    required this.orderId,
    required this.menuId,
    required this.userId,
    required this.rating,
    this.comment,
    this.imageUrl,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'].toString(),
      orderId: json['order_id'].toString(),
      menuId: json['menu_id'].toString(),
      userId: json['user_id'].toString(),
      rating: json['rating'] ?? 0,
      comment: json['comment'],
      imageUrl: json['image_url'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class ReviewSubmitModel {
  final String menuId;
  final int rating;
  final String comment;
  final List<File> mediaFiles;

  ReviewSubmitModel({
    required this.menuId,
    required this.rating,
    required this.comment,
    this.mediaFiles = const [],
  });
}