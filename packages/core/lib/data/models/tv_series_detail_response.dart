import 'package:equatable/equatable.dart';

import '../../domain/entities/tv_series_detail.dart';
import 'genre_model.dart';

class TvSeriesDetailResponse extends Equatable {
  const TvSeriesDetailResponse({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.genres,
    required this.voteAverage,
    required this.episodeRunTime,
    required this.seasons,
  });

  final int id;
  final String name;
  final String overview;
  final String posterPath;
  final List<GenreModel> genres;
  final double voteAverage;
  final List<int>? episodeRunTime;
  final List<SeasonResponse>? seasons;

  factory TvSeriesDetailResponse.fromJson(Map<String, dynamic> json) =>
      TvSeriesDetailResponse(
        id: json["id"],
        name: json["name"],
        overview: json["overview"],
        posterPath: json["poster_path"],
        genres: List<GenreModel>.from(
          json["genres"].map((x) => GenreModel.fromJson(x)),
        ),
        voteAverage: json["vote_average"].toDouble(),
        episodeRunTime: List<int>.from(json["episode_run_time"].map((x) => x)),
        seasons: List<SeasonResponse>.from(
          json["seasons"]
              .map((x) => SeasonResponse.fromJson(x))
              .where((element) => element.posterPath != null),
        ),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "overview": overview,
    "poster_path": posterPath,
    "genres": genres.map((x) => x.toJson()).toList(),
    "vote_average": voteAverage,
    "episode_run_time": episodeRunTime?.map((x) => x).toList(),
    "seasons": seasons?.map((x) => x.toJson()).toList(),
  };

  @override
  List<Object?> get props {
    return [
      id,
      name,
      overview,
      posterPath,
      genres,
      voteAverage,
      episodeRunTime,
      seasons,
    ];
  }

  TvSeriesDetail toEntity() {
    return TvSeriesDetail(
      id: id,
      name: name,
      overview: overview,
      posterPath: posterPath,
      genres: genres.map((e) => e.toEntity()).toList(),
      voteAverage: voteAverage,
      episodeRunTime: episodeRunTime,
      seasons: seasons?.map((e) => e.toEntity()).toList(),
    );
  }
}

class SeasonResponse extends Equatable {
  const SeasonResponse({
    required this.id,
    required this.name,
    required this.airDate,
    required this.overview,
    required this.posterPath,
    required this.episodeCount,
    required this.seasonNumber,
  });

  final int id;
  final String? name;
  final String? airDate;
  final String? overview;
  final String? posterPath;
  final int? episodeCount;
  final int? seasonNumber;

  factory SeasonResponse.fromJson(Map<String, dynamic> json) => SeasonResponse(
    airDate: json["air_date"],
    episodeCount: json["episode_count"],
    id: json["id"],
    name: json["name"],
    overview: json["overview"],
    posterPath: json["poster_path"],
    seasonNumber: json["season_number"],
  );

  Map<String, dynamic> toJson() => {
    "air_date": airDate,
    "episode_count": episodeCount,
    "id": id,
    "name": name,
    "overview": overview,
    "poster_path": posterPath,
    "season_number": seasonNumber,
  };

  Season toEntity() {
    return Season(
      id: id,
      name: name,
      airDate: airDate,
      overview: overview,
      posterPath: posterPath,
      episodeCount: episodeCount,
      seasonNumber: seasonNumber,
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      name,
      airDate,
      overview,
      posterPath,
      episodeCount,
      seasonNumber,
    ];
  }
}
