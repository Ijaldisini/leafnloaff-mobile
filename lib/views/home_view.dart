import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import 'login_view.dart';

class HomeView extends StatefulWidget {           // ✅ StatefulWidget, bukan StatelessWidget
  final UserModel user;

  const HomeView({super.key, required this.user});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  // ─── State ───────────────────────────────────────
  String _selectedCategory = 'Makanan';
  int _selectedNavIndex = 0;
  final Set<int> _favoriteItems = {};           // ✅ index produk yang di-favorite

  final List<String> _categories = ['Makanan', 'Minuman', 'Snack', 'Dessert'];
  final List<String> _navLabels = ['Home', 'Menu', 'Cart', 'Profile'];
  final List<IconData> _navIcons = [
    Icons.home_rounded,
    Icons.restaurant_menu_rounded,
    Icons.shopping_cart_rounded,
    Icons.person_rounded,
  ];

  // ─── Dummy produk per kategori ───────────────────
  final Map<String, List<Map<String, String>>> _productsByCategory = {
    'Makanan': [
      {'name': 'Nasi Goreng', 'image': 'https://picsum.photos/155/163?random=1'},
      {'name': 'Ayam Bakar', 'image': 'https://picsum.photos/155/163?random=2'},
      {'name': 'Soto Ayam', 'image': 'https://picsum.photos/155/163?random=3'},
      {'name': 'Gado-Gado', 'image': 'https://picsum.photos/155/163?random=4'},
    ],
    'Minuman': [
      {'name': 'Es Teh', 'image': 'https://picsum.photos/155/163?random=5'},
      {'name': 'Jus Alpukat', 'image': 'https://picsum.photos/155/163?random=6'},
      {'name': 'Kopi Susu', 'image': 'https://picsum.photos/155/163?random=7'},
      {'name': 'Matcha Latte', 'image': 'https://picsum.photos/155/163?random=8'},
    ],
    'Snack': [
      {'name': 'Risoles', 'image': 'https://picsum.photos/155/163?random=9'},
      {'name': 'Lumpia', 'image': 'https://picsum.photos/155/163?random=10'},
      {'name': 'Pastel', 'image': 'https://picsum.photos/155/163?random=11'},
      {'name': 'Klepon', 'image': 'https://picsum.photos/155/163?random=12'},
    ],
    'Dessert': [
      {'name': 'Es Campur', 'image': 'https://picsum.photos/155/163?random=13'},
      {'name': 'Puding Coklat', 'image': 'https://picsum.photos/155/163?random=14'},
      {'name': 'Brownies', 'image': 'https://picsum.photos/155/163?random=15'},
      {'name': 'Bika Ambon', 'image': 'https://picsum.photos/155/163?random=16'},
    ],
  };

