import 'package:equatable/equatable.dart';

class TvSeries extends Equatable {
  const TvSeries({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
  });

  final int id;
  final String? name;
  final String? overview;
  final String? posterPath;

  @override
  List<Object?> get props {
    return [id, name, overview, posterPath];
  }
}
