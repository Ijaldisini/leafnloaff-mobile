import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../viewmodels/cust/edit_address_viewmodel.dart';

class EditAddressView extends StatefulWidget {
  final Map<String, dynamic> address;

  const EditAddressView({super.key, required this.address});

  @override
  State<EditAddressView> createState() => _EditAddressViewState();
}

class _EditAddressViewState extends State<EditAddressView> {
  final EditAddressViewModel _viewModel = EditAddressViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.initData(widget.address);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
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
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                      const Text(
                        'Edit Address',
                        style: TextStyle(
                          color: Color(0xFFFDFDFD),
                          fontSize: 25,
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

                Expanded(
                  child: ListenableBuilder(
                    listenable: _viewModel,
                    builder: (context, _) {
                      return ListView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25.0,
                          vertical: 10.0,
                        ),
                        children: [
                          if (_viewModel.errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(
                                _viewModel.errorMessage!,
                                style: const TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                          _buildLabel('Recipient’s Name'),
                          _buildTextField(
                            controller: _viewModel.nameController,
                            height: 45,
                          ),

                          _buildLabel('Address'),
                          _buildTextField(
                            controller: _viewModel.addressController,
                            height: 100,
                            maxLines: 4,
                          ),

                          _buildLabel('No. Whatsapp'),
                          _buildTextField(
                            controller: _viewModel.phoneController,
                            height: 45,
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 15),

                          Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: _viewModel.isLoading
                                  ? null
                                  : () => _viewModel.fetchCurrentLocation(),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xFFD699AB),
                                      Color(0xFFCA748D),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(75.06),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 4,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: _viewModel.isLoading
                                    ? const SizedBox(
                                        width: 15,
                                        height: 15,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        'Use current location',
                                        style: TextStyle(
                                          color: Color(0xFFFDFDFD),
                                          fontSize: 14,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          Container(
                            height: 213,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: const Color(0xFFCA748D),
                                width: 2,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(13),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  GoogleMap(
                                    initialCameraPosition: CameraPosition(
                                      target: _viewModel.selectedLocation,
                                      zoom: 16.0,
                                    ),
                                    onMapCreated: _viewModel.onMapCreated,
                                    onCameraMove: _viewModel.onCameraMove,
                                    onCameraIdle: _viewModel.onCameraIdle,
                                    myLocationEnabled: true,
                                    myLocationButtonEnabled: false,
                                    zoomControlsEnabled: false,
                                    gestureRecognizers: {
                                      Factory<OneSequenceGestureRecognizer>(
                                        () => EagerGestureRecognizer(),
                                      ),
                                    },
                                  ),
                                  IgnorePointer(
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: 35.0),
                                      child: Icon(
                                        Icons.location_on,
                                        size: 40,
                                        color: Color(0xFFC23437),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    right: 10,
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: _viewModel.zoomIn,
                                          child: Container(
                                            width: 35,
                                            height: 35,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.black26,
                                                  blurRadius: 4,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: const Icon(
                                              Icons.add,
                                              color: Color(0xFF2D4839),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        GestureDetector(
                                          onTap: _viewModel.zoomOut,
                                          child: Container(
                                            width: 35,
                                            height: 35,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.black26,
                                                  blurRadius: 4,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: const Icon(
                                              Icons.remove,
                                              color: Color(0xFF2D4839),
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
                          const SizedBox(height: 40),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  width: 130,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color(0xFFF26F71),
                                        Color(0xFFC23437),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(85.71),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 3,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'Discard',
                                    style: TextStyle(
                                      color: Color(0xFFFBFBFB),
                                      fontSize: 15,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: _viewModel.isSaving
                                    ? null
                                    : () async {
                                        final success = await _viewModel
                                            .updateAddressToDatabase();
                                        if (success && context.mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Alamat berhasil diperbarui!',
                                              ),
                                            ),
                                          );
                                          Navigator.pop(context, true);
                                        }
                                      },
                                child: Container(
                                  width: 130,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color(0xFFD699AB),
                                        Color(0xFFCA748D),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(85.71),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 3,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.center,
                                  child: _viewModel.isSaving
                                      ? const SizedBox(
                                          width: 15,
                                          height: 15,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text(
                                          'Save',
                                          style: TextStyle(
                                            color: Color(0xFFFBFBFB),
                                            fontSize: 15,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                        ],
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

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 15.0),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFFDFDFD),
          fontSize: 18,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700,
          shadows: [
            Shadow(offset: Offset(2, 2), blurRadius: 4, color: Colors.black26),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required double height,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFFDFDFD),
        borderRadius: BorderRadius.circular(maxLines > 1 ? 15 : 108.57),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 4)),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: const TextStyle(color: Color(0xFF2D4839), fontFamily: 'Poppins'),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: maxLines > 1 ? 15 : 10,
          ),
        ),
      ),
    );
  }
}