  // ─── Build ────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final products = _productsByCategory[_selectedCategory] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Leaf & Loaf',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF2D4839),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
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
      body: Container(
        color: const Color(0xFF3D5A4A),
        child: SingleChildScrollView(
          child: SizedBox(
            width: screenWidth,
            height: 850,
            child: Stack(
              clipBehavior: Clip.none,
              children: [

                // 🎨 Background pink
                Positioned(
                  left: -17,
                  top: -30,
                  child: Container(
                    width: screenWidth + 34,
                    height: 289,
                    color: const Color(0xFFD699AB),
                  ),
                ),

                // 🎨 Gradient fade ke hijau
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

                // 📍 Location
                Positioned(
                  left: 28,
                  top: 67,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                              color: Colors.black.withOpacity(0.25),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Opacity(
                        opacity: 0.70,
                        child: const Text(
                          'Blablabla Street, Blabla City',
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

                // 🔍 Search Bar
                Positioned(
                  left: 28,
                  top: 126,
                  child: Container(
                    width: screenWidth - 56,
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
                          child: const Icon(Icons.search, size: 16, color: Colors.white),
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

                // 🖼️ Banner
                Positioned(
                  left: 28,
                  top: 180,
                  child: Container(
                    width: screenWidth - 56,
                    height: 121,
                    decoration: ShapeDecoration(
                      color: const Color(0xFF426E55),
                      image: const DecorationImage(
                        image: NetworkImage("https://picsum.photos/334/121"),
                        fit: BoxFit.cover,
                      ),
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
                  ),
                ),

                // 🏷️ Category Chips — BISA DIKLIK ✅
                Positioned(
                  left: 28,
                  top: 316,
                  right: 0,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _categories.map((cat) {
                        final isActive = cat == _selectedCategory;
                        return Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: GestureDetector(                    // ✅ klik ganti kategori
                            onTap: () => setState(() {
                              _selectedCategory = cat;
                              _favoriteItems.clear();               // reset favorite saat ganti kategori
                            }),
                            child: AnimatedContainer(               // ✅ animasi smooth saat aktif
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 12),
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
                                  borderRadius: BorderRadius.circular(24),
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
                ),

                // 📦 Product Grid — TAMPIL SESUAI KATEGORI ✅
                ...List.generate(products.length, (i) {
                  final col = i % 2;
                  final row = i ~/ 2;
                  final left = col == 0 ? 28.0 : screenWidth / 2 + 7;
                  final top = 358.0 + row * 182;
                  return _buildProductItem(
                    left, top,
                    products[i]['image']!,
                    products[i]['name']!,
                    i,
                  );
                }),

                // 🔽 Bottom Gradient Overlay
                Positioned(
                  left: 0,
                  top: 716,
                  child: Container(
                    width: screenWidth,
                    height: 130,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.50, 0.60),
                        end: Alignment(0.50, 0.00),
                        colors: [Color(0xFF3D5A4A), Color(0x003E5A4A)],
                      ),
                    ),
                  ),
                ),

                // 🧭 Bottom Nav — BISA DIKLIK ✅
                Positioned(
                  left: 25,
                  right: 25,
                  top: 790,
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
          ),
        ),
      ),
    );
  }

  // ─── Widget Helpers ───────────────────────────────

  Widget _buildProductItem(
    double left,
    double top,
    String imageUrl,
    String name,
    int index,
  ) {
    final isFav = _favoriteItems.contains(index);

    return Positioned(
      left: left,
      top: top,
      child: SizedBox(
        width: 155,
        height: 163,
        child: Stack(
          children: [
            // 🖼️ Gambar
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                imageUrl,
                width: 155,
                height: 163,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 155,
                  height: 163,
                  decoration: BoxDecoration(
                    color: const Color(0xFF426E55),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.image_not_supported, color: Colors.white54),
                ),
              ),
            ),

            // 🎨 Gradient Overlay
            Positioned(
              left: 0,
              top: 75,
              child: Container(
                width: 155,
                height: 88,
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

            // 🏷️ Nama Produk
            Positioned(
              left: 10,
              bottom: 30,
              child: Text(
                name,
                style: const TextStyle(
                  color: Color(0xFFFDFDFD),
                  fontSize: 13,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),

            // ❤️ Favorite — BISA DIKLIK & TOGGLE ✅
            Positioned(
              right: 8,
              bottom: 8,
              child: GestureDetector(
                onTap: () => setState(() {
                  if (isFav) {
                    _favoriteItems.remove(index);
                  } else {
                    _favoriteItems.add(index);
                  }
                }),
                child: AnimatedContainer(                          // ✅ animasi saat di-tap
                  duration: const Duration(milliseconds: 200),
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: isFav
                        ? const Color(0xFFCA748D)                 // merah kalau favorit
                        : const Color(0xFFFDFDFD),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    size: 18,
                    color: isFav
                        ? Colors.white
                        : const Color(0xFFCA748D),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final isActive = _selectedNavIndex == index;
    final label = _navLabels[index];

    return GestureDetector(                                        // ✅ klik ganti tab
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