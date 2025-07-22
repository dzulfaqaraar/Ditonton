import 'package:core/core.dart';
import 'package:core/presentation/bloc/bloc_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search/presentation/bloc/search_bloc.dart';

class SearchPage extends StatelessWidget {
  final bool isMovies;
  const SearchPage({super.key, required this.isMovies});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isMovies
            ? const Text('Search Movies')
            : const Text('Search TV Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (query) {
                if (isMovies) {
                  context.read<SearchBloc>().add(OnQueryChangedMovie(query));
                } else {
                  context.read<SearchBloc>().add(OnQueryChangedTvSeries(query));
                }
              },
              decoration: const InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: 16),
            Text('Search Result', style: titleLarge),
            isMovies ? listMovies() : listTvSeries(),
          ],
        ),
      ),
    );
  }

  Widget listMovies() {
    return BlocBuilder<SearchBloc, BlocState>(
      builder: (context, state) {
        if (state is BlocLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is BlocHasData<List<Movie>>) {
          final result = state.result;

          if (result.isEmpty) {
            return Expanded(
              child: Center(child: Text('No data', style: titleLarge)),
            );
          } else {
            return Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  final movie = result[index];
                  return MovieCard(movie: movie);
                },
                itemCount: result.length,
              ),
            );
          }
        } else if (state is BlocError) {
          return Expanded(
            child: Center(
              key: const Key('error_message'),
              child: Text(state.message),
            ),
          );
        } else {
          return Expanded(child: Container());
        }
      },
    );
  }

  Widget listTvSeries() {
    return BlocBuilder<SearchBloc, BlocState>(
      builder: (context, state) {
        if (state is BlocLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is BlocHasData<List<TvSeries>>) {
          final result = state.result;

          if (result.isEmpty) {
            return Expanded(
              child: Center(child: Text('No data', style: titleLarge)),
            );
          } else {
            return Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  final tvSeries = result[index];
                  return TvSeriesCard(tvSeries: tvSeries);
                },
                itemCount: result.length,
              ),
            );
          }
        } else if (state is BlocError) {
          return Expanded(
            child: Center(
              key: const Key('error_message'),
              child: Text(state.message),
            ),
          );
        } else {
          return Expanded(child: Container());
        }
      },
    );
  }
}
