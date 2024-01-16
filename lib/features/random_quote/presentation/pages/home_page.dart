import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/quote_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Random Quote'),
      ),
      body: BlocBuilder<QuoteBloc, QuoteState>(
        builder: (context, state) {
          if (state is QuoteLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is QuoteError) {
            return Text('Error: ${state.errorMessage}');
          } else if (state is QuoteLoaded) {
            final quoteEntity = state.quoteEntity;
            return SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        quoteEntity.content,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '- ${quoteEntity.author}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Press the button to load a quote'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<QuoteBloc>().fetchRandomQuote();
        },
        tooltip: 'Fetch Random Quote',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
