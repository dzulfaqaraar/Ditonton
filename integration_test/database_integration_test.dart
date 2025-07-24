import 'package:core/data/datasources/db/database_helper.dart';
import 'package:core/data/models/watchlist_table.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:get_it/get_it.dart';
import 'package:ditonton/main.dart' as app;
import 'package:sqflite_sqlcipher/sqflite.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // Reset GetIt to avoid duplicate registration between tests
    GetIt.I.reset();
  });

  tearDown(() async {
    // Reset GetIt after each test to prevent state pollution
    GetIt.I.reset();
  });

  group('Database Integration Tests', () {
    late DatabaseHelper databaseHelper;

    setUp(() async {
      // Initialize the app to set up dependencies
      app.main();
      await Future.delayed(Duration(milliseconds: 500));
      databaseHelper = DatabaseHelper();
    });

    group('Database Basic Operations', () {
      testWidgets('should insert and retrieve movie watchlist item', (
        tester,
      ) async {
        // Arrange
        final movieWatchlist = WatchlistTable(
          id: 12345,
          title: 'Test Movie',
          overview: 'Test movie overview',
          posterPath: '/test-poster.jpg',
          isMovies: 1,
        );

        // Act - Insert
        final insertResult = await databaseHelper.insertWatchlist(
          movieWatchlist,
        );

        // Assert - Insert successful
        expect(insertResult, greaterThan(0));

        // Act - Retrieve by ID
        final retrievedItem = await databaseHelper.getWatchlistById(12345);

        // Assert - Retrieved item matches
        expect(retrievedItem, isNotNull);
        expect(retrievedItem!['id'], equals(12345));
        expect(retrievedItem['title'], equals('Test Movie'));
        expect(retrievedItem['isMovies'], equals(1));

        // Cleanup
        await databaseHelper.removeWatchlist(movieWatchlist);
      });

      testWidgets('should insert and retrieve TV series watchlist item', (
        tester,
      ) async {
        // Arrange
        final tvSeriesWatchlist = WatchlistTable(
          id: 67890,
          title: 'Test TV Series',
          overview: 'Test TV series overview',
          posterPath: '/test-tv-poster.jpg',
          isMovies: 0,
        );

        // Act - Insert
        final insertResult = await databaseHelper.insertWatchlist(
          tvSeriesWatchlist,
        );

        // Assert - Insert successful
        expect(insertResult, greaterThan(0));

        // Act - Retrieve by ID
        final retrievedItem = await databaseHelper.getWatchlistById(67890);

        // Assert - Retrieved item matches
        expect(retrievedItem, isNotNull);
        expect(retrievedItem!['id'], equals(67890));
        expect(retrievedItem['title'], equals('Test TV Series'));
        expect(retrievedItem['isMovies'], equals(0));

        // Cleanup
        await databaseHelper.removeWatchlist(tvSeriesWatchlist);
      });

      testWidgets('should remove watchlist item successfully', (tester) async {
        // Arrange
        final testWatchlist = WatchlistTable(
          id: 99999,
          title: 'Test Remove Item',
          overview: 'Item to be removed',
          posterPath: '/remove-test.jpg',
          isMovies: 1,
        );

        // Insert item first
        await databaseHelper.insertWatchlist(testWatchlist);

        // Verify item exists
        final existingItem = await databaseHelper.getWatchlistById(99999);
        expect(existingItem, isNotNull);

        // Act - Remove item
        final removeResult = await databaseHelper.removeWatchlist(
          testWatchlist,
        );

        // Assert - Remove successful
        expect(removeResult, greaterThan(0));

        // Verify item no longer exists
        final removedItem = await databaseHelper.getWatchlistById(99999);
        expect(removedItem, isNull);
      });

      testWidgets('should retrieve all watchlist items', (tester) async {
        // Arrange - Clear existing data and add test data
        final testMovies = [
          WatchlistTable(
            id: 1001,
            title: 'Movie 1',
            overview: 'Overview 1',
            posterPath: '/poster1.jpg',
            isMovies: 1,
          ),
          WatchlistTable(
            id: 1002,
            title: 'Movie 2',
            overview: 'Overview 2',
            posterPath: '/poster2.jpg',
            isMovies: 1,
          ),
          WatchlistTable(
            id: 2001,
            title: 'TV Series 1',
            overview: 'TV Overview 1',
            posterPath: '/tv1.jpg',
            isMovies: 0,
          ),
        ];

        // Insert test data
        for (final movie in testMovies) {
          await databaseHelper.insertWatchlist(movie);
        }

        // Act - Get all watchlist items
        final allWatchlist = await databaseHelper.getWatchlist();

        // Assert - Contains all inserted items
        expect(allWatchlist.length, greaterThanOrEqualTo(3));

        // Verify specific items exist
        final movieIds = allWatchlist.map((item) => item['id']).toSet();
        expect(movieIds, contains(1001));
        expect(movieIds, contains(1002));
        expect(movieIds, contains(2001));

        // Cleanup
        for (final movie in testMovies) {
          await databaseHelper.removeWatchlist(movie);
        }
      });
    });

    group('Database Edge Cases', () {
      testWidgets('should handle duplicate insertion attempts', (tester) async {
        // Arrange
        final duplicateWatchlist = WatchlistTable(
          id: 5555,
          title: 'Duplicate Test',
          overview: 'Testing duplicate handling',
          posterPath: '/duplicate.jpg',
          isMovies: 1,
        );

        // Act - Insert first time
        final firstInsert = await databaseHelper.insertWatchlist(
          duplicateWatchlist,
        );
        expect(firstInsert, greaterThan(0));

        // Act - Insert duplicate (should handle gracefully)
        try {
          final secondInsert = await databaseHelper.insertWatchlist(
            duplicateWatchlist,
          );
          // If no exception is thrown, it means duplicates are allowed (replace or ignore)
          expect(secondInsert, isA<int>());
        } catch (e) {
          // If exception is thrown, it means duplicates are properly rejected
          expect(e, isA<DatabaseException>());
        }

        // Verify only one item exists
        final item = await databaseHelper.getWatchlistById(5555);
        expect(item, isNotNull);

        // Cleanup
        await databaseHelper.removeWatchlist(duplicateWatchlist);
      });

      testWidgets('should handle non-existent item retrieval', (tester) async {
        // Act - Try to get non-existent item
        final nonExistentItem = await databaseHelper.getWatchlistById(999999);

        // Assert - Should return null
        expect(nonExistentItem, isNull);
      });

      testWidgets('should handle non-existent item removal', (tester) async {
        // Arrange
        final nonExistentWatchlist = WatchlistTable(
          id: 888888,
          title: 'Non-existent',
          overview: 'Does not exist',
          posterPath: '/none.jpg',
          isMovies: 1,
        );

        // Act - Try to remove non-existent item
        final removeResult = await databaseHelper.removeWatchlist(
          nonExistentWatchlist,
        );

        // Assert - Should return 0 (no rows affected)
        expect(removeResult, equals(0));
      });

      testWidgets('should handle null and empty string values', (tester) async {
        // Arrange
        final watchlistWithNulls = WatchlistTable(
          id: 7777,
          title: null,
          overview: null,
          posterPath: null,
          isMovies: 1,
        );

        // Act - Insert item with null values
        final insertResult = await databaseHelper.insertWatchlist(
          watchlistWithNulls,
        );
        expect(insertResult, greaterThan(0));

        // Act - Retrieve item
        final retrievedItem = await databaseHelper.getWatchlistById(7777);

        // Assert - Should handle null values properly
        expect(retrievedItem, isNotNull);
        expect(retrievedItem!['id'], equals(7777));
        expect(retrievedItem['title'], isNull);
        expect(retrievedItem['overview'], isNull);
        expect(retrievedItem['posterPath'], isNull);

        // Cleanup
        await databaseHelper.removeWatchlist(watchlistWithNulls);
      });
    });

    group('Database Performance and Stress Tests', () {
      testWidgets('should handle large number of insertions', (tester) async {
        final List<WatchlistTable> largeDataset = [];

        // Generate large dataset
        for (int i = 10000; i < 10100; i++) {
          largeDataset.add(
            WatchlistTable(
              id: i,
              title: 'Bulk Item $i',
              overview: 'Bulk overview $i',
              posterPath: '/bulk$i.jpg',
              isMovies: i % 2, // Alternate between movies and TV series
            ),
          );
        }

        // Measure insertion time
        final stopwatch = Stopwatch()..start();

        // Act - Insert all items
        for (final item in largeDataset) {
          await databaseHelper.insertWatchlist(item);
        }

        stopwatch.stop();

        // Assert - Should complete within reasonable time (adjust as needed)
        expect(
          stopwatch.elapsedMilliseconds,
          lessThan(10000),
        ); // Less than 10 seconds

        // Verify all items were inserted
        final allItems = await databaseHelper.getWatchlist();
        final insertedIds = allItems.map((item) => item['id']).toSet();

        for (int i = 10000; i < 10100; i++) {
          expect(insertedIds, contains(i));
        }

        // Cleanup
        for (final item in largeDataset) {
          await databaseHelper.removeWatchlist(item);
        }
      });

      testWidgets('should handle concurrent database operations', (
        tester,
      ) async {
        // Arrange
        final List<Future<int>> insertFutures = [];

        // Act - Perform concurrent insertions
        for (int i = 20000; i < 20010; i++) {
          final watchlist = WatchlistTable(
            id: i,
            title: 'Concurrent Item $i',
            overview: 'Concurrent test $i',
            posterPath: '/concurrent$i.jpg',
            isMovies: 1,
          );
          insertFutures.add(databaseHelper.insertWatchlist(watchlist));
        }

        // Wait for all insertions to complete
        final results = await Future.wait(insertFutures);

        // Assert - All insertions successful
        for (final result in results) {
          expect(result, greaterThan(0));
        }

        // Verify all items exist
        for (int i = 20000; i < 20010; i++) {
          final item = await databaseHelper.getWatchlistById(i);
          expect(item, isNotNull);
          expect(item!['title'], equals('Concurrent Item $i'));
        }

        // Cleanup
        for (int i = 20000; i < 20010; i++) {
          final watchlist = WatchlistTable(
            id: i,
            title: 'Concurrent Item $i',
            overview: 'Concurrent test $i',
            posterPath: '/concurrent$i.jpg',
            isMovies: 1,
          );
          await databaseHelper.removeWatchlist(watchlist);
        }
      });
    });

    group('Database State Persistence', () {
      testWidgets('should maintain data across DatabaseHelper instances', (
        tester,
      ) async {
        // Arrange
        final testWatchlist = WatchlistTable(
          id: 30000,
          title: 'Persistence Test',
          overview: 'Testing data persistence',
          posterPath: '/persist.jpg',
          isMovies: 1,
        );

        // Act - Insert with first instance
        final firstHelper = DatabaseHelper();
        await firstHelper.insertWatchlist(testWatchlist);

        // Act - Retrieve with second instance (singleton should return same instance)
        final secondHelper = DatabaseHelper();
        final retrievedItem = await secondHelper.getWatchlistById(30000);

        // Assert - Data should be accessible from both instances
        expect(retrievedItem, isNotNull);
        expect(retrievedItem!['title'], equals('Persistence Test'));
        expect(
          identical(firstHelper, secondHelper),
          isTrue,
        ); // Verify singleton

        // Cleanup
        await firstHelper.removeWatchlist(testWatchlist);
      });
    });

    group('Database Error Handling', () {
      testWidgets('should handle database initialization gracefully', (
        tester,
      ) async {
        // This test verifies that database initialization doesn't throw exceptions
        // and that the database helper can be created multiple times safely

        // Act - Create multiple database helper instances
        final helpers = <DatabaseHelper>[];
        for (int i = 0; i < 5; i++) {
          helpers.add(DatabaseHelper());
        }

        // Assert - All instances should be the same (singleton)
        for (int i = 1; i < helpers.length; i++) {
          expect(identical(helpers[i], helpers[0]), isTrue);
        }

        // Assert - Database should be accessible
        final database = await helpers[0].database;
        expect(database, isNotNull);
      });
    });
  });
}
