import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app_navigator.dart';

class ReviewMenuView extends StatefulWidget {
  final String productId;
  final String productName;
  final String productImage;
  final int price;
  final double rating;
  final int totalReviews;

  const ReviewMenuView({
    super.key,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.rating,
    required this.totalReviews,
  });

  @override
  State<ReviewMenuView> createState() => _ReviewMenuViewState();
}

class _ReviewMenuViewState extends State<ReviewMenuView> {
  bool _isAddingToCart = false;
  List<Map<String, dynamic>> _reviews = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchReviews();
  }

  Future<void> _fetchReviews() async {
    try {
      final response = await Supabase.instance.client
          .from('reviews')
          .select('''
            *,
            profiles:user_id (
              full_name
            )
          ''')
          .eq('product_id', widget.productId)
          .order('created_at', ascending: false);

      if (mounted) {
        setState(() {
          _reviews = List<Map<String, dynamic>>.from(response);
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching reviews: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String get _formattedPrice {
    return 'Rp. ${widget.price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    )}';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
              decoration: const BoxDecoration(
                color: Color(0xFFD699AB),
              ),
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
                  begin: Alignment(0.50, -0.00),
                  end: Alignment(0.50, 1.00),
                  colors: [Color(0x003D5A4A), Color(0xFF3D5A4A)],
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => AppNavigator.back(context),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.25),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.4),
                                width: 1,
                              ),
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.productName,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w800,
                              height: 1.10,
                              shadows: [
                                Shadow(
                                  offset: Offset(2, 2),
                                  blurRadius: 4,
                                  color: Colors.black26,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 44),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // 🖼️ PRODUCT IMAGE CONTAINER
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 26),
                    child: Stack(
                      children: [
                        // Image dengan rounded corners
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            height: 265,
                            width: double.infinity,
                            color: const Color(0xFF426E55),
                            child: widget.productImage.isNotEmpty
                                ? Image.network(
                                    widget.productImage,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.restaurant,
                                              size: 64,
                                              color: Colors.white54,
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              'Product Image',
                                              style: TextStyle(
                                                color: Colors.white54,
                                                fontSize: 14,
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  )
                                : const Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.restaurant,
                                          size: 64,
                                          color: Colors.white54,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Product Image',
                                          style: TextStyle(
                                            color: Colors.white54,
                                            fontSize: 14,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ),

                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            height: 105,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment(0.50, -0.00),
                                end: Alignment(0.50, 1.00),
                                colors: [Color(0x00CA748D), Color(0xFFCA748D)],
                              ),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16, bottom: 14),
                                child: Text(
                                  _formattedPrice,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w800,
                                    height: 1.10,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(1, 1),
                                        blurRadius: 3,
                                        color: Colors.black26,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  _isLoading
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32),
                            child: CircularProgressIndicator(
                              color: Color(0xFFCA748D),
                            ),
                          ),
                        )
                      : _reviews.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 26),
                              child: Container(
                                padding: const EdgeInsets.all(32),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                  ),
                                ),
                                child: const Center(
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.rate_review_outlined,
                                        size: 48,
                                        color: Colors.white54,
                                      ),
                                      SizedBox(height: 12),
                                      Text(
                                        'Belum ada review untuk produk ini',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontFamily: 'Poppins',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 26),
                              child: ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _reviews.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final review = _reviews[index];
                                  final profile = review['profiles'] as Map<String, dynamic>?;
                                  
                                  return _buildReviewCard(
                                    userName: profile?['full_name'] ?? 'Anonymous',
                                    date: review['created_at'] ?? '',
                                    rating: (review['rating'] ?? 5.0).toDouble(),
                                    comment: review['comment'] ?? '',
                                    images: review['images'] != null
                                        ? List<String>.from(review['images'])
                                        : [],
                                  );
                                },
                              ),
                            ),

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),

          // 🛒 ADD TO CART BUTTON 
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: double.infinity,
              height: 98,
              decoration: const ShapeDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.50, 0.00),
                  end: Alignment(0.50, 1.00),
                  colors: [Color(0xFFD699AB), Color(0xFFCA748D)],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Center(
                child: GestureDetector(
                  onTap: _isAddingToCart ? null : _addToCart,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: _isAddingToCart ? 48 : 137,
                    height: 32,
                    decoration: ShapeDecoration(
                      color: const Color(0xFF426E55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      shadows: [
                        BoxShadow(
                          color: const Color(0x3F000000),
                          blurRadius: 4,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: _isAddingToCart
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Center(
                            child: Text(
                              'Add to Cart',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.22,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w800,
                                height: 1.10,
                                shadows: [
                                  Shadow(
                                    offset: Offset(2, 2),
                                    blurRadius: 2,
                                    color: Colors.black26,
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard({
    required String userName,
    required String date,
    required double rating,
    required String comment,
    required List<String> images,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFEDED),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  color: Color(0xFFCA748D),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        color: Color(0xFF2D4839),
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatDate(date),
                      style: TextStyle(
                        color: const Color(0xFF426E55).withOpacity(0.6),
                        fontSize: 11,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // Star rating
              Row(
                children: List.generate(5, (i) {
                  return Icon(
                    i < rating.round()
                        ? Icons.star
                        : Icons.star_border,
                    size: 14,
                    color: const Color(0xFFFFC107),
                  );
                }),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Comment
          if (comment.isNotEmpty)
            Text(
              comment,
              style: const TextStyle(
                color: Color(0xFF51725F),
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),

          // Review images
          if (images.isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 70,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      images[index],
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 70,
                        height: 70,
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  Future<void> _addToCart() async {
    setState(() => _isAddingToCart = true);

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        if (mounted) AppNavigator.toLogin(context);
        return;
      }

      await Supabase.instance.client.from('cart').insert({
        'user_id': user.id,
        'product_id': widget.productId,
        'quantity': 1,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Berhasil ditambahkan ke keranjang!'),
            backgroundColor: Color(0xFF426E55),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isAddingToCart = false);
    }
  }
}