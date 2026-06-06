import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../services/maps/maps_service.dart';
import '../../services/cust/address_service.dart';

import 'home_viewmodel.dart';
import 'address_viewmodel.dart';

class FormAddressViewModel extends ChangeNotifier {
  final MapsService _mapsService = MapsService();
  final AddressService _addressService = AddressService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool isLoading = false;
  bool isSaving = false;
  String? errorMessage;

  LatLng selectedLocation = const LatLng(-8.1689, 113.7020);
  GoogleMapController? mapController;

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

  void zoomIn() {
    mapController?.animateCamera(CameraUpdate.zoomIn());
  }

  void zoomOut() {
    mapController?.animateCamera(CameraUpdate.zoomOut());
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

  Future<void> _updateAddressText(double lat, double lng) async {
    final addressText = await _mapsService.getAddressFromLatLng(lat, lng);
    addressController.text = addressText;
    notifyListeners();
  }

  Future<bool> saveAddressToDatabase() async {
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
      final newAddress = {
        'recipient_name': nameController.text.trim(),
        'phone_number': phoneController.text.trim(),
        'address_detail': addressController.text.trim(),
        'latitude': selectedLocation.latitude,
        'longitude': selectedLocation.longitude,
      };

      await _addressService.saveNewAddress(newAddress);

      HomeViewModel().fetchHomeData();
      AddressViewModel().fetchAddresses();

      return true;
    } catch (e) {
      errorMessage = "Gagal menyimpan alamat: $e";
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
