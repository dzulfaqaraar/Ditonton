import 'package:equatable/equatable.dart';

class TvSeriesEpisode extends Equatable {
  const TvSeriesEpisode({
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
  final List<Episode>? episodes;
  final int? seasonNumber;

  @override
  List<Object?> get props {
    return [id, name, overview, posterPath, airDate, episodes, seasonNumber];
  }
}

class Episode extends Equatable {
  const Episode({
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
  final List<Crew> guestStars;

  @override
  List<Object?> get props {
    return [id, name, overview, episodeNumber, stillPath, guestStars];
  }
}

class Crew extends Equatable {
  const Crew({
    required this.id,
    required this.name,
    required this.character,
    required this.profilePath,
  });

  final int id;
  final String? character;
  final String? name;
  final String? profilePath;

  @override
  List<Object?> get props => [id, character, name, profilePath];
}
