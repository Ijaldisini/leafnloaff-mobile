import 'package:flutter/material.dart';
import 'package:leafnloaff/viewmodels/admin/admin_order_review_viewmodel.dart';
import 'package:leafnloaff/models/order_review_model.dart';

class AdminOrderReviewView extends StatefulWidget {
  final String orderId;

  const AdminOrderReviewView({super.key, required this.orderId});

  @override
  State<AdminOrderReviewView> createState() => _AdminOrderReviewViewState();
}

class _AdminOrderReviewViewState extends State<AdminOrderReviewView> {
  final AdminOrderReviewViewModel _viewModel = AdminOrderReviewViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.fetchReviews(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFD699AB), Color(0xFF3D5A4A)],
            stops: [0.0, 0.7],
          ),
        ),
        child: SafeArea(
          child: ListenableBuilder(
            listenable: _viewModel,
            builder: (context, child) {
              if (_viewModel.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 20,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Order Review',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w800,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(2, 2),
                                      blurRadius: 4,
                                      color: Color(0x3F000000),
                                    ),
                                  ],
                                ),
                              ),
                              Opacity(
                                opacity: 0.80,
                                child: Text(
                                  'Order ID: ${widget.orderId.length >= 8 ? widget.orderId.substring(0, 8).toUpperCase() : widget.orderId.toUpperCase()}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                  ),
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
                    child: _viewModel.reviews.isEmpty
                        ? const Center(
                            child: Text(
                              "Belum ada review untuk order ini.",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(25, 10, 25, 40),
                            physics: const BouncingScrollPhysics(),
                            itemCount: _viewModel.reviews.length,
                            itemBuilder: (context, index) {
                              final review = _viewModel.reviews[index];
                              return _buildReviewCard(review);
                            },
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildReviewCard(OrderReviewModel review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFDFDFD),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 115,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0xFF73986F), width: 1.2),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14),
                    bottomLeft: Radius.circular(14),
                  ),
                  child: SizedBox(
                    width: 100,
                    height: double.infinity,
                    child:
                        review.itemImageUrl != null &&
                            review.itemImageUrl!.isNotEmpty
                        ? Image.network(review.itemImageUrl!, fit: BoxFit.cover)
                        : Container(color: Colors.grey.shade300),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          review.itemName,
                          style: const TextStyle(
                            color: Color(0xFF2D4839),
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w800,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Notes: ${review.notes}',
                          style: const TextStyle(
                            color: Color(0xFF51725F),
                            fontSize: 8,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Qty: ${review.qty}',
                          style: const TextStyle(
                            color: Color(0xFF51725F),
                            fontSize: 9,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          _viewModel.formatCurrency(review.price),
                          style: const TextStyle(
                            color: Color(0xFF2D4839),
                            fontSize: 15,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Center(
            child: Column(
              children: [
                const Text(
                  'Rating',
                  style: TextStyle(
                    color: Color(0xFF2D4839),
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (index) {
                    return Icon(
                      index < review.rating ? Icons.star : Icons.star_border,
                      color: const Color(0xFFFFD233),
                      size: 35,
                    );
                  }),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Customer Review',
            style: TextStyle(
              color: Color(0xFF2D4839),
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF3DEE3),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFFCA748D),
                width: 1,
              ),
            ),
            child: Text(
              review.reviewText.isEmpty
                  ? "Tidak ada ulasan tertulis."
                  : review.reviewText,
              style: const TextStyle(
                color: Color(0xFF2D4839),
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          if (review.reviewImages.isNotEmpty) ...[
            const SizedBox(height: 15),
            Wrap(
              spacing: 10,
              runSpacing:
                  10,
              children: review.reviewImages.map((imageUrl) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageUrl,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 70,
                      height: 70,
                      color: Colors.grey.shade300,
                      child: const Icon(
                        Icons.broken_image,
                        color: Colors.grey,
                        size: 24,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
