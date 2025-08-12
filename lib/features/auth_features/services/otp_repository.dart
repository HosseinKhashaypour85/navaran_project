import 'package:dio/dio.dart';
import 'package:navaran_project/features/auth_features/model/otp_response.dart';

class OtpRepository {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.64.22:2105',
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<OtpResponse> sendOtp(String mobile) async {
    try {
      final response = await _dio.post('/send-otp', data: {'phone': mobile});
      return OtpResponse.fromJson(response.data);
    } on DioException catch (e) {
      print('🧨 ERROR BODY: ${e.response?.data}');
      print('🧨 STATUS CODE: ${e.response?.statusCode}');
      throw Exception(e.response?.data['message'] ?? 'خطا در ارسال کد');
    }
  }
  Future<OtpResponse> verifyOtp(String mobile, String code) async {
    try {
      final response =
      await _dio.post('/verify-otp', data: {'phone': mobile, 'code': code});
      return OtpResponse.fromJson(response.data);
    } on DioException catch (e) {
      print('🧨 ERROR BODY: ${e.response?.data}');
      print('🧨 STATUS CODE: ${e.response?.statusCode}');
      throw Exception(e.response?.data['message'] ?? 'کد اشتباه است یا منقضی شده');
    }
  }
}
