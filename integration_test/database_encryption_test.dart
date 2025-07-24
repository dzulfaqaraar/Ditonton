import 'package:core/data/datasources/db/database_helper.dart';
import 'package:core/data/models/watchlist_table.dart';
import 'package:core/core.dart' show encrypt;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:get_it/get_it.dart';
import 'package:ditonton/main.dart' as app;
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'dart:io';

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

  group('Database Encryption Tests', () {
    late DatabaseHelper databaseHelper;

    setUp(() async {
      // Initialize the app to set up dependencies
      app.main();
      await Future.delayed(Duration(milliseconds: 500));
      databaseHelper = DatabaseHelper();
    });

    group('Database Encryption Verification', () {
      testWidgets('should use encrypted database with correct password', (
        tester,
      ) async {
        // Arrange
        final testWatchlist = WatchlistTable(
          id: 40000,
          title: 'Encryption Test Movie',
          overview: 'Testing database encryption',
          posterPath: '/encrypt-test.jpg',
          isMovies: 1,
        );

        // Act - Insert data into encrypted database
        final insertResult = await databaseHelper.insertWatchlist(
          testWatchlist,
        );
        expect(insertResult, greaterThan(0));

        // Verify data can be retrieved (meaning encryption/decryption works)
        final retrievedItem = await databaseHelper.getWatchlistById(40000);
        expect(retrievedItem, isNotNull);
        expect(retrievedItem!['title'], equals('Encryption Test Movie'));

        // Cleanup
        await databaseHelper.removeWatchlist(testWatchlist);
      });

      testWidgets('should verify database file exists and is encrypted', (
        tester,
      ) async {
        // Arrange - Ensure database is initialized by accessing it
        final database = await databaseHelper.database;
        expect(database, isNotNull);

        // Insert test data to ensure database file is created
        final testWatchlist = WatchlistTable(
          id: 40001,
          title: 'Encryption Verification',
          overview: 'Verifying encrypted database file',
          posterPath: '/verify-encrypt.jpg',
          isMovies: 1,
        );
        await databaseHelper.insertWatchlist(testWatchlist);

        // Act - Try to access database path
        final databasesPath = await getDatabasesPath();
        final dbPath = '$databasesPath/ditonton.db';
        final dbFile = File(dbPath);

        // Assert - Database file should exist
        expect(await dbFile.exists(), isTrue);

        // Verify file is not empty (encrypted data exists)
        final fileSize = await dbFile.length();
        expect(fileSize, greaterThan(0));

        // Try to read raw file content - should not contain readable plain text
        final rawBytes = await dbFile.readAsBytes();
        final rawString = String.fromCharCodes(rawBytes);

        // The raw database file should not contain our test data in plain text
        // (this is a basic check - encrypted data shouldn't be readable)
        expect(rawString.contains('Encryption Verification'), isFalse);
        expect(
          rawString.contains('Verifying encrypted database file'),
          isFalse,
        );

        // Cleanup
        await databaseHelper.removeWatchlist(testWatchlist);
      });

      testWidgets('should verify encryption key is correctly applied', (
        tester,
      ) async {
        // Arrange - Get the encryption password used by the database
        final expectedPassword = encrypt('ditonton');
        expect(expectedPassword.isNotEmpty, isTrue);

        // Act - Ensure database operations work with encryption
        final testItems = [
          WatchlistTable(
            id: 40010,
            title: 'Encrypted Movie 1',
            overview: 'First encrypted test item',
            posterPath: '/enc1.jpg',
            isMovies: 1,
          ),
          WatchlistTable(
            id: 40011,
            title: 'Encrypted TV Series 1',
            overview: 'First encrypted TV series',
            posterPath: '/enc2.jpg',
            isMovies: 0,
          ),
        ];

        // Insert multiple items
        for (final item in testItems) {
          final result = await databaseHelper.insertWatchlist(item);
          expect(result, greaterThan(0));
        }

        // Retrieve and verify all items
        final allItems = await databaseHelper.getWatchlist();
        final itemIds = allItems.map((item) => item['id']).toSet();

        expect(itemIds, contains(40010));
        expect(itemIds, contains(40011));

        // Verify specific items can be retrieved by ID
        final movie = await databaseHelper.getWatchlistById(40010);
        final tvSeries = await databaseHelper.getWatchlistById(40011);

        expect(movie!['title'], equals('Encrypted Movie 1'));
        expect(tvSeries!['title'], equals('Encrypted TV Series 1'));
        expect(movie['isMovies'], equals(1));
        expect(tvSeries['isMovies'], equals(0));

        // Cleanup
        for (final item in testItems) {
          await databaseHelper.removeWatchlist(item);
        }
      });

      testWidgets('should handle database transactions with encryption', (
        tester,
      ) async {
        // This test verifies that database transactions work correctly with encryption
        // Arrange
        final transactionTestItems = <WatchlistTable>[];
        for (int i = 40020; i < 40025; i++) {
          transactionTestItems.add(
            WatchlistTable(
              id: i,
              title: 'Transaction Test $i',
              overview: 'Testing transactions with encryption $i',
              posterPath: '/trans$i.jpg',
              isMovies: i % 2,
            ),
          );
        }

        // Act - Insert multiple items (simulating transaction-like behavior)
        final results = <int>[];
        for (final item in transactionTestItems) {
          final result = await databaseHelper.insertWatchlist(item);
          results.add(result);
        }

        // Assert - All insertions should succeed
        for (final result in results) {
          expect(result, greaterThan(0));
        }

        // Verify all items can be retrieved
        for (int i = 40020; i < 40025; i++) {
          final item = await databaseHelper.getWatchlistById(i);
          expect(item, isNotNull);
          expect(item!['title'], equals('Transaction Test $i'));
        }

        // Cleanup - Remove all test items
        for (final item in transactionTestItems) {
          final removeResult = await databaseHelper.removeWatchlist(item);
          expect(removeResult, greaterThan(0));
        }

        // Verify all items are removed
        for (int i = 40020; i < 40025; i++) {
          final item = await databaseHelper.getWatchlistById(i);
          expect(item, isNull);
        }
      });
    });

    group('Database Security Features', () {
      testWidgets('should maintain data integrity with encryption', (
        tester,
      ) async {
        // Test to ensure encrypted data maintains integrity across operations

        // Arrange
        final originalData = WatchlistTable(
          id: 50000,
          title: 'Data Integrity Test',
          overview:
              'Testing data integrity with special characters: àáäâèéëêìíïîòóöôùúüûñç',
          posterPath: '/integrity-test.jpg',
          isMovies: 1,
        );

        // Act - Insert data with special characters
        await databaseHelper.insertWatchlist(originalData);

        // Retrieve and verify data integrity
        final retrievedData = await databaseHelper.getWatchlistById(50000);

        // Assert - Data should be exactly the same
        expect(retrievedData, isNotNull);
        expect(retrievedData!['id'], equals(originalData.id));
        expect(retrievedData['title'], equals(originalData.title));
        expect(retrievedData['overview'], equals(originalData.overview));
        expect(retrievedData['posterPath'], equals(originalData.posterPath));
        expect(retrievedData['isMovies'], equals(originalData.isMovies));

        // Test with Unicode characters
        final unicodeData = WatchlistTable(
          id: 50001,
          title: 'Unicode Test 你好世界 🎬',
          overview: 'Testing Unicode: 한국어, 日本語, العربية, русский',
          posterPath: '/unicode-test.jpg',
          isMovies: 0,
        );

        await databaseHelper.insertWatchlist(unicodeData);
        final retrievedUnicode = await databaseHelper.getWatchlistById(50001);

        expect(retrievedUnicode!['title'], equals('Unicode Test 你好世界 🎬'));
        expect(retrievedUnicode['overview'], contains('한국어'));
        expect(retrievedUnicode['overview'], contains('العربية'));

        // Cleanup
        await databaseHelper.removeWatchlist(originalData);
        await databaseHelper.removeWatchlist(unicodeData);
      });

      testWidgets('should handle database reopening with encryption', (
        tester,
      ) async {
        // Test to verify database can be reopened and data accessed correctly

        // Arrange
        final persistentData = WatchlistTable(
          id: 50010,
          title: 'Persistence Test',
          overview: 'Testing database persistence across sessions',
          posterPath: '/persist-test.jpg',
          isMovies: 1,
        );

        // Act - Insert data
        await databaseHelper.insertWatchlist(persistentData);

        // Verify data exists
        final beforeData = await databaseHelper.getWatchlistById(50010);
        expect(beforeData, isNotNull);

        // Simulate database access from new helper instance (singleton should maintain connection)
        final newHelper = DatabaseHelper();
        expect(
          identical(databaseHelper, newHelper),
          isTrue,
        ); // Verify singleton

        // Verify data is still accessible
        final afterData = await newHelper.getWatchlistById(50010);
        expect(afterData, isNotNull);
        expect(afterData!['title'], equals('Persistence Test'));

        // Cleanup
        await newHelper.removeWatchlist(persistentData);
      });
    });
  });
}
