import 'dart:convert';

import 'package:core/data/models/tv_series_detail_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../json_reader.dart';

void main() {
  test('should be a subclass of TV Series Detail entity', () async {
    final result = testTvSeriesDetailResponse.toEntity();
    expect(result, testTvSeriesDetail);
  });

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(
        readJson('dummy_data/tv_series_detail.json'),
      );
      // act
      final result = TvSeriesDetailResponse.fromJson(jsonMap);
      // assert
      expect(result, testTvSeriesDetailResponse);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // act
      final result = testTvSeriesDetailResponse.toJson();
      // assert
      final expectedJsonMap = {
        "id": 1,
        "name": "Night Court",
        "overview": "Night Court is an American television",
        "poster_path": "/nazkESnCZVpCjZ3WPs265DFjW0V.jpg",
        "genres": [
          {"id": 35, "name": "Comedy"},
        ],
        "vote_average": 7.4,
        "episode_run_time": [24],
        'seasons': [
          {
            "air_date": null,
            "episode_count": 1,
            "id": 531,
            "name": "Specials",
            "overview": "",
            "poster_path": '/3T19XSr6yqaLNK8uJWFImPgRax0.png',
            "season_number": 0,
          },
          {
            "air_date": null,
            "episode_count": 2,
            "id": 531,
            "name": "Specials",
            "overview": "",
            "poster_path": '/3T19XSr6yqaLNK8uJWFImPgRax0.png',
            "season_number": 0,
          },
        ],
      };
      expect(result, expectedJsonMap);
    });
  });
}
