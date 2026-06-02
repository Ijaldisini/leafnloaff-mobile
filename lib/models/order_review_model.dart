class OrderReviewModel {
  final String itemName;
  final String? itemImageUrl;
  final String notes;
  final int qty;
  final double price;
  final int rating;
  final String reviewText;
  final List<String> reviewImages;

  OrderReviewModel({
    required this.itemName,
    this.itemImageUrl,
    required this.notes,
    required this.qty,
    required this.price,
    required this.rating,
    required this.reviewText,
    required this.reviewImages,
  });
}
