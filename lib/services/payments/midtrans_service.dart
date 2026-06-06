import 'dart:convert';
import 'package:http/http.dart' as http;

class MidtransService {
  final String serverKey = 'SB-Mid-server-n0ukjAQcexUfV9wRLqyV01oE';

  Future<String?> createTransaction({
    required String orderId,
    required int grossAmount,
    required String customerName,
    required String customerPhone,
  }) async {
    final String url = 'https://app.sandbox.midtrans.com/snap/v1/transactions';

    final String basicAuth = base64Encode(utf8.encode('$serverKey:'));

    final Map<String, dynamic> body = {
      "transaction_details": {
        "order_id": orderId, // Harus unik untuk setiap transaksi
        "gross_amount": grossAmount,
      },
      "customer_details": {"first_name": customerName, "phone": customerPhone},
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Basic $basicAuth',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['redirect_url'];
      } else {
        throw Exception('Gagal membuat transaksi Midtrans: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error Midtrans API: $e');
    }
  }
}
