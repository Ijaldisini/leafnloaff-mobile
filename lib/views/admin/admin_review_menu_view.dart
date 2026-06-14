import 'package:flutter/material.dart';
import '../../models/menu_model.dart';
import '../../models/review_model.dart';
import '../../viewmodels/admin/admin_review_menu_viewmodel.dart';

class AdminReviewMenuView extends StatefulWidget {
  final MenuModel menu;

  const AdminReviewMenuView({super.key, required this.menu});

  @override
  State<AdminReviewMenuView> createState() => _AdminReviewMenuViewState();
}

class _AdminReviewMenuViewState extends State<AdminReviewMenuView> {
  final AdminReviewMenuViewModel _viewModel = AdminReviewMenuViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.fetchReviewsDetail(widget.menu.id);
  }

  String formatCurrency(double price) {
    return 'Rp. ${price.toInt()}';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF3D5A4A),
      body: Stack(
        children: [
          Positioned(
            left: -17,
            top: -30,
            child: Container(
              width: screenWidth + 34,
              height: 289,
              decoration: const BoxDecoration(color: Color(0xFFD699AB)),
            ),
          ),
          Positioned(
            left: -17,
            top: 147,
            child: Container(
              width: screenWidth + 34,
              height: 114,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x003D5A4A), Color(0xFF3D5A4A)],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.menu.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFFFDFDFD),
                            fontSize: 22,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w800,
                            shadows: [
                              Shadow(
                                offset: const Offset(2, 2),
                                blurRadius: 4,
                                color: Colors.black.withOpacity(0.25),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  width: double.infinity,
                  height: 265,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child:
                              widget.menu.imageUrl != null &&
                                  widget.menu.imageUrl!.isNotEmpty
                              ? Image.network(
                                  widget.menu.imageUrl!,
                                  fit: BoxFit.cover,
                                )
                              : Container(color: Colors.grey.shade300),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 105,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Color(0x00CA748D), Color(0xFFCA748D)],
                              ),
                            ),
                            padding: const EdgeInsets.only(
                              left: 20,
                              bottom: 20,
                            ),
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              formatCurrency(widget.menu.price),
                              style: const TextStyle(
                                color: Color(0xFFFBFBFB),
                                fontSize: 20,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFDFDFD),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x3F000000),
                          blurRadius: 4,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListenableBuilder(
                      listenable: _viewModel,
                      builder: (context, child) {
                        if (_viewModel.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFFCA748D),
                            ),
                          );
                        }

                        if (_viewModel.errorMessage != null) {
                          return Center(
                            child: Text(
                              _viewModel.errorMessage!,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.redAccent,
                              ),
                            ),
                          );
                        }

                        if (_viewModel.reviews.isEmpty) {
                          return const Center(
                            child: Text(
                              "Belum ada review untuk menu ini.",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.grey,
                              ),
                            ),
                          );
                        }

                        return ListView.separated(
                          padding: const EdgeInsets.all(20),
                          physics: const BouncingScrollPhysics(),
                          itemCount: _viewModel.reviews.length,
                          separatorBuilder: (context, index) => const Divider(
                            height: 30,
                            color: Color(0xFFEFEDED),
                          ),
                          itemBuilder: (context, index) {
                            return _buildReviewItem(_viewModel.reviews[index]);
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(ReviewModel review) {
    final fullName = review.userName ?? 'Pengguna Anonim';
    final comment = review.comment ?? '';
    final imageUrl = review.imageUrl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                color: Color(0xFFEFEDED),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  fullName[0].toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFF2D4839),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        fullName,
                        style: const TextStyle(
                          color: Color(0xFF2D4839),
                          fontSize: 11,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < review.rating
                                ? Icons.star
                                : Icons.star_border,
                            size: 12,
                            color: const Color(0xFFCA748D),
                          );
                        }),
                      ),
                    ],
                  ),
                  Text(
                    _viewModel.formatDate(review.createdAt),
                    style: TextStyle(
                      color: const Color(0xFF426E55).withOpacity(0.6),
                      fontSize: 9,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (comment.isNotEmpty) ...[
          Text(
            comment,
            style: const TextStyle(
              color: Color(0xFF51725F),
              fontSize: 12,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
        if (imageUrl != null && imageUrl.isNotEmpty) ...[
          const SizedBox(height: 10),
          ClipRRect(
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
                child: const Icon(Icons.broken_image, color: Colors.grey),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
