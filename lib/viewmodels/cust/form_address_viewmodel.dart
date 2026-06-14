import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../services/maps/maps_service.dart';
import '../../services/cust/address_service.dart';
import '../../models/address_model.dart';

class FormAddressViewModel extends ChangeNotifier {
  final MapsService _mapsService;
  final AddressService _addressService;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String? addressId;
  bool isLoading = false;
  bool isSaving = false;
  String? errorMessage;

  LatLng selectedLocation = const LatLng(-8.1689, 113.7020);
  GoogleMapController? mapController;

  FormAddressViewModel({
    required MapsService mapsService,
    required AddressService addressService,
  }) : _mapsService = mapsService,
       _addressService = addressService;

  void initData(AddressModel? existingAddress) {
    if (existingAddress != null) {
      addressId = existingAddress.id;
      nameController.text = existingAddress.recipientName;
      phoneController.text = existingAddress.phoneNumber;
      addressController.text = existingAddress.addressDetail;
      selectedLocation = LatLng(
        existingAddress.latitude,
        existingAddress.longitude,
      );
    }
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

  void zoomIn() => mapController?.animateCamera(CameraUpdate.zoomIn());
  void zoomOut() => mapController?.animateCamera(CameraUpdate.zoomOut());

  Future<void> _updateAddressText(double lat, double lng) async {
    final addressText = await _mapsService.getAddressFromLatLng(lat, lng);
    addressController.text = addressText;
    notifyListeners();
  }

  Future<bool> saveOrUpdateAddress() async {
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
      final addressData = {
        'recipient_name': nameController.text.trim(),
        'phone_number': phoneController.text.trim(),
        'address_detail': addressController.text.trim(),
        'latitude': selectedLocation.latitude,
        'longitude': selectedLocation.longitude,
      };

      if (addressId == null) {
        await _addressService.saveNewAddress(addressData);
      } else {
        await _addressService.updateAddress(addressId!, addressData);
      }

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
