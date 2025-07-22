import 'package:core/data/models/watchlist_table.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  test('should be a subclass of Watchlist entity from Movies', () async {
    final result = testWatchlistTableMovies.toEntity();
    expect(result, testWatchlistMovies);
  });

  test('should be a subclass of Watchlist entity from TV Series', () async {
    final result = testWatchlistTableTvSeries.toEntity();
    expect(result, testWatchlistTvSeries);
  });

  group('fromEntity', () {
    test('should return a valid model from Movies', () async {
      // act
      final result = WatchlistTable.fromEntityMovies(testMovieDetail);
      // assert
      expect(result, testWatchlistTableMovies);
    });
    test('should return a valid model from TV Series', () async {
      // act
      final result = WatchlistTable.fromEntityTvSeries(testTvSeriesDetail);
      // assert
      expect(result, testWatchlistTableTvSeries);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data Movies', () async {
      // act
      final result = testWatchlistTableMovies.toJson();
      // assert
      final expectedJsonMap = {
        "id": 1,
        "title": 'Title',
        "posterPath": '/path.jpg',
        "overview": 'Overview',
        'isMovies': 1,
      };
      expect(result, expectedJsonMap);
    });

    test('should return a JSON map containing proper data TV Series', () async {
      // act
      final result = testWatchlistTableTvSeries.toJson();
      // assert
      final expectedJsonMap = {
        "id": 1,
        "title": 'Night Court',
        "posterPath": '/nazkESnCZVpCjZ3WPs265DFjW0V.jpg',
        "overview": 'Night Court is an American television',
        "isMovies": 0,
      };
      expect(result, expectedJsonMap);
    });
  });
}
