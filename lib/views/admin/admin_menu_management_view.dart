import 'package:flutter/material.dart';
import '../../viewmodels/admin_menu_management_viewmodel.dart';
import '../../models/menu_model.dart';
import '../admin/admin_add_menu_view.dart';
import '../admin/admin_edit_menu_view.dart';
import '../admin/admin_preview_menu_view.dart';

class AdminMenuManagementView extends StatefulWidget {
  const AdminMenuManagementView({super.key});

  @override
  State<AdminMenuManagementView> createState() =>
      _AdminMenuManagementViewState();
}

class _AdminMenuManagementViewState extends State<AdminMenuManagementView>
    with SingleTickerProviderStateMixin {
  final AdminMenuManagementViewModel _viewModel =
      AdminMenuManagementViewModel();

  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF3D5A4A),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          return Stack(
            children: [
              // ── Pink background header ──────────────────
              Positioned(
                left: -17,
                top: -30,
                child: Container(
                  width: screenWidth + 34,
                  height: 260,
                  color: const Color(0xFFD699AB),
                ),
              ),

              // ── Gradient fade ───────────────────────────
              Positioned(
                left: -17,
                top: 130,
                child: Container(
                  width: screenWidth + 34,
                  height: 120,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x003D5A4A), Color(0xFF3D5A4A)],
                    ),
                  ),
                ),
              ),

              // ── Konten utama ────────────────────────────
              SafeArea(
                child: _viewModel.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFCA748D),
                        ),
                      )
                    : FadeTransition(
                        opacity: _fadeAnim,
                        child: ListView(
                          padding:
                              const EdgeInsets.fromLTRB(22, 20, 22, 120),
                          physics: const BouncingScrollPhysics(),
                          children: [
                            // ── Header row ────────────────
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Menu',
                                        style: TextStyle(
                                          color: Color(0xFFFDFDFD),
                                          fontSize: 28,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w900,
                                          height: 1,
                                          shadows: [
                                            Shadow(
                                              offset: Offset(2, 2),
                                              blurRadius: 6,
                                              color: Color(0x40000000),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        'Management',
                                        style: TextStyle(
                                          color: Colors.white
                                              .withOpacity(0.75),
                                          fontSize: 13,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // ── Tombol Add ─────────────
                                GestureDetector(
                                  onTap: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const AdminAddMenuView(),
                                      ),
                                    );
                                    if (result == true) {
                                      _viewModel.fetchMenus();
                                    }
                                  },
                                  child: Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFFEED5DB),
                                          Color(0xFFCA748D),
                                        ],
                                      ),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFFCA748D)
                                              .withOpacity(0.45),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.add_rounded,
                                      color: Colors.white,
                                      size: 26,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 18),

                            // ── Search bar ─────────────────
                            Container(
                              height: 42,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.12),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF426E55),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.search_rounded,
                                      color: Colors.white,
                                      size: 17,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextField(
                                      onChanged: _viewModel.searchMenu,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontFamily: 'Poppins',
                                        color: Colors.black87,
                                      ),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.zero,
                                        hintText: 'Cari menu...',
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 13,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // ── Category chips ─────────────
                            SizedBox(
                              height: 32,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _viewModel.categories.length,
                                itemBuilder: (_, i) {
                                  final cat = _viewModel.categories[i];
                                  final isActive =
                                      _viewModel.selectedCategory == cat;
                                  return GestureDetector(
                                    onTap: () =>
                                        _viewModel.setCategory(cat),
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                          milliseconds: 200),
                                      margin:
                                          const EdgeInsets.only(right: 8),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      alignment: Alignment.center,
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
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 20),

                            // ── Stats row ──────────────────
                            _buildStatsRow(),

                            const SizedBox(height: 20),

                            // ── Menu cards ─────────────────
                            if (_viewModel.menus.isEmpty)
                              _buildEmptyState()
                            else
                              ..._viewModel.menus
                                  .map((m) => _buildMenuCard(m)),
                          ],
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ── Stats row ──────────────────────────────────────
  Widget _buildStatsRow() {
    final total = _viewModel.menus.length;
    final active =
        _viewModel.menus.where((m) => m.isActive).length;
    final outOfStock =
        _viewModel.menus.where((m) => m.stock == 0).length;

    return Row(
      children: [
        _buildStatChip(
          label: 'Total',
          value: '$total',
          color: const Color(0xFF426E55),
          icon: Icons.restaurant_menu_rounded,
        ),
        const SizedBox(width: 10),
        _buildStatChip(
          label: 'Aktif',
          value: '$active',
          color: const Color(0xFFCA748D),
          icon: Icons.check_circle_outline_rounded,
        ),
        const SizedBox(width: 10),
        _buildStatChip(
          label: 'Habis',
          value: '$outOfStock',
          color: const Color(0xFFB94F4F),
          icon: Icons.remove_circle_outline_rounded,
        ),
      ],
    );
  }

  Widget _buildStatChip({
    required String label,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 10,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Empty state ────────────────────────────────────
  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.restaurant_menu_rounded,
              size: 40,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Belum ada menu',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Tap + untuk menambah menu baru',
            style: TextStyle(
              color: Colors.white.withOpacity(0.3),
              fontSize: 12,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  // ── Menu card ──────────────────────────────────────
  Widget _buildMenuCard(MenuModel menu) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AdminPreviewMenuView(menu: menu),
          ),
        );
        if (result == true) _viewModel.fetchMenus();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        height: 110,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // ── Gambar ───────────────────────────────
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              child: SizedBox(
                width: 110,
                height: double.infinity,
                child: menu.imageUrl != null && menu.imageUrl!.isNotEmpty
                    ? Image.network(
                        menu.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: const Color(0xFFEED5DB),
                          child: const Center(
                            child: Icon(
                              Icons.broken_image_rounded,
                              color: Color(0xFFCA748D),
                              size: 28,
                            ),
                          ),
                        ),
                      )
                    : Container(
                        color: const Color(0xFFEED5DB),
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported_rounded,
                            color: Color(0xFFCA748D),
                            size: 28,
                          ),
                        ),
                      ),
              ),
            ),

            // ── Konten ───────────────────────────────
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.fromLTRB(12, 10, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama + action buttons
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            menu.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: menu.isActive
                                  ? const Color(0xFF2D4839)
                                  : Colors.grey,
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w800,
                              decoration: menu.isActive
                                  ? TextDecoration.none
                                  : TextDecoration.lineThrough,
                            ),
                          ),
                        ),

                        // Edit
                        _actionBtn(
                          icon: Icons.edit_rounded,
                          color: const Color(0xFF426E55),
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    AdminEditMenuView(menu: menu),
                              ),
                            );
                            if (result == true) _viewModel.fetchMenus();
                          },
                        ),
                        const SizedBox(width: 6),

                        // Delete
                        _actionBtn(
                          icon: Icons.delete_rounded,
                          color: const Color(0xFFB94F4F),
                          onTap: () => _showDeleteDialog(menu),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Deskripsi
                    Text(
                      menu.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF7A9E8B),
                        fontSize: 10,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                      ),
                    ),

                    const Spacer(),

                    // Harga + stok + badge
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _viewModel.formatCurrency(menu.price),
                          style: const TextStyle(
                            color: Color(0xFF2D4839),
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Spacer(),

                        // Stok pill
                        _stockPill(menu.stock),

                        const SizedBox(width: 6),

                        // Status badge
                        if (!menu.isActive) _inactiveBadge(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Action button kecil ────────────────────────────
  Widget _actionBtn({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 16),
      ),
    );
  }

  // ── Stok pill ──────────────────────────────────────
  Widget _stockPill(int stock) {
    final isOut = stock == 0;
    final isLow = stock > 0 && stock <= 5;
    final Color color = isOut
        ? const Color(0xFFB94F4F)
        : isLow
            ? const Color(0xFFD4783A)
            : const Color(0xFF426E55);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: color.withOpacity(0.4), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isOut
                ? Icons.remove_circle_rounded
                : Icons.inventory_2_outlined,
            size: 10,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            isOut ? 'Habis' : 'Stok: $stock',
            style: TextStyle(
              color: color,
              fontSize: 9,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ── Inactive badge ─────────────────────────────────
  Widget _inactiveBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFFFD1D2),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: const Color(0xFFC33537).withOpacity(0.4),
          width: 1,
        ),
      ),
      child: const Text(
        'Nonaktif',
        style: TextStyle(
          color: Color(0xFFC33537),
          fontSize: 9,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // ── Dialog hapus ───────────────────────────────────
  void _showDeleteDialog(MenuModel menu) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFB94F4F).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_rounded,
                color: Color(0xFFB94F4F),
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Hapus Menu',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w800,
                color: Color(0xFF2D4839),
              ),
            ),
          ],
        ),
        content: Text(
          'Hapus "${menu.name}" secara permanen?',
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            color: Color(0xFF51725F),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text(
              'Batal',
              style: TextStyle(
                color: Colors.grey,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogCtx);
              _viewModel.deleteMenu(menu.id, context);
            },
            style: TextButton.styleFrom(
              backgroundColor:
                  const Color(0xFFB94F4F).withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Hapus',
              style: TextStyle(
                color: Color(0xFFB94F4F),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}