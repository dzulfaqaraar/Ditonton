import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search/presentation/bloc/search_bloc.dart';

class SearchPage extends StatelessWidget {
  final bool isMovies;
  const SearchPage({Key? key, required this.isMovies}) : super(key: key);

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
            Text(
              'Search Result',
              style: titleMedium,
            ),
            isMovies ? listMovies() : listTvSeries(),
          ],
        ),
      ),
    );
  }

  Widget listMovies() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is SearchHasDataMovie) {
          final result = state.result;

          if (result.isEmpty) {
            return Expanded(
              child: Center(
                child: Text(
                  'No data',
                  style: titleMedium,
                ),
              ),
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
        } else if (state is SearchError) {
          return Expanded(
            child: Center(
              key: const Key('error_message'),
              child: Text(state.message),
            ),
          );
        } else {
          return Expanded(
            child: Container(),
          );
        }
      },
    );
  }

  Widget listTvSeries() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is SearchHasDataTvSeries) {
          final result = state.result;

          if (result.isEmpty) {
            return Expanded(
              child: Center(
                child: Text(
                  'No data',
                  style: titleMedium,
                ),
              ),
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
        } else if (state is SearchError) {
          return Expanded(
            child: Center(
              key: const Key('error_message'),
              child: Text(state.message),
            ),
          );
        } else {
          return Expanded(
            child: Container(),
          );
        }
      },
    );
  }
}
