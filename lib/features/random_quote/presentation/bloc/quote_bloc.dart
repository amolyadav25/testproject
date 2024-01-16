import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entity/quote_entity.dart';
import '../../domain/usecase/get_random_quote_use_case.dart';
part 'quote_state.dart';

class QuoteBloc extends Cubit<QuoteState> {
  final GetRandomQuoteUseCase getRandomQuoteUseCase;

  QuoteBloc(this.getRandomQuoteUseCase) : super(const QuoteInitial());

  Future<void> fetchRandomQuote() async {
    emit(const QuoteLoading());
    try {
      final quoteEntity = await getRandomQuoteUseCase.execute();
      emit(QuoteLoaded(quoteEntity));
    } catch (e) {
      emit(const QuoteError('Failed to load quote'));
    }
  }
}
