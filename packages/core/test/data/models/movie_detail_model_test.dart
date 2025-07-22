import 'dart:convert';

import 'package:core/data/models/movie_detail_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../json_reader.dart';

void main() {
  test('should be a subclass of Movie Detail entity', () async {
    final result = testMovieDetailResponse.toEntity();
    expect(result, testMovieDetail);
  });

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(
        readJson('dummy_data/movie_detail.json'),
      );
      // act
      final result = MovieDetailResponse.fromJson(jsonMap);
      // assert
      expect(result, testMovieDetailResponse);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // act
      final result = testMovieDetailResponse.toJson();
      // assert
      final expectedJsonMap = {
        "adult": false,
        "backdrop_path": '/path.jpg',
        "budget": 100,
        "genres": [
          {"id": 1, "name": "Action"},
        ],
        "homepage": 'https://google.com',
        "id": 1,
        "imdb_id": 'imdb1',
        "original_language": 'en',
        "original_title": 'Original Title',
        "overview": 'Overview',
        "popularity": 1.0,
        "poster_path": '/path.jpg',
        "release_date": '2020-05-05',
        "revenue": 12000,
        "runtime": 120,
        "status": 'Status',
        "tagline": 'Tagline',
        "title": 'Title',
        "video": false,
        "vote_average": 1.0,
        "vote_count": 1,
      };
      expect(result, expectedJsonMap);
    });
  });
}
