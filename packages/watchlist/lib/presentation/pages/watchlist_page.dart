import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchlist/presentation/bloc/watchlist_bloc.dart';

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({Key? key}) : super(key: key);

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<WatchlistBloc>().add(const OnFetchingData()));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    context.read<WatchlistBloc>().add(const OnFetchingData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<WatchlistBloc, WatchlistState>(
          builder: (context, state) {
            if (state is WatchlistLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is WatchlistHasData) {
              final result = state.result;

              if (result.isEmpty) {
                return Center(
                  child: Text(
                    'No data',
                    style: titleMedium,
                  ),
                );
              } else {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final watchlist = result[index];

                    if (watchlist.isMovies == 1) {
                      final movie = Movie.watchlist(
                        id: watchlist.id,
                        overview: watchlist.overview,
                        posterPath: watchlist.posterPath,
                        title: watchlist.title,
                      );
                      return MovieCard(movie: movie);
                    } else {
                      final tvSeries = TvSeries(
                        id: watchlist.id,
                        overview: watchlist.overview,
                        posterPath: watchlist.posterPath,
                        name: watchlist.title,
                      );
                      return TvSeriesCard(tvSeries: tvSeries);
                    }
                  },
                  itemCount: result.length,
                );
              }
            } else if (state is WatchlistError) {
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

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
