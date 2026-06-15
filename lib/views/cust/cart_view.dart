import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../viewmodels/cust/cart_viewmodel.dart';
import '../../models/cart_model.dart';
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
                          if (_viewModel.selectedItemIds.isEmpty) {
                            return const SizedBox.shrink();
                          }
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
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.shopping_cart_outlined,
                                size: 80,
                                color: Colors.white38,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Keranjang Anda masih kosong',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tambahkan menu favoritmu sekarang!',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
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
                          return _buildCartItem(_viewModel.cartItems[index]);
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
                          fontSize: 16,
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
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),

                          GestureDetector(
                            onTap: _viewModel.selectedItemIds.isEmpty
                                ? null
                                : () async {
                                    final errorMsg = await _viewModel
                                        .validateStockBeforeCheckout();

                                    if (errorMsg != null) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              errorMsg,
                                              style: const TextStyle(
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                            backgroundColor: const Color(
                                              0xFFC23437,
                                            ),
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            margin: const EdgeInsets.fromLTRB(
                                              16,
                                              0,
                                              16,
                                              16,
                                            ),
                                          ),
                                        );
                                      }
                                    } else {
                                      if (context.mounted) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const CheckoutView(),
                                          ),
                                        ).then((_) {
                                          _viewModel.loadCartData();
                                        });
                                      }
                                    }
                                  },
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

  Widget _buildCartItem(CartItemModel item) {
    final isSelected = _viewModel.selectedItemIds.contains(item.id);

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
                  item.menuImageUrl ?? 'https://placehold.co/113x100',
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
                  onTap: () => _viewModel.toggleSelection(item.id),
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
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.menuName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF2D4839),
                                fontSize: 18,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w800,
                                height: 1.1,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () =>
                                _showEditNotesDialog(item.id, item.notes ?? ''),
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
                                  fontSize: 11,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(
                                text:
                                    item.notes != null && item.notes!.isNotEmpty
                                    ? item.notes
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
                          Expanded(
                            child: Text(
                              _formatCurrency(item.menuPrice),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF2D4839),
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () => _viewModel.decrementQuantity(
                                  item.id,
                                  item.quantity,
                                ),
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF2D4839),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.remove,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                item.quantity.toString(),
                                style: const TextStyle(
                                  color: Color(0xFF2D4839),
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => _viewModel.incrementQuantity(
                                  item.id,
                                  item.quantity,
                                ),
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF2D4839),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    size: 16,
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

                Positioned(
                  right: 250,
                  top: 0,
                  bottom: 0,
                  width: 100,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [Color(0xFFFDFDFD), Color(0x00FDFDFD)],
                      ),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16.69),
                        bottomRight: Radius.circular(16.69),
                      ),
                    ),
                  ),
                ),
              ],
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Hapus Item',
            style: TextStyle(
              color: Color(0xFF2D4839),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Text(
            'Hapus ${_viewModel.selectedItemIds.length} item dari keranjang?',
            style: const TextStyle(fontFamily: 'Poppins'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Batal',
                style: TextStyle(color: Colors.grey, fontFamily: 'Poppins'),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _viewModel.deleteSelected();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC23437),
              ),
              child: const Text(
                'Hapus',
                style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Edit Notes',
            style: TextStyle(
              color: Color(0xFF2D4839),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w800,
            ),
          ),
          content: TextField(
            controller: notesController,
            maxLines: 3,
            decoration: const InputDecoration(hintText: 'Tuliskan catatan...'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _viewModel.saveNotes(cartId, notesController.text.trim());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCA748D),
              ),
              child: const Text(
                'Simpan',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
