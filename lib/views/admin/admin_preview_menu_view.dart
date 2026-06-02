import 'package:flutter/material.dart';
import '../../models/menu_model.dart';
import '../../viewmodels/admin_preview_menu_viewmodel.dart';
import 'admin_edit_menu_view.dart';
import 'admin_review_menu_view.dart';

class AdminPreviewMenuView extends StatefulWidget {
  final MenuModel menu;

  const AdminPreviewMenuView({super.key, required this.menu});

  @override
  State<AdminPreviewMenuView> createState() => _AdminPreviewMenuViewState();
}

class _AdminPreviewMenuViewState extends State<AdminPreviewMenuView> {
  final AdminPreviewMenuViewModel _viewModel = AdminPreviewMenuViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.fetchReviews(widget.menu.id);
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
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 120),
                  physics: const BouncingScrollPhysics(),
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
                                    : Container(
                                        color: Colors.grey.shade300,
                                        child: const Icon(
                                          Icons.fastfood,
                                          size: 50,
                                          color: Colors.grey,
                                        ),
                                      ),
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
                                      colors: [
                                        Color(0x00CA748D),
                                        Color(0xFFCA748D),
                                      ],
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

                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 25),
                        padding: const EdgeInsets.all(20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDFDFD),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x3F000000),
                              blurRadius: 4,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Description',
                              style: TextStyle(
                                color: Color(0xFF2D4839),
                                fontSize: 18,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              widget.menu.description,
                              style: const TextStyle(
                                color: Color(0xFF51725F),
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(23),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Text(
                                    widget.menu.category,
                                    style: const TextStyle(
                                      color: Color(0xFF333333),
                                      fontSize: 10,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 25),

                            ListenableBuilder(
                              listenable: _viewModel,
                              builder: (context, child) {
                                if (_viewModel.isLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFFCA748D),
                                    ),
                                  );
                                }

                                return Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xFFCA748D),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          children: [
                                            const Text(
                                              'Rating',
                                              style: TextStyle(
                                                color: Color(0xFFCA748D),
                                                fontSize: 16,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                            Text(
                                              _viewModel.averageRating
                                                  .toStringAsFixed(1),
                                              style: const TextStyle(
                                                color: Color(0xFFCA748D),
                                                fontSize: 32,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Text(
                                              'Based on ${_viewModel.totalReviews} Reviews',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                color: Color(0xFFD699AB),
                                                fontSize: 8,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 5),

                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        AdminReviewMenuView(
                                                          menu: widget.menu,
                                                        ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 2,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                    0xFFD699AB,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                child: const Text(
                                                  'See More',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 9,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          children: List.generate(5, (index) {
                                            final stars = 5 - index;
                                            final reviewCountForStar =
                                                _viewModel
                                                    .ratingDistribution[stars] ??
                                                0;
                                            final widthPercentage =
                                                _viewModel.totalReviews == 0
                                                ? 0.0
                                                : (reviewCountForStar /
                                                      _viewModel.totalReviews);

                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 4.0,
                                              ),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    '$stars',
                                                    style: const TextStyle(
                                                      color: Color(0xFFCA748D),
                                                      fontSize: 12,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: Container(
                                                      height: 5,
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                          0xFFEED5DB,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              5,
                                                            ),
                                                      ),
                                                      child: FractionallySizedBox(
                                                        widthFactor:
                                                            widthPercentage,
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            color: const Color(
                                                              0xFFCA748D,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  5,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 98,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFD699AB), Color(0xFFCA748D)],
                      ),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x3F000000),
                          blurRadius: 10,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AdminEditMenuView(menu: widget.menu),
                            ),
                          );
                          if (result == true) {
                            if (context.mounted) Navigator.pop(context, true);
                          }
                        },
                        child: Container(
                          width: 137,
                          height: 32,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFF426E55),
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x3F000000),
                                blurRadius: 4,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Text(
                            'Edit Menu',
                            style: TextStyle(
                              color: Color(0xFFFBFBFB),
                              fontSize: 18,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
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
}
