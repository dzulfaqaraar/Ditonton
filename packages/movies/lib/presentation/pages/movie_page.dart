import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/movies.dart';

class MoviePage extends StatefulWidget {
  const MoviePage({Key? key}) : super(key: key);

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MovieListBloc>().add(const OnFetchingList());
      context.read<PopularMoviesBloc>().add(const OnFetchingPopular());
      context.read<TopRatedMoviesBloc>().add(const OnFetchingTopRated());
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
            Text(
              'Now Playing',
              style: titleMedium,
            ),
            BlocBuilder<MovieListBloc, MovieListState>(
                builder: (context, state) {
              if (state is MovieListLoading) {
                return const Center(
                  key: Key('progress_now_playing'),
                  child: CircularProgressIndicator(),
                );
              } else if (state is MovieListHasData) {
                return MovieList(movies: state.result);
              } else {
                return const Text('Failed');
              }
            }),
            SubHeadingView(
              title: 'Popular',
              onTap: () => Navigator.pushNamed(context, popularMovieRoute),
            ),
            BlocBuilder<PopularMoviesBloc, PopularMoviesState>(
                builder: (context, state) {
              if (state is PopularMoviesLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is PopularMoviesHasData) {
                return MovieList(movies: state.result);
              } else {
                return const Text('Failed');
              }
            }),
            SubHeadingView(
              title: 'Top Rated',
              onTap: () => Navigator.pushNamed(context, topRatedMovieRoute),
            ),
            BlocBuilder<TopRatedMoviesBloc, TopRatedMoviesState>(
                builder: (context, state) {
              if (state is TopRatedMoviesLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is TopRatedMoviesHasData) {
                return MovieList(movies: state.result);
              } else {
                return const Text('Failed');
              }
            }),
          ],
        ),
      ),
    );
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  const MovieList({
    Key? key,
    required this.movies,
  }) : super(key: key);

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
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
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
