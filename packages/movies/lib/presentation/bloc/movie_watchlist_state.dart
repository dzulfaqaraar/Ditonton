part of 'movie_watchlist_bloc.dart';

class MovieWatchlistHasMessage extends BlocState {
  final bool? isAdded;
  final String? message;

  const MovieWatchlistHasMessage(this.isAdded, this.message);

  @override
  List<Object?> get props => [isAdded, message];
}
