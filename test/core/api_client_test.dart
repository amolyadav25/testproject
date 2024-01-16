import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:test_project/core/network/api_client.dart';
import 'package:test_project/core/network/api_path.dart';

class MockDio extends Mock implements Dio {}

void main() {
  group('ApiClient', () {
    late ApiClient apiClient;
    late MockDio mockDio;

    setUp(() {
      mockDio = MockDio();
      apiClient = ApiClient(dio: mockDio);
    });

    test('getRequest returns a map on success', () async {
      final expectedResponse = {'key': 'value'};
      when(() => mockDio.get(any(), options: any(named: 'options'))).thenAnswer(
          (_) async => Response(
              data: expectedResponse,
              statusCode: 200,
              requestOptions: RequestOptions()));

      final result = await apiClient.getRequest(ApiPath.randomUrl);

      expect(result, expectedResponse);
      verify(() => mockDio.get(ApiPath.baseUrl + ApiPath.randomUrl,
          options: any(named: 'options'))).called(1);
    });

    test('getRequest throws an exception on failure', () async {
      when(() => mockDio.get(any(), options: any(named: 'options')))
          .thenThrow(DioException(
        response: Response(
            data: null, statusCode: 500, requestOptions: RequestOptions()),
        requestOptions: RequestOptions(),
      ));

      expect(() => apiClient.getRequest(ApiPath.randomUrl), throwsException);
      verify(() => mockDio.get(ApiPath.baseUrl + ApiPath.randomUrl,
          options: any(named: 'options'))).called(1);
    });
  });
}
