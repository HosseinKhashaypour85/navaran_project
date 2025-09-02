import 'package:dio/dio.dart';
import 'package:navaran_project/features/map_features/model/new_trip_model.dart';
import 'package:navaran_project/features/map_features/services/new_trip_api_services.dart';

class NewTripApiRepository {
  final NewTripApiServices _apiServices;

  NewTripApiRepository() : _apiServices = NewTripApiServices();

  Future<NewTripModel> callNewTripApiRepository({
    required String passengerId,
    required String origin,
    required String destination,
  }) async {
    try {
      final response = await _apiServices.callNewTripApi(
        passengerId: passengerId,
        origin: origin,
        destination: destination,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return NewTripModel.fromJson(response.data);
      } else {
        throw Exception(
          'Server error: ${response.statusCode} - ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      print('DioError in repository: ${e.message}');
      if (e.response != null) {
        print('Error response: ${e.response?.data}');
        throw Exception('Server responded with ${e.response?.statusCode}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('Failed to create new trip');
    }
  }
}