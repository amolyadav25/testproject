import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/core/network/api_client.dart';

import 'features/random_quote/data/datasource/quotable_api_data_source.dart';
import 'features/random_quote/data/repository/quote_repository_impl.dart';
import 'features/random_quote/domain/usecase/get_random_quote_use_case.dart';
import 'features/random_quote/presentation/bloc/quote_bloc.dart';
import 'features/random_quote/presentation/pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Project',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => QuoteBloc(
          GetRandomQuoteUseCase(
            QuotableRepositoryImpl(
              QuotableApiDataSource(
                  ApiClient()
              ),
            ),
          ),
        ),
        child: const HomePage(),
      ),
    );
  }
}


