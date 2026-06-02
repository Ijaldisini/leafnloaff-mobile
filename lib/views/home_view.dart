import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import '../models/user_model.dart';
// import '../views/app_navigator.dart';
import 'detail_menu_view.dart';

class HomeView extends StatefulWidget {
  final UserModel user;

  const HomeView({super.key, required this.user});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _supabase = Supabase.instance.client;

  int _selectedNavIndex = 0;
  bool _isLoading = true;

  final Set<String> _favoriteItems = {};

  List<String> _categories = [];
  String _selectedCategory = '';

  List<Map<String, dynamic>> _menus = [];
  Map<String, dynamic>? _activeVoucher;

  // ✅ Nav icons sesuai screenshot
  final List<IconData> _navIcons = [
    Icons.home_rounded,
    Icons.shopping_cart_outlined,
    Icons.notifications_outlined,
    Icons.person_outline,
  ];
  final List<String> _navLabels = ['Home', 'Cart', 'Notif', 'Profile'];

  @override
  void initState() {
    super.initState();
    _fetchHomeData();
  }

  Future<void> _fetchHomeData() async {
    setState(() => _isLoading = true);
    try {
      final voucherData = await _supabase
          .from('vouchers')
          .select()
          .eq('is_active', true)
          .order('created_at', ascending: false)
          .limit(1);

      if (voucherData.isNotEmpty) _activeVoucher = voucherData.first;

      final menuData = await _supabase
          .from('menus')
          .select()
          .eq('is_active', true)
          .order('created_at', ascending: false);

      _menus = List<Map<String, dynamic>>.from(menuData);

      final Set<String> unique = {};
      for (var m in _menus) {
        if (m['category'] != null) unique.add(m['category'].toString());
      }
      _categories = unique.toList();
      if (_categories.isNotEmpty) _selectedCategory = _categories.first;
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final products =
        _menus.where((m) => m['category'] == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF3D5A4A),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFD699AB)),
            )
          : Stack(
              children: [
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        color: const Color(0xFFD699AB),
                        child: SafeArea(
                          bottom: false,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 12),

                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: Color(0xFF2D4839),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 4),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Your Location',
                                          style: TextStyle(
                                            color: const Color(0xFFFDFDFD),
                                            fontSize: 19.17,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w800,
                                            height: 1.10,
                                            shadows: [
                                              Shadow(
                                                offset: const Offset(2, 2),
                                                blurRadius: 4,
                                                color: Colors.black
                                                    .withOpacity(0.25),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          'Blablabla Street, Blabla City',
                                          style: TextStyle(
                                            color: const Color.fromARGB(116, 253, 253, 253)
                                                .withOpacity(0.70),
                                            fontSize: 15,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500,
                                            height: 1.10
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    // Logout
                                    // GestureDetector(
                                    //   onTap: () async {
                                    //     await _supabase.auth.signOut();
                                    //     if (context.mounted) {
                                    //       AppNavigator.toLogin(context);
                                    //     }
                                    //   },
                                    //   child: Container(
                                    //     padding: const EdgeInsets.all(6),
                                    //     decoration: BoxDecoration(
                                    //       color:
                                    //           Colors.white.withOpacity(0.3),
                                    //       shape: BoxShape.circle,
                                    //     ),
                                    //     child: const Icon(
                                    //       Icons.logout,
                                    //       color: Color(0xFF2D4839),
                                    //       size: 18,
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 14),

                              // 🔍 Search Bar
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(100),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 14),
                                      Container(
                                        width: 30,
                                        height: 30,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF426E55),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.search,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      const Text(
                                        'Search...',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 13,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),

                      // 🎨 Gradient fade pink → hijau
                      Container(
                        width: double.infinity,
                        height: 40,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFFD699AB), Color(0xFF3D5A4A)],
                          ),
                        ),
                      ),

                      // 🖼️ Banner Voucher — overlap ke atas gradient
                      Transform.translate(
                        offset: const Offset(0, -30),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Container(
                            width: double.infinity,
                            height: 130,
                            decoration: BoxDecoration(
                              color: const Color(0xFF426E55),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                _activeVoucher?['image_url'] ??
                                    'https://picsum.photos/334/130',
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    color: Colors.white54,
                                    size: 40,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // ─── Section bawah (hijau) ────────────────
                      Transform.translate(
                        offset: const Offset(0, -20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            // 🏷️ Category chips
                            if (_categories.isNotEmpty)
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24),
                                child: Row(
                                  children: _categories.map((cat) {
                                    final isActive = cat == _selectedCategory;
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8),
                                      child: GestureDetector(
                                        onTap: () => setState(
                                            () => _selectedCategory = cat),
                                        child: AnimatedContainer(
                                          duration: const Duration(
                                              milliseconds: 200),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: isActive
                                                ? const Color(0xFFCA748D)
                                                : Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            border: Border.all(
                                              color: isActive
                                                  ? const Color(0xFFCA748D)
                                                  : Colors.white
                                                      .withOpacity(0.5),
                                              width: 1,
                                            ),
                                          ),
                                          child: Text(
                                            cat,
                                            style: TextStyle(
                                              color: isActive
                                                  ? Colors.white
                                                  : Colors.white
                                                      .withOpacity(0.8),
                                              fontSize: 12,
                                              fontFamily: 'Poppins',
                                              fontWeight: isActive
                                                  ? FontWeight.w700
                                                  : FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),

                            const SizedBox(height: 16),

                            if (products.isEmpty)
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 20),
                                child: Text(
                                  'Belum ada menu di kategori ini.',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              )
                            else
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24),
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  physics:
                                      const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 155 / 163,
                                    crossAxisSpacing: 14,
                                    mainAxisSpacing: 14,
                                  ),
                                  itemCount: products.length,
                                  itemBuilder: (_, i) {
                                    final m = products[i];
                                    return _buildProductItem(
                                      m['id'].toString(),
                                      m['image_url'] ??
                                          'https://picsum.photos/155/163',
                                      m['name'] ?? 'Unknown',
                                      m['price'] ?? 0,
                                      m,
                                    );
                                  },
                                ),
                              ),

                            // Padding bawah untuk nav bar
                            const SizedBox(height: 120),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // 🔽 Bottom gradient overlay
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 110,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Color(0xFF3D5A4A), Color(0x003D5A4A)],
                      ),
                    ),
                  ),
                ),

                // 🧭 Bottom Nav Bar — sesuai screenshot
                Positioned(
                  left: 24,
                  right: 24,
                  bottom: 8,
                  child: Container(
                    height: 58,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFD699AB), Color(0xFFCA748D)],
                      ),
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFCA748D).withOpacity(0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(
                        _navLabels.length,
                        (i) => _buildNavItem(i),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  // ─── Product Card ─────────────────────────────────
  Widget _buildProductItem(
    String id,
    String imageUrl,
    String name,
    dynamic price,
    Map<String, dynamic> menuData,
  ) {
    final isFav = _favoriteItems.contains(id);
    final priceFormatted = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(price is int ? price : (price as num).toInt());

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetailMenuView(
            productId: id,
            productName: name,
            productImage: imageUrl,
            price: price is int ? price : (price as num).toInt(),
            description: menuData['description'] ?? 'Tidak ada deskripsi',
            rating: (menuData['rating'] ?? 5.0).toDouble(),
            totalReviews: menuData['total_reviews'] ?? 0,
            ratingDistribution: menuData['rating_distribution'] != null
                ? Map<int, int>.from(menuData['rating_distribution'])
                : null,
          ),
        ),
      ),
      child: Hero(
        tag: 'product_$id',
        child: Stack(
          children: [
            // 🖼️ Gambar
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF426E55),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Colors.white54,
                    ),
                  ),
                ),
              ),
            ),

            // 🎨 Gradient bawah
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 90,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x00CA748D), Color(0xFFCA748D)],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
              ),
            ),

            Positioned(
              left: 10,
              bottom: 10,
              right: 44,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    priceFormatted,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              right: 8,
              bottom: 8,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => setState(() {
                  if (isFav) {
                    _favoriteItems.remove(id);
                  } else {
                    _favoriteItems.add(id);
                  }
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: isFav
                        ? const Color(0xFFCA748D)
                        : Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    isFav ? Icons.check : Icons.add,          
                    size: 30,
                    color: isFav
                        ? Colors.white
                        : const Color(0xFF426E55),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Nav Item ─────────────────────────────────────
  Widget _buildNavItem(int index) {
    final isActive = _selectedNavIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedNavIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? Colors.white.withOpacity(0.25)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _navIcons[index],
              size: 22,
              color: isActive ? Colors.white : Colors.white.withOpacity(0.6),
            ),
            if (isActive) ...[
              const SizedBox(height: 2),
              Text(
                _navLabels[index],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}