import 'package:dio/dio.dart';

class PaymentService {
  final Dio _dio = Dio();

  static const apiUrl = 'https://api.mercadopago.com/v1';

  Future<List<Map<String, dynamic>>> fetchPaymentMethods() async {
    try {
      final response = await _dio.get(
        '$apiUrl/payment_methods',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer SEU_TOKEN_AQUI',
          },
        ),
      );

      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      print('Error fetching payment methods: $e');
      throw e;
    }
  }

  Future<Map<String, dynamic>> makePayment(Map<String, dynamic> requestBody) async {
    try {
      final response = await _dio.post(
        '$apiUrl/payments',
        data: requestBody,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'X-Idempotency-Key': '0d5020ed-1af6-469c-ae06-c3bec19954bb',
            'Authorization': 'Bearer YOUR_ACCESS_TOKEN', // Replace with your Mercado Pago access token
          },
        ),
      );

      return response.data;
    } catch (error) {
      print('Error making payment: $error');
      throw error;
    }
  }
}
