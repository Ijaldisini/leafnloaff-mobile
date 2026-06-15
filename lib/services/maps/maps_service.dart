import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class MapsService {
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Layanan lokasi dinonaktifkan.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Izin lokasi ditolak.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Izin lokasi ditolak secara permanen, kami tidak dapat meminta izin.',
      );
    }

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy
            .medium,
        timeLimit: const Duration(
          seconds: 10,
        ),
      );
    } catch (e) {
      throw Exception('Gagal mendapatkan lokasi (Sinyal lemah atau Timeout).');
    }
  }

  Future<String> getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return '${place.street}, ${place.subLocality}, ${place.locality}, ${place.subAdministrativeArea}';
      }
      return 'Alamat tidak ditemukan';
    } catch (e) {
      return 'Gagal mengambil alamat: $e';
    }
  }
}
