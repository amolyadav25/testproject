

import '../entity/quote_entity.dart';
import '../repository/quote_repository.dart';

class GetRandomQuoteUseCase {
  final QuoteRepository quoteRepository;

  GetRandomQuoteUseCase(this.quoteRepository);

  Future<QuoteEntity> execute() async {
    try {
      final quoteEntity = await quoteRepository.getRandomQuote();
      return quoteEntity;
    } catch (e) {
      throw Exception('Failed to execute getRandomQuote use case: $e');
    }
  }
}
