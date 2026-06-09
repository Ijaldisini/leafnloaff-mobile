import 'dart:convert';
import 'package:http/http.dart' as http;

class MidtransService {
  final String serverKey = const String.fromEnvironment('MIDTRANS_SERVER_KEY');

  Future<Map<String, dynamic>> createTransaction({
    required String orderId,
    required int grossAmount,
    required String customerName,
    required String customerPhone,
    required String bank,
  }) async {
    final String url = 'https://api.sandbox.midtrans.com/v2/charge';
    final String basicAuth = base64Encode(utf8.encode('$serverKey:'));

    Map<String, dynamic> body = {
      "transaction_details": {"order_id": orderId, "gross_amount": grossAmount},
      "customer_details": {"first_name": customerName, "phone": customerPhone},
      "custom_expiry": {"expiry_duration": 60, "unit": "minute"},
    };

    if (bank == 'echannel') {
      body["payment_type"] = "echannel";
      body["echannel"] = {"bill_info1": "Payment:", "bill_info2": "Order"};
    } else {
      body["payment_type"] = "bank_transfer";
      body["bank_transfer"] = {"bank": bank};
    }

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Basic $basicAuth',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal membuat transaksi: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> checkTransactionStatus(String orderId) async {
    final String url = 'https://api.sandbox.midtrans.com/v2/$orderId/status';
    final String basicAuth = base64Encode(utf8.encode('$serverKey:'));

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Basic $basicAuth',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 404) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal mengecek status transaksi: ${response.body}');
    }
  }
}
