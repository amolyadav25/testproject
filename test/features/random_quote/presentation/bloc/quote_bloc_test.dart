import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_project/features/random_quote/domain/entity/quote_entity.dart';
import 'package:test_project/features/random_quote/domain/usecase/get_random_quote_use_case.dart';
import 'package:test_project/features/random_quote/presentation/bloc/quote_bloc.dart';


class MockGetRandomQuoteUseCase extends Mock implements GetRandomQuoteUseCase {}

void main() {
  group('QuoteBloc', () {
    late QuoteBloc quoteBloc;
    late MockGetRandomQuoteUseCase mockGetRandomQuoteUseCase;

    setUp(() {
      mockGetRandomQuoteUseCase = MockGetRandomQuoteUseCase();
      quoteBloc = QuoteBloc(mockGetRandomQuoteUseCase);
    });

    tearDown(() {
      quoteBloc.close();
    });

    test('initial state is QuoteInitial', () {
      expect(quoteBloc.state, equals(const QuoteInitial()));
    });

    blocTest<QuoteBloc, QuoteState>(
      'emits [QuoteLoading, QuoteLoaded] when fetchRandomQuote is called',
      build: () {
        when(() => mockGetRandomQuoteUseCase.execute())
            .thenAnswer((_) async => QuoteEntity(
          id: '1',
          content: 'Sample quote content',
          author: 'Sample Author',
          tags: ['tag1', 'tag2'],
          authorSlug: 'sample-author',
          length: 42,
          dateAdded: '2022-01-01',
          dateModified: '2022-01-02',
        ));
        return quoteBloc;
      },
      act: (bloc) => bloc.fetchRandomQuote(),
      expect: () => [
        equals(const QuoteLoading()),
        isA<QuoteLoaded>(),
      ],
    );

    blocTest<QuoteBloc, QuoteState>(
      'emits [QuoteLoading, QuoteError] when fetchRandomQuote fails',
      build: () {
        when(() => mockGetRandomQuoteUseCase.execute())
            .thenThrow(Exception('Failed to load quote'));
        return quoteBloc;
      },
      act: (bloc) => bloc.fetchRandomQuote(),
      expect: () => [
        equals(const QuoteLoading()),
        equals(const QuoteError('Failed to load quote')),
      ],
    );
  });
}
