import 'package:flutter/material.dart';
import '../../viewmodels/admin/admin_menu_management_viewmodel.dart';
import '../../models/menu_model.dart';
import 'admin_add_menu_view.dart';
import 'admin_edit_menu_view.dart';
import 'admin_preview_menu_view.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _showDeleteDialog(MenuModel menu) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: const Color(0xFFFDFDFD),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Color(0xFFC23437)),
            const SizedBox(width: 10),
            const Text(
              'Nonaktifkan Menu?',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w800,
                color: Color(0xFF2D4839),
                fontSize: 16,
              ),
            ),
          ],
        ),
        content: Text(
          'Menu "${menu.name}" akan dinonaktifkan dan disembunyikan dari pelanggan.',
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
            onPressed: () async {
              Navigator.pop(dialogCtx);
              final errorMsg = await _viewModel.deleteMenu(menu.id);
              if (!context.mounted) return;

              if (errorMsg == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Menu berhasil dinonaktifkan')),
                );
              } else {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(errorMsg)));
              }
            },
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFB94F4F).withValues(alpha: 0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Nonaktifkan',
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 20,
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Menu Management',
                        style: TextStyle(
                          color: Color(0xFFFDFDFD),
                          fontSize: 22,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w800,
                          shadows: [
                            Shadow(
                              offset: Offset(2, 2),
                              blurRadius: 4,
                              color: Colors.black26,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            onChanged: _viewModel.searchMenu,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              color: Color(0xFF2D4839),
                            ),
                            decoration: InputDecoration(
                              hintText: 'Cari menu...',
                              hintStyle: const TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Poppins',
                              ),
                              prefixIcon: Container(
                                margin: const EdgeInsets.all(4),
                                width: 32,
                                height: 32,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF426E55),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    'assets/images/Search.svg',
                                    width: 16,
                                    height: 16,
                                    colorFilter: const ColorFilter.mode(
                                      Colors.white,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AdminAddMenuView(),
                            ),
                          );
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment(1.00, 1.00), 
                              end: Alignment(0.00, 0.00),  
                              colors: [
                                Color(0xFF73986F), 
                                Color(0xFFFDFDFD), 
                              ],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 4,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/lingkaran hijau.svg',
                                  width: 28,
                                  height: 28,
                                ),
                                SvgPicture.asset(
                                  'assets/images/tambah.svg',
                                  width: 14,
                                  height: 14,
                                  colorFilter: const ColorFilter.mode(
                                    Color.fromARGB(255, 59, 88, 62), 
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ListenableBuilder(
                  listenable: _viewModel,
                  builder: (context, child) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: _viewModel.categories.map((category) {
                          bool isSelected =
                              _viewModel.selectedCategory == category;
                          return GestureDetector(
                            onTap: () => _viewModel.setCategory(category),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFFEED5DB)
                                    : Colors.transparent,
                                border: isSelected
                                    ? Border.all(
                                        color: const Color(0xFFCA748D),
                                        width: 1.5,
                                      )
                                    : Border.all(color: Colors.white54),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                category,
                                style: TextStyle(
                                  color: isSelected
                                      ? const Color(0xFFCA748D)
                                      : Colors.white,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListenableBuilder(
                    listenable: _viewModel,
                    builder: (context, child) {
                      if (_viewModel.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      }

                      if (_viewModel.menus.isEmpty) {
                        return const Center(
                          child: Text(
                            "Data menu tidak ditemukan.",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.only(
                          left: 25,
                          right: 25,
                          bottom: 100,
                        ),
                        physics: const BouncingScrollPhysics(),
                        itemCount: _viewModel.menus.length,
                        itemBuilder: (context, index) {
                          final menu = _viewModel.menus[index];
                          return FadeTransition(
                            opacity: _fadeAnim,
                            child: _buildMenuCard(menu),
                          );
                        },
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
  }

  Widget _buildMenuCard(MenuModel menu) {
    final isInactive = !menu.isActive;

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Opacity(
        opacity: isInactive ? 0.4 : 1.0,
        child: AbsorbPointer(
          absorbing: isInactive,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminPreviewMenuView(menu: menu),
                ),
              );
            },
            child: Container(
              width: 338,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFFDFDFD),
                borderRadius: BorderRadius.circular(16.69),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 4,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                clipBehavior: Clip.none, 
                children: [
                  // ✅ Background gambar di kiri
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      width: 113,
                      height: 100,
                      decoration: ShapeDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            menu.imageUrl ?? 'https://placehold.co/113x100',
                          ),
                          fit: BoxFit.cover,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16.69),
                            bottomLeft: Radius.circular(16.69),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    left: 118,
                    top: 6,
                    right: 50,
                    child: Text(
                      menu.name,
                      style: const TextStyle(
                        color: Color(0xFF2D4839),
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w800,
                        height: 1.10,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis, 
                    ),
                  ),

                  Positioned(
                    left: 118,
                    top: 28,
                    right: 50, 
                    child: Text(
                      menu.description,
                      style: const TextStyle(
                        color: Color(0xFF51725F),
                        fontSize: 10,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: 1.20,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  Positioned(
                    left: 118,
                    top: 50,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Stock: ',
                            style: TextStyle(
                              color: Color(0xFF51725F),
                              fontSize: 10,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: isInactive
                                ? 'Nonaktif'
                                : menu.stock.toString(),
                            style: TextStyle(
                              color: (menu.stock <= 5 && !isInactive)
                                  ? const Color(0xFFC23437)
                                  : const Color(0xFF51725F),
                              fontSize: 10,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Positioned(
                    left: 118,
                    bottom: 8,
                    child: Text(
                      _viewModel.formatCurrency(menu.price),
                      style: const TextStyle(
                        color: Color(0xFF2D4839),
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),

                if (!isInactive)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdminEditMenuView(menu: menu),
                              ),
                            );
                          },
                          child: SvgPicture.asset(
                            'assets/images/Pencil.svg',
                            width: 14,
                            height: 14,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFF426E55),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => _showDeleteDialog(menu),
                          child: SvgPicture.asset(
                            'assets/images/sampah.svg',
                            width: 14,
                            height: 14,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFF426E55),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ],
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
}