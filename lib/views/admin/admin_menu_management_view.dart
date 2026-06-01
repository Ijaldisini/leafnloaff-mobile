import 'package:flutter/material.dart';
import '../../viewmodels/admin_menu_management_viewmodel.dart';
import '../../models/menu_model.dart';
import '../admin/admin_add_menu_view.dart';
import '../admin/admin_edit_menu_view.dart';

class AdminMenuManagementView extends StatefulWidget {
  const AdminMenuManagementView({super.key});

  @override
  State<AdminMenuManagementView> createState() =>
      _AdminMenuManagementViewState();
}

class _AdminMenuManagementViewState extends State<AdminMenuManagementView> {
  final AdminMenuManagementViewModel _viewModel =
      AdminMenuManagementViewModel();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF3D5A4A),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, child) {
          return Stack(
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
                child: _viewModel.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFCA748D),
                        ),
                      )
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(25, 20, 25, 120),
                        physics: const BouncingScrollPhysics(),
                        children: [
                          const Text(
                            'Menu Management',
                            style: TextStyle(
                              color: Color(0xFFFDFDFD),
                              fontSize: 25,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w800,
                              shadows: [
                                Shadow(
                                  offset: Offset(2, 2),
                                  blurRadius: 4,
                                  color: Color(0x3F000000),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 36,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFFFDFDFD),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        103.61,
                                      ),
                                    ),
                                    shadows: const [
                                      BoxShadow(
                                        color: Color(0x3F000000),
                                        blurRadius: 4,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 28,
                                        height: 28,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF426E55),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.search,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: TextField(
                                          onChanged: (value) {
                                            _viewModel.searchMenu(value);
                                          },
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Search menu...',
                                            hintStyle: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              GestureDetector(
                                onTap: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const AdminAddMenuView(),
                                    ),
                                  );

                                  if (result == true) {
                                    _viewModel.fetchMenus();
                                  }
                                },
                                child: Container(
                                  width: 37,
                                  height: 37,
                                  decoration: ShapeDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.bottomRight,
                                      end: Alignment.topLeft,
                                      colors: [
                                        Color(0xFF73986F),
                                        Color(0xFFFDFDFD),
                                      ],
                                    ),
                                    shape: const CircleBorder(),
                                    shadows: const [
                                      BoxShadow(
                                        color: Color(0x3F000000),
                                        blurRadius: 4,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.add,
                                      color: Color(0xFF2D4839),
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          SizedBox(
                            height: 28,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _viewModel.categories.length,
                              itemBuilder: (context, index) {
                                final category = _viewModel.categories[index];
                                final isActive =
                                    _viewModel.selectedCategory == category;

                                return GestureDetector(
                                  onTap: () => _viewModel.setCategory(category),
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    alignment: Alignment.center,
                                    decoration: ShapeDecoration(
                                      color: isActive
                                          ? const Color(0xFFCA748D)
                                          : Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                          width: 1,
                                          color: Color(0xFFFDFDFD),
                                        ),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                    ),
                                    child: Text(
                                      category,
                                      style: const TextStyle(
                                        color: Color(0xFFFDFDFD),
                                        fontSize: 12,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 25),

                          ..._viewModel.menus.map(
                            (menu) => _buildMenuCard(menu),
                          ),
                        ],
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMenuCard(MenuModel menu) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 105,
      decoration: ShapeDecoration(
        color: const Color(0xFFFDFDFD),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.69),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16.69),
              bottomLeft: Radius.circular(16.69),
            ),
            child: SizedBox(
              width: 113,
              height: double.infinity,
              child: menu.imageUrl != null && menu.imageUrl!.isNotEmpty
                  ? Image.network(
                      menu.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade300,
                          child: const Center(
                            child: Icon(
                              Icons.broken_image,
                              color: Colors.grey,
                              size: 28,
                            ),
                          ),
                        );
                      },
                    )
                  : Container(color: Colors.grey.shade300),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          menu.name,
                          style: TextStyle(
                            color: menu.isActive
                                ? const Color(0xFF2D4839)
                                : Colors.grey,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w800,
                            decoration: menu.isActive
                                ? TextDecoration.none
                                : TextDecoration.lineThrough,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AdminEditMenuView(menu: menu),
                            ),
                          );

                          if (result == true) {
                            _viewModel.fetchMenus();
                          }
                        },
                        child: const Icon(
                          Icons.edit_outlined,
                          color: Color(0xFF2D4839),
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext dialogContext) {
                              return AlertDialog(
                                title: const Text('Hapus Menu'),
                                content: Text(
                                  'Apakah Anda yakin ingin menghapus ${menu.name}?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(dialogContext),
                                    child: const Text(
                                      'Batal',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(dialogContext);
                                      _viewModel.deleteMenu(menu.id, context);
                                    },
                                    child: const Text(
                                      'Hapus',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Icon(
                          Icons.delete_outline,
                          color: Color(0xFF2D4839),
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),

                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Description: ',
                          style: TextStyle(
                            color: Color(0xFF51725F),
                            fontSize: 9,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: menu.description,
                          style: const TextStyle(
                            color: Color(0xFF51725F),
                            fontSize: 9,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),

                  Text.rich(
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
                          text: '${menu.stock}',
                          style: TextStyle(
                            color: menu.stock == 0
                                ? Colors.red
                                : const Color(0xFF51725F),
                            fontSize: 10,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _viewModel.formatCurrency(menu.price),
                        style: const TextStyle(
                          color: Color(0xFF2D4839),
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (!menu.isActive)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD1D2),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: const Color(0xFFC33537),
                              width: 0.5,
                            ),
                          ),
                          child: const Text(
                            'Nonaktif',
                            style: TextStyle(
                              color: Color(0xFFC33537),
                              fontSize: 8,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
