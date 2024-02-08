import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PaymentService {
  final Dio _dio = Dio();
  final String _kApiUrl = 'https://api.stripe.com/v1';

  Future<Map<String, dynamic>> callNoWebhookPayEndpointIntentId({
    required String paymentIntentId,
  }) async {
    try {
      final response = await _dio.post(
        '$_kApiUrl/charge-card-off-session',
        options: Options(
          receiveTimeout: Duration(seconds: 60),
          headers: {
            'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
            'Content-Type': 'application/json',
          },
        ),
        data: {'paymentIntentId': paymentIntentId},
      );

      return response.data;
    } catch (error) {
      // Handle DioError or other exceptions here
      print('Error in callNoWebhookPayEndpointIntentId: $error');
      throw error;
    }
  }

  Future<Map<String, dynamic>> callNoWebhookPayEndpointMethodId({
    required bool useStripeSdk,
    required String paymentMethodId,
    required String currency,
    List<String>? items,
  }) async {
    final url = '$_kApiUrl/payment_intents';

    Map<String, dynamic> body = {
      "amount": 2000,
      "currency": "usd",
    };

    try {
      final response = await _dio.post(
        url,
        options: Options(
          receiveTimeout: Duration(seconds: 60),
          headers: {
            'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
            'Content-Type': 'application/x-www-form-urlencoded'
          },
        ),
        data: body,
      );

      return response.data;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout) {
        debugPrint(
            'Error in callNoWebhookPayEndpointMethodId - Connection Time Out: $error');
      }
      if (error.type == DioExceptionType.receiveTimeout) {
        debugPrint(
            'Error in callNoWebhookPayEndpointMethodId - Receive Time Out: $error');
      }
      throw error;
    }
  }
}
