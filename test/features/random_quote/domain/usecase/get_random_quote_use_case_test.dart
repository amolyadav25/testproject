import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_project/features/random_quote/domain/entity/quote_entity.dart';
import 'package:test_project/features/random_quote/domain/repository/quote_repository.dart';
import 'package:test_project/features/random_quote/domain/usecase/get_random_quote_use_case.dart';



class MockQuoteRepository extends Mock implements QuoteRepository {}

void main() {
  group('GetRandomQuoteUseCase', () {
    late GetRandomQuoteUseCase getRandomQuoteUseCase;
    late MockQuoteRepository mockQuoteRepository;

    setUp(() {
      mockQuoteRepository = MockQuoteRepository();
      getRandomQuoteUseCase = GetRandomQuoteUseCase(mockQuoteRepository);
    });

    test('execute returns QuoteEntity on success', () async {
      final expectedQuoteEntity = QuoteEntity(
        id: '1',
        content: 'Sample quote content',
        author: 'Sample Author',
        tags: ['tag1', 'tag2'],
        authorSlug: 'sample-author',
        length: 42,
        dateAdded: '2022-01-01',
        dateModified: '2022-01-02',
      );

      when(() => mockQuoteRepository.getRandomQuote())
          .thenAnswer((_) async => expectedQuoteEntity);

      final result = await getRandomQuoteUseCase.execute();

      expect(result, expectedQuoteEntity);
      verify(() => mockQuoteRepository.getRandomQuote()).called(1);
    });

    test('execute throws an exception on failure', () async {
      when(() => mockQuoteRepository.getRandomQuote())
          .thenThrow(Exception('Failed to load quote'));

      expect(() => getRandomQuoteUseCase.execute(), throwsException);
      verify(() => mockQuoteRepository.getRandomQuote()).called(1);
    });
  });
}
