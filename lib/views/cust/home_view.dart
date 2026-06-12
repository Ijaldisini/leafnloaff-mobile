import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/user_model.dart';
import '../../viewmodels/cust/home_viewmodel.dart';
import 'detail_menu_view.dart';
import '../../models/voucher_model.dart';
import '../../viewmodels/cust/cart_viewmodel.dart';
import 'checkout_view.dart';

class HomeView extends StatefulWidget {
  final UserModel user;

  const HomeView({super.key, required this.user});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeViewModel _viewModel = HomeViewModel();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel.fetchHomeData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3D5A4A),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, child) {
          if (_viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFD699AB)),
            );
          }

          final products = _viewModel.filteredMenus;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 120),
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
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Color(0xFF2D4839),
                                size: 28,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
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
                                            color: Colors.black.withValues(
                                              alpha: 0.25,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      _viewModel.currentLocation,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: 0.8,
                                        ),
                                        fontSize: 13,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                        height: 1.10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _searchController,
                              onChanged: (value) =>
                                  _viewModel.setSearchQuery(value),
                              style: const TextStyle(
                                color: Color(0xFF2D4839),
                                fontFamily: 'Poppins',
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Search...',
                                hintStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                ),
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: Color(0xFF426E55),
                                ),
                                suffixIcon: _viewModel.searchQuery.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(
                                          Icons.clear,
                                          color: Colors.grey,
                                        ),
                                        onPressed: () {
                                          _searchController.clear();
                                          _viewModel.setSearchQuery('');
                                        },
                                      )
                                    : null,
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

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

                Transform.translate(
                  offset: const Offset(0, -30),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: GestureDetector(
                      onTap: () {
                        final cartVM = CartViewModel();

                        if (cartVM.selectedItemIds.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Silahkan untuk memilih menu untuk dibeli terlebih dahulu',
                                style: TextStyle(fontFamily: 'Poppins'),
                              ),
                              backgroundColor: Colors.orange,
                            ),
                          );
                          return;
                        }

                        if (_viewModel.activeVoucher != null) {
                          final voucherData = VoucherModel.fromJson(
                            _viewModel.activeVoucher!,
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CheckoutView(initialVoucher: voucherData),
                            ),
                          );
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: 130,
                        decoration: BoxDecoration(
                          color: const Color(0xFF426E55),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.25),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            _viewModel.activeVoucher?['image_url'] ??
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
                ),

                Transform.translate(
                  offset: const Offset(0, -20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_viewModel.categories.isNotEmpty &&
                          _viewModel.searchQuery.isEmpty)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
                            children: _viewModel.categories.map((cat) {
                              final isActive =
                                  cat == _viewModel.selectedCategory;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: GestureDetector(
                                  onTap: () => _viewModel.selectCategory(cat),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isActive
                                          ? const Color(0xFFCA748D)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(
                                        color: isActive
                                            ? const Color(0xFFCA748D)
                                            : Colors.white.withValues(
                                                alpha: 0.5,
                                              ),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      cat,
                                      style: TextStyle(
                                        color: isActive
                                            ? Colors.white
                                            : Colors.white.withValues(
                                                alpha: 0.8,
                                              ),
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
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 20,
                          ),
                          child: Text(
                            _viewModel.searchQuery.isNotEmpty
                                ? 'Tidak ada menu yang cocok dengan "${_viewModel.searchQuery}".'
                                : 'Belum ada menu di kategori ini.',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
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
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductItem(
    String id,
    String imageUrl,
    String name,
    dynamic price,
    Map<String, dynamic> menuData,
  ) {
    final isAdded = _viewModel.recentlyAddedItems.contains(id);

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
                onTap: () => _viewModel.addToCart(id),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: isAdded
                        ? const Color(0xFFCA748D)
                        : Colors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    isAdded ? Icons.check : Icons.add,
                    size: 24,
                    color: isAdded ? Colors.white : const Color(0xFF426E55),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
