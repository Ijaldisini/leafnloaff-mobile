import 'package:flutter/foundation.dart';
import '../../services/cust/address_service.dart';
import 'package:url_launcher/url_launcher.dart';

class AddressViewModel extends ChangeNotifier {
  static final AddressViewModel _instance = AddressViewModel._internal();
  factory AddressViewModel() => _instance;
  AddressViewModel._internal();

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

  Future<void> openMaps(double? lat, double? long) async {
    if (lat != null && long != null) {
      final Uri url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$lat,$long',
      );

      try {
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          debugPrint('Could not launch maps');
        }
      } catch (e) {
        debugPrint('Error opening maps: $e');
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
