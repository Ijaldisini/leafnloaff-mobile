import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../viewmodels/cust/cart_viewmodel.dart';
import 'checkout_view.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final CartViewModel _viewModel = CartViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.loadCartData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String _formatCurrency(double amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 0,
    ).format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3D5A4A),
      body: Stack(
        children: [
          Positioned(
            left: -17,
            top: -30,
            child: Container(
              width: 422,
              height: 289,
              decoration: const BoxDecoration(color: Color(0xFFD699AB)),
            ),
          ),
          Positioned(
            left: -17,
            top: 147,
            child: Container(
              width: 422,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                  size: 22,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Your Location',
                                  style: TextStyle(
                                    color: Color(0xFFFDFDFD),
                                    fontSize: 19.17,
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
                            const SizedBox(height: 4),
                            ListenableBuilder(
                              listenable: _viewModel,
                              builder: (context, _) {
                                return Text(
                                  _viewModel.currentLocation,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: const Color(
                                      0xFFFDFDFD,
                                    ).withValues(alpha: 0.7),
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      ListenableBuilder(
                        listenable: _viewModel,
                        builder: (context, _) {
                          if (_viewModel.selectedItemIds.isEmpty)
                            return const SizedBox.shrink();
                          return IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: () => _showDeleteConfirmation(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                Expanded(
                  child: ListenableBuilder(
                    listenable: _viewModel,
                    builder: (context, _) {
                      if (_viewModel.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      }
                      if (_viewModel.errorMessage != null) {
                        return Center(
                          child: Text(
                            _viewModel.errorMessage!,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }
                      if (_viewModel.cartItems.isEmpty) {
                        return const Center(
                          child: Text(
                            'Keranjang Anda masih kosong.',
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
                          bottom: 200,
                        ),
                        physics: const BouncingScrollPhysics(),
                        itemCount: _viewModel.cartItems.length,
                        itemBuilder: (context, index) {
                          final item = _viewModel.cartItems[index];
                          return _buildCartItem(item);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ListenableBuilder(
              listenable: _viewModel,
              builder: (context, _) {
                return Container(
                  height: 190,
                  padding: const EdgeInsets.only(top: 20, left: 25, right: 25),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFD699AB), Color(0xFFCA748D)],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Payment',
                        style: TextStyle(
                          color: const Color(0xFFFDFDFD).withValues(alpha: 0.8),
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(
                              _formatCurrency(_viewModel.totalPayment),
                              style: const TextStyle(
                                color: Color(0xFFFDFDFD),
                                fontSize: 26,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: _viewModel.selectedItemIds.isEmpty
                                ? null
                                : () {Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const CheckoutView(),
                                      ),
                                    );},
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: _viewModel.selectedItemIds.isEmpty
                                      ? [Colors.grey, Colors.grey.shade600]
                                      : [
                                          const Color(0xFF51725F),
                                          const Color(0xFF2D4839),
                                        ],
                                ),
                                borderRadius: BorderRadius.circular(100),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Text(
                                'Checkout',
                                style: TextStyle(
                                  color: Color(0xFFFDFDFD),
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item) {
    final menu = item['menus'] as Map<String, dynamic>;
    final isSelected = _viewModel.selectedItemIds.contains(
      item['id'].toString(),
    );
    final price = (menu['price'] as num).toDouble();
    final qty = (item['quantity'] as num).toInt();
    final notes = item['notes'] as String?;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 125,
      decoration: BoxDecoration(
        color: const Color(0xFFFDFDFD),
        borderRadius: BorderRadius.circular(16.69),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.69),
                  bottomLeft: Radius.circular(16.69),
                ),
                child: Image.network(
                  menu['image_url'] ?? 'https://placehold.co/113x100',
                  width: 110,
                  height: 125,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 110,
                    height: 125,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.fastfood, color: Colors.grey),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: GestureDetector(
                  onTap: () =>
                      _viewModel.toggleSelection(item['id'].toString()),
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF2D4839)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF2D4839),
                        width: 2.5,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : null,
                  ),
                ),
              ),
            ],
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          menu['name'] ?? 'Unknown Item',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF2D4839),
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w800,
                            height: 1.1,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _showEditNotesDialog(
                          item['id'].toString(),
                          notes ?? '',
                        ),
                        child: const Icon(
                          Icons.edit_outlined,
                          size: 18,
                          color: Color(0xFF2D4839),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Notes: ',
                            style: TextStyle(
                              color: Color(0xFF51725F),
                              fontSize: 10,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: notes != null && notes.isNotEmpty
                                ? notes
                                : 'Tidak ada catatan.',
                            style: const TextStyle(
                              color: Color(0xFF51725F),
                              fontSize: 10,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatCurrency(price),
                        style: const TextStyle(
                          color: Color(0xFF2D4839),
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => _viewModel.decrementQuantity(
                              item['id'].toString(),
                              qty,
                            ),
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(
                                color: Color(
                                  0xFF2D4839,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.remove,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            qty.toString(),
                            style: const TextStyle(
                              color: Color(0xFF2D4839),
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => _viewModel.incrementQuantity(
                              item['id'].toString(),
                              qty,
                            ),
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(
                                color: Color(0xFF2D4839),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.add,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
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

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Color(0xFFC23437)),
              SizedBox(width: 10),
              Text(
                'Hapus Item',
                style: TextStyle(
                  color: Color(0xFF2D4839),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: Text(
            'Apakah Anda yakin ingin menghapus ${_viewModel.selectedItemIds.length} item dari keranjang?',
            style: const TextStyle(
              color: Color(0xFF51725F),
              fontFamily: 'Poppins',
              fontSize: 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Batal',
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _viewModel.deleteSelected();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC23437),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: const Text(
                'Hapus',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showEditNotesDialog(String cartId, String currentNotes) {
    final TextEditingController notesController = TextEditingController(
      text: currentNotes,
    );

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Edit Notes',
            style: TextStyle(
              color: Color(0xFF2D4839),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextField(
              controller: notesController,
              maxLines: 3,
              style: const TextStyle(
                color: Color(0xFF2D4839),
                fontFamily: 'Poppins',
                fontSize: 14,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Tuliskan permintaan khusus di sini...',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Batal',
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _viewModel.saveNotes(cartId, notesController.text.trim());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCA748D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: const Text(
                'Simpan',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
