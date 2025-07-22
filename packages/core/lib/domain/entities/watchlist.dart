import 'package:equatable/equatable.dart';

class Watchlist extends Equatable {
  const Watchlist({
    required this.id,
    required this.overview,
    required this.posterPath,
    required this.title,
    required this.isMovies,
  });

  final int id;
  final String overview;
  final String posterPath;
  final String title;
  final int isMovies;

  @override
  List<Object> get props {
    return [id, overview, posterPath, title, isMovies];
  }
}
