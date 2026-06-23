import 'package:flutter/foundation.dart';
import '../../services/cust/address_service.dart';
import '../../models/address_model.dart';
import 'package:url_launcher/url_launcher.dart';

class AddressViewModel extends ChangeNotifier {
  final AddressService _service;

  AddressViewModel({required AddressService service}) : _service = service;

  bool isLoading = false;
  List<AddressModel> addresses = [];

  Future<void> fetchAddresses({Function(String)? onError}) async {
    isLoading = true;
    notifyListeners();

    try {
      addresses = await _service.fetchUserAddresses();
    } catch (e) {
      onError?.call(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> openMaps(double? lat, double? long) async {
    if (lat != null && long != null) {
      final Uri url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$lat,$long?q=$lat,$long',
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

  Future<void> deleteAddress(String id, {Function(String)? onError}) async {
    isLoading = true;
    notifyListeners();

    try {
      await _service.deleteAddress(id);
      await fetchAddresses(onError: onError);
    } catch (e) {
      isLoading = false;
      notifyListeners();
      onError?.call(e.toString());
    }
  }
}
