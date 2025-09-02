import 'package:dio/dio.dart';

class NewTripApiServices {
  final Dio _dio;

  NewTripApiServices() : _dio = Dio(
    BaseOptions(
      baseUrl: 'http://api.codeplusdev.ir',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  Future<Response> callNewTripApi({
    required String passengerId,
    required String origin,
    required String destination,
  }) async {
    try {
      final response = await _dio.post(
        '/api/trips/newTrip/$passengerId',
        data: {
          'passenger_id': passengerId,
          'origin': origin,
          'destination': destination,
        },
      );
      return response;
    } on DioException catch (e) {
      print('Error in callNewTripApi: ${e.message}');
      if (e.response != null) {
        print('Error response data: ${e.response?.data}');
        print('Error status code: ${e.response?.statusCode}');
      }
      rethrow;
    }
  }
}