import 'package:equatable/equatable.dart';

import '../../domain/entities/movie_detail.dart';
import '../../domain/entities/tv_series_detail.dart';
import '../../domain/entities/watchlist.dart';

class WatchlistTable extends Equatable {
  final int id;
  final String? title;
  final String? posterPath;
  final String? overview;
  final int isMovies;

  const WatchlistTable({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
    required this.isMovies,
  });

  factory WatchlistTable.fromEntityMovies(MovieDetail movie) => WatchlistTable(
    id: movie.id,
    title: movie.title,
    posterPath: movie.posterPath,
    overview: movie.overview,
    isMovies: 1,
  );

  factory WatchlistTable.fromEntityTvSeries(TvSeriesDetail? tvSeries) =>
      WatchlistTable(
        id: tvSeries?.id ?? -1,
        title: tvSeries?.name,
        posterPath: tvSeries?.posterPath,
        overview: tvSeries?.overview,
        isMovies: 0,
      );

  factory WatchlistTable.fromMap(Map<String, dynamic> map) => WatchlistTable(
    id: map['id'],
    title: map['title'],
    posterPath: map['posterPath'],
    overview: map['overview'],
    isMovies: map['isMovies'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'posterPath': posterPath,
    'overview': overview,
    'isMovies': isMovies,
  };

  Watchlist toEntity() => Watchlist(
    id: id,
    overview: overview ?? '',
    posterPath: posterPath ?? '',
    title: title ?? '',
    isMovies: isMovies,
  );

  @override
  List<Object?> get props => [id, title, posterPath, overview, isMovies];
}
