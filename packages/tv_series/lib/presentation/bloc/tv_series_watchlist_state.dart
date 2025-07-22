part of 'tv_series_watchlist_bloc.dart';

class TvSeriesWatchlistHasMessage extends BlocState {
  final bool? isAdded;
  final String? message;

  const TvSeriesWatchlistHasMessage(this.isAdded, this.message);

  @override
  List<Object?> get props => [isAdded, message];
}
