import 'package:core/core.dart';
import 'package:core/presentation/bloc/bloc_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/domain/usecases/remove_watchlist_movies.dart';
import 'package:movies/domain/usecases/save_watchlist_movies.dart';
import 'package:watchlist/watchlist.dart';

part 'movie_watchlist_event.dart';
part 'movie_watchlist_state.dart';

const watchlistAddSuccessMessage = 'Added to Watchlist';
const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

class MovieWatchlistBloc extends Bloc<MovieWatchlistEvent, BlocState> {
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlistMovies saveWatchlist;
  final RemoveWatchlistMovies removeWatchlist;

  MovieWatchlistBloc({
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(BlocEmpty()) {
    on<OnLoadingWatchlist>((event, emit) async {
      final isAdded = await getWatchListStatus.execute(event.id);
      emit(MovieWatchlistHasMessage(isAdded, null));
    });
    on<OnAddingWatchlist>((event, emit) async {
      final result = await saveWatchlist.execute(event.movie);
      final isAdded = await getWatchListStatus.execute(event.movie.id);

      await result.fold(
        (failure) async {
          emit(MovieWatchlistHasMessage(isAdded, failure.message));
        },
        (successMessage) async {
          emit(MovieWatchlistHasMessage(isAdded, successMessage));
        },
      );
    });
    on<OnRemovingWatchlist>((event, emit) async {
      final result = await removeWatchlist.execute(event.movie);
      final isAdded = await getWatchListStatus.execute(event.movie.id);

      await result.fold(
        (failure) async {
          emit(MovieWatchlistHasMessage(isAdded, failure.message));
        },
        (successMessage) async {
          emit(MovieWatchlistHasMessage(isAdded, successMessage));
        },
      );
    });
  }
}
