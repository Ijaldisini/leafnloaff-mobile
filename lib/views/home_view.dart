import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import '../models/user_model.dart';
import 'login_view.dart';

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

  final List<String> _navLabels = ['Home', 'Menu', 'Cart', 'Profile'];
  final List<IconData> _navIcons = [
    Icons.home_rounded,
    Icons.restaurant_menu_rounded,
    Icons.shopping_cart_rounded,
    Icons.person_rounded,
  ];

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

      if (voucherData.isNotEmpty) {
        _activeVoucher = voucherData.first;
      }

      final menuData = await _supabase
          .from('menus')
          .select()
          .eq('is_active', true)
          .order('created_at', ascending: false);

      _menus = List<Map<String, dynamic>>.from(menuData);

      final Set<String> uniqueCategories = {};
      for (var menu in _menus) {
        if (menu['category'] != null) {
          uniqueCategories.add(menu['category'].toString());
        }
      }

      _categories = uniqueCategories.toList();

      if (_categories.isNotEmpty) {
        _selectedCategory = _categories.first;
      }
    } catch (e) {
      debugPrint("Error fetching home data: $e");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final products = _menus
        .where((m) => m['category'] == _selectedCategory)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFF3D5A4A),
      appBar: AppBar(
        title: const Text(
          'Leaf & Loaf',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF3D5A4A), 
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await _supabase.auth.signOut();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginView()),
                );
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFD699AB)),
            )
          : Stack(
              children: [
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(
                    bottom: 120,
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        left: -17,
                        top: -30,
                        child: Container(
                          width: screenWidth + 34,
                          height: 289,
                          color: const Color(0xFFD699AB),
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
                              begin: Alignment(0.50, 0.00),
                              end: Alignment(0.50, 1.00),
                              colors: [Color(0x003D5A4A), Color(0xFF3D5A4A)],
                            ),
                          ),
                        ),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 28),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome, ${widget.user.username}!',
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
                                        color: Colors.black.withOpacity(0.25),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Opacity(
                                  opacity: 0.70,
                                  child: Text(
                                    'What do you want to eat today?',
                                    style: TextStyle(
                                      color: Color(0xFFFDFDFD),
                                      fontSize: 15,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      height: 1.10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 28),
                            child: Container(
                              height: 36,
                              decoration: ShapeDecoration(
                                color: const Color(0xFFFDFDFD),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(103),
                                ),
                                shadows: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.25),
                                    blurRadius: 4,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(width: 12),
                                  Container(
                                    width: 26,
                                    height: 26,
                                    decoration: const ShapeDecoration(
                                      color: Color(0xFF426E55),
                                      shape: OvalBorder(),
                                    ),
                                    child: const Icon(
                                      Icons.search,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Search...',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 25),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 28),
                            child: Container(
                              width: double.infinity,
                              height: 121,
                              decoration: ShapeDecoration(
                                color: const Color(0xFF426E55),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                shadows: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.25),
                                    blurRadius: 4,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  _activeVoucher?['image_url'] ??
                                      "https://picsum.photos/334/121",
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child: Icon(
                                        Icons.broken_image,
                                        color: Colors.white54,
                                        size: 40,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 25),

                          if (_categories.isNotEmpty)
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 28,
                              ),
                              child: Row(
                                children: _categories.map((cat) {
                                  final isActive = cat == _selectedCategory;
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 6),
                                    child: GestureDetector(
                                      onTap: () => setState(() {
                                        _selectedCategory = cat;
                                      }),
                                      child: AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                        ),
                                        height: 28,
                                        decoration: ShapeDecoration(
                                          color: isActive
                                              ? const Color(0xFFCA748D)
                                              : Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                              width: 1,
                                              color: Color(0xFFFDFDFD),
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              24,
                                            ),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            cat,
                                            style: const TextStyle(
                                              color: Color(0xFFFDFDFD),
                                              fontSize: 12,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),

                          const SizedBox(height: 20),

                          if (products.isEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 28,
                                vertical: 20,
                              ),
                              child: Text(
                                "Belum ada menu di kategori ini.",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            )
                          else
                            GridView.builder(
                              shrinkWrap: true,
                              physics:
                                  const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 28,
                              ),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio:
                                        155 /
                                        163,
                                    crossAxisSpacing: 15,
                                    mainAxisSpacing: 15,
                                  ),
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                final menu = products[index];
                                return _buildProductItem(
                                  menu['id'].toString(),
                                  menu['image_url'] ??
                                      "https://picsum.photos/155/163",
                                  menu['name'] ?? "Unknown",
                                  menu['price'] ?? 0,
                                );
                              },
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                Positioned(
                  left: 0,
                  bottom: 0,
                  child: Container(
                    width: screenWidth,
                    height: 130,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Color(0xFF3D5A4A), Color(0x003E5A4A)],
                      ),
                    ),
                  ),
                ),

                Positioned(
                  left: 25,
                  right: 25,
                  bottom: 30,
                  child: Container(
                    height: 56,
                    decoration: ShapeDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment(0.50, 0.00),
                        end: Alignment(0.50, 1.00),
                        colors: [Color(0xFFD699AB), Color(0xFFCA748D)],
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(120),
                      ),
                      shadows: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 4,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(_navLabels.length, (i) {
                        return _buildNavItem(i);
                      }),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildProductItem(
    String id,
    String imageUrl,
    String name,
    dynamic price,
  ) {
    final isFav = _favoriteItems.contains(id);

    final priceFormatted = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(price);

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
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

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 88,
            child: Container(
              decoration: const ShapeDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.50, 0.00),
                  end: Alignment(0.50, 1.00),
                  colors: [Color(0x00CA748D), Color(0xFFCA748D)],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            left: 10,
            bottom: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFFFDFDFD),
                      fontSize: 13,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  priceFormatted,
                  style: const TextStyle(
                    color: Color(0xFFFDFDFD),
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
                      : const Color(0xFFFDFDFD),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  size: 18,
                  color: isFav ? Colors.white : const Color(0xFFCA748D),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final isActive = _selectedNavIndex == index;
    final label = _navLabels[index];

    return GestureDetector(
      onTap: () => setState(() => _selectedNavIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFEED5DB) : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _navIcons[index],
              size: 22,
              color: isActive
                  ? const Color(0xFFCA748D)
                  : const Color(0xFFFDFDFD).withOpacity(0.65),
            ),
            if (isActive) ...[
              const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFFCA748D),
                  fontSize: 10,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
