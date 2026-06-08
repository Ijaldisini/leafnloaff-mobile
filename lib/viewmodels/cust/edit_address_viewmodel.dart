import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../services/maps/maps_service.dart';
import '../../services/cust/address_service.dart';
import 'home_viewmodel.dart';
import 'address_viewmodel.dart';

class EditAddressViewModel extends ChangeNotifier {
  final MapsService _mapsService = MapsService();
  final AddressService _addressService = AddressService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  late String addressId;
  bool isLoading = false;
  bool isSaving = false;
  String? errorMessage;

  LatLng selectedLocation = const LatLng(-8.1689, 113.7020);
  GoogleMapController? mapController;

  void initData(Map<String, dynamic> existingAddress) {
    addressId = existingAddress['id'];
    nameController.text = existingAddress['recipient_name'] ?? '';
    phoneController.text = existingAddress['phone_number'] ?? '';
    addressController.text = existingAddress['address_detail'] ?? '';

    selectedLocation = LatLng(
      existingAddress['latitude'] ?? -8.1689,
      existingAddress['longitude'] ?? 113.7020,
    );
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void onCameraMove(CameraPosition position) {
    selectedLocation = position.target;
  }

  Future<void> onCameraIdle() async {
    await _updateAddressText(
      selectedLocation.latitude,
      selectedLocation.longitude,
    );
  }

  Future<void> fetchCurrentLocation() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final position = await _mapsService.getCurrentLocation();

      await mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          16.0,
        ),
      );
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void zoomIn() {
    mapController?.animateCamera(CameraUpdate.zoomIn());
  }

  void zoomOut() {
    mapController?.animateCamera(CameraUpdate.zoomOut());
  }

  Future<void> _updateAddressText(double lat, double lng) async {
    final addressText = await _mapsService.getAddressFromLatLng(lat, lng);
    addressController.text = addressText;
    notifyListeners();
  }

  Future<bool> updateAddressToDatabase() async {
    if (nameController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty) {
      errorMessage = "Semua kolom harus diisi";
      notifyListeners();
      return false;
    }

    isSaving = true;
    errorMessage = null;
    notifyListeners();

    try {
      final updatedData = {
        'recipient_name': nameController.text.trim(),
        'phone_number': phoneController.text.trim(),
        'address_detail': addressController.text.trim(),
        'latitude': selectedLocation.latitude,
        'longitude': selectedLocation.longitude,
      };

      await _addressService.updateAddress(addressId, updatedData);

      HomeViewModel().fetchHomeData();
      AddressViewModel().fetchAddresses();

      return true;
    } catch (e) {
      errorMessage = "Gagal memperbarui alamat: $e";
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    mapController?.dispose();
    super.dispose();
  }
}
