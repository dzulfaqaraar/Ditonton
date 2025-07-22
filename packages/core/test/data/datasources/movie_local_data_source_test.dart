import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MovieLocalDataSourceImpl dataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSource = MovieLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  group('save watchlist', () {
    test(
      'should return success message when insert to database is success',
      () async {
        // arrange
        when(
          mockDatabaseHelper.insertWatchlist(testWatchlistTableMovies),
        ).thenAnswer((_) async => 1);
        // act
        final result = await dataSource.insertWatchlist(
          testWatchlistTableMovies,
        );
        // assert
        expect(result, 'Added to Watchlist');
      },
    );

    test(
      'should throw DatabaseException when insert to database is failed',
      () async {
        // arrange
        when(
          mockDatabaseHelper.insertWatchlist(testWatchlistTableMovies),
        ).thenThrow(Exception());
        // act
        final call = dataSource.insertWatchlist(testWatchlistTableMovies);
        // assert
        expect(() => call, throwsA(isA<DatabaseException>()));
      },
    );
  });

  group('remove watchlist', () {
    test(
      'should return success message when remove from database is success',
      () async {
        // arrange
        when(
          mockDatabaseHelper.removeWatchlist(testWatchlistTableMovies),
        ).thenAnswer((_) async => 1);
        // act
        final result = await dataSource.removeWatchlist(
          testWatchlistTableMovies,
        );
        // assert
        expect(result, 'Removed from Watchlist');
      },
    );

    test(
      'should throw DatabaseException when remove from database is failed',
      () async {
        // arrange
        when(
          mockDatabaseHelper.removeWatchlist(testWatchlistTableMovies),
        ).thenThrow(Exception());
        // act
        final call = dataSource.removeWatchlist(testWatchlistTableMovies);
        // assert
        expect(() => call, throwsA(isA<DatabaseException>()));
      },
    );
  });

  group('get watchlist by id', () {
    test('should return Watchlist Table when data is found', () async {
      // arrange
      when(
        mockDatabaseHelper.getWatchlistById(testMovieId),
      ).thenAnswer((_) async => testWatchlistMapMovies);
      // act
      final result = await dataSource.getWatchlistById(testMovieId);
      // assert
      expect(result, testWatchlistTableMovies);
    });

    test('should return null when data is not found', () async {
      // arrange
      when(
        mockDatabaseHelper.getWatchlistById(testMovieId),
      ).thenAnswer((_) async => null);
      // act
      final result = await dataSource.getWatchlistById(testMovieId);
      // assert
      expect(result, null);
    });
  });

  group('get watchlist data', () {
    test('should return list of WatchlistTable from database', () async {
      // arrange
      when(
        mockDatabaseHelper.getWatchlist(),
      ).thenAnswer((_) async => [testWatchlistMapMovies]);
      // act
      final result = await dataSource.getWatchlist();
      // assert
      expect(result, [testWatchlistTableMovies]);
    });
  });
}
