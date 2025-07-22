import 'package:equatable/equatable.dart';

import '../../domain/entities/tv_series.dart';

class TvSeriesModel extends Equatable {
  const TvSeriesModel({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
  });

  final int id;
  final String name;
  final String overview;
  final String? posterPath;

  factory TvSeriesModel.fromJson(Map<String, dynamic> json) => TvSeriesModel(
    id: json["id"],
    name: json["name"],
    overview: json["overview"],
    posterPath: json["poster_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "overview": overview,
    "poster_path": posterPath,
  };

  TvSeries toEntity() {
    return TvSeries(
      id: id,
      name: name,
      overview: overview,
      posterPath: posterPath,
    );
  }

  @override
  List<Object?> get props {
    return [id, name, overview, posterPath];
  }
}
