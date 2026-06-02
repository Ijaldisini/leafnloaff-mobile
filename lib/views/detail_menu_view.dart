// lib/views/detail_menu_view.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../views/app_navigator.dart';
import 'review_menu_view.dart'; 

class DetailMenuView extends StatefulWidget {
  final String productId;
  final String productName;
  final String productImage;
  final int price;
  final String description;
  final double rating;
  final int totalReviews;
  final Map<int, int>? ratingDistribution;

  const DetailMenuView({
    super.key,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.description,
    this.rating = 5.0,
    this.totalReviews = 20,
    this.ratingDistribution,
  });

  @override
  State<DetailMenuView> createState() => _DetailMenuViewState();
}

class _DetailMenuViewState extends State<DetailMenuView>
    with SingleTickerProviderStateMixin {

  late final Map<int, int> _ratingDist;
  bool _isAddingToCart = false;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _ratingDist = widget.ratingDistribution ??
        {5: 20, 4: 0, 3: 0, 2: 0, 1: 0};

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  String get _formattedPrice {
    return 'Rp ${widget.price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    )}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3D5A4A),
      body: Stack(
        children: [
          // 🎨 Background Gradient
          Positioned.fill(  
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFD699AB),  
                    Color(0xFFD699AB),  
                    Color(0xFF3D5A4A), 
                    Color(0xFF3D5A4A), 
                  ],
                  stops: [0.0, 0.25, 0.45, 1.0],  
                ),
              ),
            ),
          ),
          // 📄 Konten utama
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      // ← Back + Judul
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            _backButton(),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                widget.productName,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.5,
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

                      // 🖼️ Gambar produk
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 26),
                        child: Hero(                              
                          tag: 'product_${widget.productId}',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              widget.productImage,
                              width: double.infinity,
                              height: 265,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                height: 265,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF426E55),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.image_not_supported,
                                  color: Colors.white54,
                                  size: 48,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // 💰 Harga overlay di atas gambar
                      Transform.translate(
                        offset: const Offset(0, -90),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 26),
                          child: Container(
                            width: double.infinity,
                            height: 100,
                            decoration: const ShapeDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Color(0x00CA748D), Color(0xFFCA748D)],
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                            ),
                            alignment: Alignment.bottomLeft,
                            padding: const EdgeInsets.only(left: 16, bottom: 14),
                            child: Text(
                              _formattedPrice,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w800,
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

                      // 📋 Card deskripsi + rating
                      Padding(
                        padding: const EdgeInsets.fromLTRB(26, 0, 26, 0),
                        child: Container(
                          width: double.infinity,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            shadows: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Description header
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 4,
                                      height: 22,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFCA748D),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Description',
                                      style: TextStyle(
                                        color: Color(0xFF2D4839),
                                        fontSize: 18,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                                child: Text(
                                  widget.description,
                                  style: const TextStyle(
                                    color: Color(0xFF51725F),
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    height: 1.6,
                                  ),
                                ),
                              ),

                              // Divider
                              Container(
                                height: 1,
                                margin: const EdgeInsets.symmetric(horizontal: 16),
                                color: const Color(0xFFEED5DB),
                              ),

                              // Rating section
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: _buildRatingSection(),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 110),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 🛒 Tombol Add to Cart
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildAddToCartButton(),
          ),
        ],
      ),
    );
  }

  // ← Back button
  Widget _backButton() {
    return GestureDetector(
      onTap: () => AppNavigator.back(context),               // ✅ pakai AppNavigator
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
        child: const Icon(Icons.arrow_back, color: Colors.white, size: 18),
      ),
    );
  }

  // ⭐ Rating section
  Widget _buildRatingSection() {
    final maxCount = _ratingDist.values.isEmpty
        ? 1
        : _ratingDist.values.reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFCA748D),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCA748D),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Rating',
                    style: TextStyle(
                      color: Color(0xFF2D4839),
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: ShapeDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFD699AB), Color(0xFFCA748D)],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: GestureDetector( 
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReviewMenuView(
                          productId: widget.productId,
                          productName: widget.productName,
                          productImage: widget.productImage,
                          price: widget.price,
                          rating: widget.rating,
                          totalReviews: widget.totalReviews,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'See More',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.rating.toStringAsFixed(1),
                    style: const TextStyle(
                      color: Color(0xFFCA748D),
                      fontSize: 42,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w800,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: List.generate(5, (i) {
                      final filled = i < widget.rating.round();
                      return Icon(
                        filled ? Icons.star_rounded : Icons.star_outline_rounded,
                        size: 14,
                        color: filled 
                            ? const Color(0xFFFFC107) 
                            : const Color(0xFFFFE082), 
                      );
                    }),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${widget.totalReviews} reviews',
                    style: const TextStyle(
                      color: Color(0xFFD699AB),
                      fontSize: 9,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 20),

              // Bar chart rating
              Expanded(
                child: Column(
                  children: List.generate(5, (index) {
                    final starValue = 5 - index;
                    final count = _ratingDist[starValue] ?? 0;
                    final ratio = maxCount > 0 ? count / maxCount : 0.0;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        children: [
                          Text(
                            starValue.toString(),
                            style: const TextStyle(
                              color: Color(0xFFCA748D),
                              fontSize: 11,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.star_rounded,
                            size: 10,
                            color: Color(0xFFCA748D),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Stack(
                                children: [
                                  Container(
                                    height: 6,
                                    color: const Color(0xFFEED5DB),
                                  ),
                                  FractionallySizedBox(         
                                    widthFactor: ratio.toDouble(),
                                    child: Container(
                                      height: 6,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFFD699AB),
                                            Color(0xFFCA748D),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          SizedBox(
                            width: 20,
                            child: Text(
                              count.toString(),
                              style: const TextStyle(
                                color: Color(0xFFD699AB),
                                fontSize: 10,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
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
        ],
      ),
    );
  }

  // 🛒 Add to Cart button
  Widget _buildAddToCartButton() {
    return Container(
      width: double.infinity,
      height: 98,
      decoration: ShapeDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFD699AB), Color(0xFFCA748D)],
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        shadows: [
          BoxShadow(
            color: const Color(0xFFCA748D).withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Center(
        child: GestureDetector(
          onTap: _isAddingToCart ? null : _addToCart,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: _isAddingToCart ? 48 : 160,
            height: 44,
            decoration: ShapeDecoration(
              color: const Color(0xFF426E55),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              shadows: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: _isAddingToCart
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.shopping_cart_outlined,
                            color: Colors.white, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Add to Cart',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  void _addToCart() async {
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
        'created_at': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text(
                  'Berhasil ditambahkan ke keranjang!',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF426E55),
            behavior: SnackBarBehavior.floating,             // ✅ floating snackbar lebih bagus
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gagal menambahkan: $e',
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
            backgroundColor: const Color(0xFFCA748D),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isAddingToCart = false);
    }
  }
}