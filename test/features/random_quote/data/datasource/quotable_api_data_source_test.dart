import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_project/core/network/api_client.dart';
import 'package:test_project/core/network/api_path.dart';
import 'package:test_project/features/random_quote/data/datasource/quotable_api_data_source.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  group('QuotableApiDataSource', () {
    late QuotableApiDataSource dataSource;
    late MockApiClient mockApiClient;

    setUp(() {
      mockApiClient = MockApiClient();
      dataSource = QuotableApiDataSource(mockApiClient);
    });

    test('getRandomQuote returns a map on success', () async {
      when(() => mockApiClient.getRequest(ApiPath.randomUrl))
          .thenAnswer((_) async => {'key': 'test'});

      final result = await dataSource.getRandomQuote();

      expect(result, {'key': 'test'});
      verify(() => mockApiClient.getRequest(ApiPath.randomUrl)).called(1);
    });

  });
}
