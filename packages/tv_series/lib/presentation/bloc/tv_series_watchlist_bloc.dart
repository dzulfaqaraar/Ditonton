import 'package:core/core.dart';
import 'package:core/presentation/bloc/bloc_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/tv_series.dart';
import 'package:watchlist/watchlist.dart';

part 'tv_series_watchlist_event.dart';
part 'tv_series_watchlist_state.dart';

const watchlistAddSuccessMessage = 'Added to Watchlist';
const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

class TvSeriesWatchlistBloc extends Bloc<TvSeriesWatchlistEvent, BlocState> {
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlistTvSeries saveWatchlist;
  final RemoveWatchlistTvSeries removeWatchlist;

  TvSeriesWatchlistBloc({
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(BlocEmpty()) {
    on<OnLoadingWatchlist>((event, emit) async {
      final isAdded = await getWatchListStatus.execute(event.id);
      emit(TvSeriesWatchlistHasMessage(isAdded, null));
    });
    on<OnAddingWatchlist>((event, emit) async {
      final result = await saveWatchlist.execute(event.tvSeries);
      final isAdded = await getWatchListStatus.execute(event.tvSeries.id);

      await result.fold(
        (failure) async {
          emit(TvSeriesWatchlistHasMessage(isAdded, failure.message));
        },
        (successMessage) async {
          emit(TvSeriesWatchlistHasMessage(isAdded, successMessage));
        },
      );
    });
    on<OnRemovingWatchlist>((event, emit) async {
      final result = await removeWatchlist.execute(event.tvSeries);
      final isAdded = await getWatchListStatus.execute(event.tvSeries.id);

      await result.fold(
        (failure) async {
          emit(TvSeriesWatchlistHasMessage(isAdded, failure.message));
        },
        (successMessage) async {
          emit(TvSeriesWatchlistHasMessage(isAdded, successMessage));
        },
      );
    });
  }
}
