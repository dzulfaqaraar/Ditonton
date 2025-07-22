import 'dart:convert';

import 'package:core/data/models/tv_series_episode_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../json_reader.dart';

void main() {
  test('should be a subclass of TV Series Episode entity', () async {
    final result = testTvSeriesEpisodeResponse.toEntity();
    expect(result, testTvSeriesEpisode);
  });

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(
        readJson('dummy_data/tv_series_episode.json'),
      );
      // act
      final result = TvSeriesEpisodeResponse.fromJson(jsonMap);
      // assert
      expect(result, testTvSeriesEpisodeResponse);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // act
      final result = testTvSeriesEpisodeResponse.toJson();
      // assert
      final expectedJsonMap = {
        "id": 168159,
        "name": "Season 1",
        "overview": "",
        "poster_path": "/s7ChVSINrNLbw1pNLz0dUWR5x2L.jpg",
        "air_date": "2022-06-24",
        "episodes": [
          {
            "id": 2501960,
            "name": "Episode 1",
            "overview":
                "Recruited by the Professor for a job of unprecedented proportions, eight thieves storm the Unified Korea Mint. Police pull together a task force.",
            "episode_number": 1,
            "still_path": "/fABG8ubGumTnYVCkK63zo1wwCq4.jpg",
            "guest_stars": [
              {
                "id": 1005920,
                "name": "Irene Keng",
                "character": "Elle McLean",
                "profile_path": "/xElpxbxNFNtBdeccxSqbnAeaul2.jpg",
              },
            ],
          },
          {
            "id": 2501960,
            "name": "Episode 2",
            "overview":
                "Recruited by the Professor for a job of unprecedented proportions, eight thieves storm the Unified Korea Mint. Police pull together a task force.",
            "episode_number": 2,
            "still_path": "/fABG8ubGumTnYVCkK63zo1wwCq4.jpg",
            "guest_stars": [
              {
                "id": 1005920,
                "name": "Irene Keng",
                "character": "Elle McLean",
                "profile_path": "/xElpxbxNFNtBdeccxSqbnAeaul2.jpg",
              },
            ],
          },
        ],
        "season_number": 1,
      };
      expect(result, expectedJsonMap);
    });
  });
}
