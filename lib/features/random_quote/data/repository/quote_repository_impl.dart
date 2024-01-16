
import '../../domain/entity/quote_entity.dart';
import '../../domain/repository/quote_repository.dart';
import '../datasource/quotable_api_data_source.dart';
import '../model/quote_model.dart';

class QuotableRepositoryImpl implements QuoteRepository {
  final QuotableApiDataSource _remoteDataSource;

  QuotableRepositoryImpl(this._remoteDataSource);

  @override
  Future<QuoteEntity> getRandomQuote() async {
    try {
      final apiResponse = await _remoteDataSource.getRandomQuote();

      final quoteModel = QuoteModel.fromJson(apiResponse);
      final quoteEntity = quoteModel.toEntity();

      return quoteEntity;
    } catch (e) {
      throw Exception('Failed to load random quote');
    }
  }
}
