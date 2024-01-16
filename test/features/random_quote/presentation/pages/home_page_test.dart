import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:test_project/features/random_quote/domain/entity/quote_entity.dart';
import 'package:test_project/features/random_quote/domain/usecase/get_random_quote_use_case.dart';
import 'package:test_project/features/random_quote/presentation/bloc/quote_bloc.dart';
import 'package:test_project/features/random_quote/presentation/pages/home_page.dart';

class MockGetRandomQuoteUseCase extends Mock implements GetRandomQuoteUseCase {}

void main() {
  group('HomePage', () {
    late QuoteBloc quoteBloc;
    late MockGetRandomQuoteUseCase mockGetRandomQuoteUseCase;

    setUp(() {
      mockGetRandomQuoteUseCase = MockGetRandomQuoteUseCase();
      quoteBloc = QuoteBloc(mockGetRandomQuoteUseCase);
    });

    tearDown(() {
      quoteBloc.close();
    });

    testWidgets('Renders Loading State', (WidgetTester tester) async {
      when(() => mockGetRandomQuoteUseCase.execute()).thenAnswer(
        (_) async => QuoteEntity(
          id: '1',
          content: 'Sample quote content',
          author: 'Sample Author',
          tags: ['tag1', 'tag2'],
          authorSlug: 'sample-author',
          length: 42,
          dateAdded: '2022-16-01',
          dateModified: '2022-01-02',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: quoteBloc,
            child: const HomePage(),
          ),
        ),
      );

      expect(find.byType(Center), findsNWidgets(2));
    });

    testWidgets('Renders Loaded State', (WidgetTester tester) async {
      when(() => mockGetRandomQuoteUseCase.execute()).thenAnswer(
        (_) async => QuoteEntity(
          id: '1',
          content: 'Sample quote content',
          author: 'Sample Author',
          tags: ['tag1', 'tag2'],
          authorSlug: 'sample-author',
          length: 42,
          dateAdded: '2022-01-01',
          dateModified: '2022-01-02',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: quoteBloc,
            child: const HomePage(),
          ),
        ),
      );

      quoteBloc.fetchRandomQuote();

      await tester.pumpAndSettle();

      expect(find.text('Sample quote content'), findsOneWidget);
      expect(find.text('- Sample Author'), findsOneWidget);
    });

    testWidgets('Renders Error State', (WidgetTester tester) async {
      when(() => mockGetRandomQuoteUseCase.execute())
          .thenThrow(Exception('Failed to load quote'));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: quoteBloc,
            child: const HomePage(),
          ),
        ),
      );

      quoteBloc.fetchRandomQuote();

      await tester.pumpAndSettle();

      expect(find.text('Error: Failed to load quote'), findsOneWidget);
    });
  });
}
