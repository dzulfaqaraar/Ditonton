import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/presentation/bloc/bloc_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/movies.dart';

class MoviePage extends StatefulWidget {
  const MoviePage({super.key});

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<MovieListBloc>().add(const OnFetchingList());
        context.read<PopularMoviesBloc>().add(const OnFetchingPopular());
        context.read<TopRatedMoviesBloc>().add(const OnFetchingTopRated());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Now Playing', style: titleLarge),
            BlocBuilder<MovieListBloc, BlocState>(
              builder: (context, state) {
                if (state is BlocLoading) {
                  return const Center(
                    key: Key('progress_now_playing'),
                    child: CircularProgressIndicator(),
                  );
                } else if (state is BlocHasData<List<Movie>>) {
                  return MovieList(movies: state.result);
                } else {
                  return const Text('Failed');
                }
              },
            ),
            SubHeadingView(
              title: 'Popular',
              onTap: () => Navigator.pushNamed(context, popularMovieRoute),
            ),
            BlocBuilder<PopularMoviesBloc, BlocState>(
              builder: (context, state) {
                if (state is BlocLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is BlocHasData<List<Movie>>) {
                  return MovieList(movies: state.result);
                } else {
                  return const Text('Failed');
                }
              },
            ),
            SubHeadingView(
              title: 'Top Rated',
              onTap: () => Navigator.pushNamed(context, topRatedMovieRoute),
            ),
            BlocBuilder<TopRatedMoviesBloc, BlocState>(
              builder: (context, state) {
                if (state is BlocLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is BlocHasData<List<Movie>>) {
                  return MovieList(movies: state.result);
                } else {
                  return const Text('Failed');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  const MovieList({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              key: const Key('card_item_key'),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  detailMovieRoute,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$baseImageUrl${movie.posterPath}',
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}
