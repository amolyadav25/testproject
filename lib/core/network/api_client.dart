import 'package:dio/dio.dart';
import 'api_path.dart';

class ApiClient {
  final Dio _dio;

  ApiClient({Dio? dio}) : _dio = dio ?? Dio();

  Future<Map<String, dynamic>> getRequest(String randomUrl) async {
    try {
      final response = await _dio.get(ApiPath.baseUrl + randomUrl);
      return response.data;
    } catch (e) {
      throw Exception('Failed to load');
    }
  }
}
