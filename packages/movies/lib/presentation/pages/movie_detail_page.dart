import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movies/movies.dart';

class MovieDetailPage extends StatefulWidget {
  final int id;

  const MovieDetailPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MovieDetailBloc>().add(OnFetchingDetail(widget.id));
      context
          .read<MovieRecommendationBloc>()
          .add(OnFetchingRecommendation(widget.id));
      context.read<MovieWatchlistBloc>().add(OnLoadingWatchlist(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    final watchlistBloc = BlocProvider.of<MovieWatchlistBloc>(context);
    return Scaffold(
      body: BlocListener(
        bloc: watchlistBloc,
        listener: (BuildContext context, MovieWatchlistState state) {
          if (state is MovieWatchlistHasMessage) {
            if (state.message != null) {
              if (state.message == watchlistAddSuccessMessage ||
                  state.message == watchlistRemoveSuccessMessage) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message!)),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(state.message!),
                    );
                  },
                );
              }
            }
          }
        },
        child: BlocBuilder<MovieDetailBloc, MovieDetailState>(
          builder: (context, state) {
            if (state is MovieDetailLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is MovieDetailHasData) {
              final movie = state.result;
              return SafeArea(
                child: DetailContent(movie: movie),
              );
            } else if (state is MovieDetailError) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final MovieDetail movie;

  const DetailContent({
    Key? key,
    required this.movie,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie.title,
                              style: titleLarge,
                            ),
                            _watchlistView(),
                            Text(
                              _showGenres(movie.genres),
                            ),
                            Text(
                              _showDuration(movie.runtime),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: movie.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${movie.voteAverage}')
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: titleMedium,
                            ),
                            Text(
                              movie.overview,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: titleMedium,
                            ),
                            _recommendationView(),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            minChildSize: 0.25,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  Widget _watchlistView() {
    return BlocBuilder<MovieWatchlistBloc, MovieWatchlistState>(
        builder: (context, state) {
      if (state is MovieWatchlistEmpty) {
        return const ElevatedButton(
          onPressed: null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add),
              Text('Watchlist'),
            ],
          ),
        );
      } else if (state is MovieWatchlistHasMessage) {
        final isAddedWatchlist = state.isAdded;

        return ElevatedButton(
          onPressed: () async {
            if (isAddedWatchlist == false) {
              context.read<MovieWatchlistBloc>().add(OnAddingWatchlist(movie));
            } else if (isAddedWatchlist == true) {
              context
                  .read<MovieWatchlistBloc>()
                  .add(OnRemovingWatchlist(movie));
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              isAddedWatchlist == true
                  ? const Icon(Icons.check)
                  : const Icon(Icons.add),
              const Text('Watchlist'),
            ],
          ),
        );
      } else {
        return const SizedBox.shrink();
      }
    });
  }

  Widget _recommendationView() {
    return BlocBuilder<MovieRecommendationBloc, MovieRecommendationState>(
      builder: (context, state) {
        if (state is MovieRecommendationLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is MovieRecommendationHasData) {
          final recommendations = state.result;
          return SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final movie = recommendations[index];
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        detailMovieRoute,
                        arguments: movie.id,
                      );
                    },
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                );
              },
              itemCount: recommendations.length,
            ),
          );
        } else if (state is MovieRecommendationError) {
          return Center(
            key: const Key('error_message'),
            child: Text(state.message),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += '${genre.name}, ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
