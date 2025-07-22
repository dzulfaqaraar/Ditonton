import 'package:core/presentation/bloc/bloc_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchlist/watchlist.dart';

part 'watchlist_event.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, BlocState> {
  final GetWatchlistData _getWatchlistData;

  WatchlistBloc(this._getWatchlistData) : super(BlocEmpty()) {
    on<OnFetchingData>((event, emit) async {
      emit(BlocLoading());

      final result = await _getWatchlistData.execute();
      result.fold(
        (failure) {
          emit(BlocError(failure.message));
        },
        (data) {
          emit(BlocHasData(data));
        },
      );
    });
  }
}
