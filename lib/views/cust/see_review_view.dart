import 'package:flutter/material.dart';
import '../../viewmodels/cust/review_order_viewmodel.dart';
import '../../models/review_model.dart';

class SeeReviewView extends StatefulWidget {
  final String orderId;
  final List<dynamic> orderItems;

  const SeeReviewView({
    super.key,
    required this.orderId,
    required this.orderItems,
  });

  @override
  State<SeeReviewView> createState() => _SeeReviewViewState();
}

class _SeeReviewViewState extends State<SeeReviewView> {
  final ReviewOrderViewModel _viewModel = ReviewOrderViewModel();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.fetchReviewsForOrder(widget.orderId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3D5A4A),
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: 220,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFD699AB), Color(0xFFD699AB)],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 15.0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            const Text(
                              'Order Review',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w800,
                                shadows: [
                                  Shadow(
                                    offset: Offset(1, 1),
                                    blurRadius: 2,
                                    color: Colors.black26,
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              widget.orderId.substring(0, 8).toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                Expanded(
                  child: ListenableBuilder(
                    listenable: _viewModel,
                    builder: (context, child) {
                      if (_viewModel.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      }

                      if (_viewModel.errorMessage != null) {
                        return Center(
                          child: Text(
                            _viewModel.errorMessage!,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        physics: const BouncingScrollPhysics(),
                        itemCount: widget.orderItems.length,
                        itemBuilder: (context, index) {
                          final item = widget.orderItems[index];
                          final menu = item['menus'] ?? {};
                          final menuId = item['menu_id'].toString();

                          final reviewDataList = _viewModel.orderReviews
                              .where((r) => r.menuId == menuId)
                              .toList();

                          final ReviewModel? reviewData =
                              reviewDataList.isNotEmpty
                              ? reviewDataList.first
                              : null;

                          return _buildReviewedCard(menu, item, reviewData);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewedCard(
    Map<String, dynamic> menu,
    dynamic item,
    ReviewModel? reviewData,
  ) {
    int rating = reviewData?.rating ?? 0;
    String comment = reviewData?.comment ?? 'Belum ada ulasan';
    String? imageUrl = reviewData?.imageUrl;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF426E55), width: 1.5),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    menu['image_url'] ?? 'https://via.placeholder.com/80',
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 70,
                      height: 70,
                      color: Colors.grey[300],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        menu['name'] ?? 'Item\'s Name',
                        style: const TextStyle(
                          color: Color(0xFF2D4839),
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Notes: ${item['notes'] ?? '-'} \nQty: ${item['quantity'] ?? 1}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 10,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Rp. ${item['price_at_time'] ?? menu['price'] ?? 0}',
                        style: const TextStyle(
                          color: Color(0xFF2D4839),
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'Rating',
              style: TextStyle(
                color: Color(0xFF2D4839),
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (starIndex) {
              return Icon(
                starIndex < rating ? Icons.star : Icons.star_border,
                color: const Color(0xFFF6D060),
                size: 35,
              );
            }),
          ),
          const SizedBox(height: 15),
          const Text(
            'Customer Review',
            style: TextStyle(
              color: Color(0xFF2D4839),
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEED5DB),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFCA748D)),
            ),
            child: Text(
              comment,
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'Poppins',
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 15),
          if (imageUrl != null && imageUrl.isNotEmpty)
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: imageUrl.split(',').map((url) {
                bool isVideo = url.contains('.mp4') || url.contains('.mov');

                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: isVideo
                      ? Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey[800],
                          child: const Icon(
                            Icons.videocam,
                            color: Colors.white,
                          ),
                        )
                      : Image.network(
                          url,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey,
                              ),
                        ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
