import 'package:equatable/equatable.dart';

import '../../domain/entities/tv_series_episode.dart';

class TvSeriesEpisodeResponse extends Equatable {
  const TvSeriesEpisodeResponse({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.airDate,
    required this.episodes,
    required this.seasonNumber,
  });

  final int id;
  final String? name;
  final String? overview;
  final String? posterPath;
  final String? airDate;
  final List<EpisodeResponse>? episodes;
  final int? seasonNumber;

  factory TvSeriesEpisodeResponse.fromJson(Map<String, dynamic> json) =>
      TvSeriesEpisodeResponse(
        id: json["id"],
        name: json["name"],
        overview: json["overview"],
        posterPath: json["poster_path"],
        airDate: json["air_date"],
        episodes: List<EpisodeResponse>.from(
          json["episodes"].map((x) => EpisodeResponse.fromJson(x)),
        ),
        seasonNumber: json["season_number"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "overview": overview,
    "poster_path": posterPath,
    "air_date": airDate,
    "episodes": episodes?.map((x) => x.toJson()).toList(),
    "season_number": seasonNumber,
  };

  TvSeriesEpisode toEntity() {
    return TvSeriesEpisode(
      id: id,
      name: name,
      overview: overview,
      posterPath: posterPath,
      airDate: airDate,
      episodes: episodes?.map((e) => e.toEntity()).toList(),
      seasonNumber: seasonNumber,
    );
  }

  @override
  List<Object?> get props {
    return [id, name, overview, posterPath, airDate, episodes, seasonNumber];
  }
}

class EpisodeResponse extends Equatable {
  const EpisodeResponse({
    required this.id,
    required this.name,
    required this.overview,
    required this.episodeNumber,
    required this.stillPath,
    required this.guestStars,
  });

  final int id;
  final String? name;
  final String? overview;
  final int? episodeNumber;
  final String? stillPath;
  final List<CrewResponse> guestStars;

  factory EpisodeResponse.fromJson(Map<String, dynamic> json) =>
      EpisodeResponse(
        id: json["id"],
        name: json["name"],
        overview: json["overview"],
        episodeNumber: json["episode_number"],
        stillPath: json["still_path"],
        guestStars: List<CrewResponse>.from(
          json["guest_stars"].map((x) => CrewResponse.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "overview": overview,
    "episode_number": episodeNumber,
    "still_path": stillPath,
    "guest_stars": List<dynamic>.from(guestStars.map((x) => x.toJson())),
  };

  Episode toEntity() {
    return Episode(
      id: id,
      name: name,
      overview: overview,
      episodeNumber: episodeNumber,
      stillPath: stillPath,
      guestStars: guestStars.map((x) => x.toEntity()).toList(),
    );
  }

  @override
  List<Object?> get props {
    return [id, name, overview, episodeNumber, stillPath, guestStars];
  }
}

class CrewResponse extends Equatable {
  const CrewResponse({
    required this.id,
    required this.name,
    required this.character,
    required this.profilePath,
  });

  final int id;
  final String? character;
  final String? name;
  final String? profilePath;

  factory CrewResponse.fromJson(Map<String, dynamic> json) => CrewResponse(
    id: json["id"],
    name: json["name"],
    character: json["character"],
    profilePath: json["profile_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "character": character,
    "profile_path": profilePath,
  };

  Crew toEntity() {
    return Crew(
      id: id,
      character: character,
      name: name,
      profilePath: profilePath,
    );
  }

  @override
  List<Object?> get props => [id, character, name, profilePath];
}
