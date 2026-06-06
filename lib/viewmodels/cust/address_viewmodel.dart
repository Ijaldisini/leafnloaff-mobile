import 'package:flutter/foundation.dart';
import '../../services/cust/address_service.dart';

class AddressViewModel extends ChangeNotifier {
  final AddressService _service = AddressService();

  bool isLoading = false;
  String? errorMessage;
  List<Map<String, dynamic>> addresses = [];

  Future<void> fetchAddresses() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      addresses = await _service.fetchUserAddresses();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void openMaps(double? lat, double? long) {
    if (lat != null && long != null) {
      if (kDebugMode) {
        print('Membuka maps pada koordinat: $lat, $long');
      }
    }
  }

  Future<void> deleteAddress(String id) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _service.deleteAddress(id);
      await fetchAddresses();
    } catch (e) {
      errorMessage = "Gagal menghapus alamat: $e";
      isLoading = false;
      notifyListeners();
    }
  }
}
