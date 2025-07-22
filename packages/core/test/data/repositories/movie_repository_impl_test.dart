import 'dart:io';

import 'package:core/core.dart';
import 'package:core/data/models/movie_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MovieRepositoryImpl repository;
  late MockMovieRemoteDataSource mockRemoteDataSource;
  late MockMovieLocalDataSource mockLocalDataSource;

  const connectionFailureMessage = 'Failed to connect to the network';
  const sslFailureMessage = 'Failed to verify the internet connection';
  const url = 'https://any-url.com';

  setUp(() {
    mockRemoteDataSource = MockMovieRemoteDataSource();
    mockLocalDataSource = MockMovieLocalDataSource();
    repository = MovieRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  group('Get Movies', () {
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getMovies(url),
        ).thenAnswer((_) async => tMovieModelList);
        // act
        final result = await repository.getMovies(url);
        // assert
        verify(mockRemoteDataSource.getMovies(url));
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, tMovieList);
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(mockRemoteDataSource.getMovies(url)).thenThrow(ServerException());
        // act
        final result = await repository.getMovies(url);
        // assert
        verify(mockRemoteDataSource.getMovies(url));
        expect(result, equals(const Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected to internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getMovies(url),
        ).thenThrow(const SocketException(connectionFailureMessage));
        // act
        final result = await repository.getMovies(url);
        // assert
        verify(mockRemoteDataSource.getMovies(url));
        expect(
          result,
          equals(const Left(ConnectionFailure(connectionFailureMessage))),
        );
      },
    );

    test('should return SSL failure when TlsException occurred', () async {
      // arrange
      when(mockRemoteDataSource.getMovies(url)).thenThrow(const TlsException());
      // act
      final result = await repository.getMovies(url);
      // assert
      verify(mockRemoteDataSource.getMovies(url));
      expect(result, equals(const Left(SSLFailure(sslFailureMessage))));
    });
  });

  group('Get Movie Detail', () {
    test(
      'should return Movie data when the call to remote data source is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getMovieDetail(testMovieId),
        ).thenAnswer((_) async => testMovieDetailResponse);
        // act
        final result = await repository.getMovieDetail(testMovieId);
        // assert
        verify(mockRemoteDataSource.getMovieDetail(testMovieId));
        expect(result, equals(const Right(testMovieDetail)));
      },
    );

    test(
      'should return Server Failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getMovieDetail(testMovieId),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getMovieDetail(testMovieId);
        // assert
        verify(mockRemoteDataSource.getMovieDetail(testMovieId));
        expect(result, equals(const Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected to internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getMovieDetail(testMovieId),
        ).thenThrow(const SocketException(connectionFailureMessage));
        // act
        final result = await repository.getMovieDetail(testMovieId);
        // assert
        verify(mockRemoteDataSource.getMovieDetail(testMovieId));
        expect(
          result,
          equals(const Left(ConnectionFailure(connectionFailureMessage))),
        );
      },
    );

    test('should return SSL failure when TlsException occurred', () async {
      // arrange
      when(
        mockRemoteDataSource.getMovieDetail(testMovieId),
      ).thenThrow(const TlsException());
      // act
      final result = await repository.getMovieDetail(testMovieId);
      // assert
      verify(mockRemoteDataSource.getMovieDetail(testMovieId));
      expect(result, equals(const Left(SSLFailure(sslFailureMessage))));
    });
  });

  group('Get Movie Recommendations', () {
    final tMovieList = <MovieModel>[];
    const testMovieId = 1;

    test('should return data (movie list) when the call is successful', () async {
      // arrange
      when(
        mockRemoteDataSource.getMovieRecommendations(testMovieId),
      ).thenAnswer((_) async => tMovieList);
      // act
      final result = await repository.getMovieRecommendations(testMovieId);
      // assert
      verify(mockRemoteDataSource.getMovieRecommendations(testMovieId));
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(tMovieList));
    });

    test(
      'should return server failure when call to remote data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getMovieRecommendations(testMovieId),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getMovieRecommendations(testMovieId);
        // assertbuild runner
        verify(mockRemoteDataSource.getMovieRecommendations(testMovieId));
        expect(result, equals(const Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected to the internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getMovieRecommendations(testMovieId),
        ).thenThrow(const SocketException(connectionFailureMessage));
        // act
        final result = await repository.getMovieRecommendations(testMovieId);
        // assert
        verify(mockRemoteDataSource.getMovieRecommendations(testMovieId));
        expect(
          result,
          equals(const Left(ConnectionFailure(connectionFailureMessage))),
        );
      },
    );

    test('should return SSL failure when TlsException occurred', () async {
      // arrange
      when(
        mockRemoteDataSource.getMovieRecommendations(testMovieId),
      ).thenThrow(const TlsException());
      // act
      final result = await repository.getMovieRecommendations(testMovieId);
      // assert
      verify(mockRemoteDataSource.getMovieRecommendations(testMovieId));
      expect(result, equals(const Left(SSLFailure(sslFailureMessage))));
    });
  });

  group('Seach Movies', () {
    const tQuery = 'spiderman';

    test(
      'should return movie list when call to data source is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.searchMovies(tQuery),
        ).thenAnswer((_) async => tMovieModelList);
        // act
        final result = await repository.searchMovies(tQuery);
        // assert
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, tMovieList);
      },
    );

    test(
      'should return ServerFailure when call to data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.searchMovies(tQuery),
        ).thenThrow(ServerException());
        // act
        final result = await repository.searchMovies(tQuery);
        // assert
        expect(result, const Left(ServerFailure('')));
      },
    );

    test(
      'should return ConnectionFailure when device is not connected to the internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.searchMovies(tQuery),
        ).thenThrow(const SocketException(connectionFailureMessage));
        // act
        final result = await repository.searchMovies(tQuery);
        // assert
        expect(result, const Left(ConnectionFailure(connectionFailureMessage)));
      },
    );

    test('should return SSL failure when TlsException occurred', () async {
      // arrange
      when(
        mockRemoteDataSource.searchMovies(tQuery),
      ).thenThrow(const TlsException());
      // act
      final result = await repository.searchMovies(tQuery);
      // assert
      verify(mockRemoteDataSource.searchMovies(tQuery));
      expect(result, equals(const Left(SSLFailure(sslFailureMessage))));
    });
  });

  group('Save watchlist', () {
    test(
      'should return success message when saving movies successful',
      () async {
        // arrange
        when(
          mockLocalDataSource.insertWatchlist(testWatchlistTableMovies),
        ).thenAnswer((_) async => 'Added to Watchlist');
        // act
        final result = await repository.saveWatchlistMovies(testMovieDetail);
        // assert
        expect(result, const Right('Added to Watchlist'));
      },
    );

    test(
      'should return DatabaseFailure when saving movies unsuccessful',
      () async {
        // arrange
        when(
          mockLocalDataSource.insertWatchlist(testWatchlistTableMovies),
        ).thenThrow(DatabaseException('Failed to add watchlist'));
        // act
        final result = await repository.saveWatchlistMovies(testMovieDetail);
        // assert
        expect(result, const Left(DatabaseFailure('Failed to add watchlist')));
      },
    );

    test(
      'should return success message when saving tv series successful',
      () async {
        // arrange
        when(
          mockLocalDataSource.insertWatchlist(testWatchlistTableTvSeries),
        ).thenAnswer((_) async => 'Added to Watchlist');
        // act
        final result = await repository.saveWatchlistTvSeries(
          testTvSeriesDetail,
        );
        // assert
        expect(result, const Right('Added to Watchlist'));
      },
    );

    test(
      'should return DatabaseFailure when saving tv series unsuccessful',
      () async {
        // arrange
        when(
          mockLocalDataSource.insertWatchlist(testWatchlistTableTvSeries),
        ).thenThrow(DatabaseException('Failed to add watchlist'));
        // act
        final result = await repository.saveWatchlistTvSeries(
          testTvSeriesDetail,
        );
        // assert
        expect(result, const Left(DatabaseFailure('Failed to add watchlist')));
      },
    );
  });

  group('Remove watchlist', () {
    test(
      'should return success message when removing movies successful',
      () async {
        // arrange
        when(
          mockLocalDataSource.removeWatchlist(testWatchlistTableMovies),
        ).thenAnswer((_) async => 'Removed from watchlist');
        // act
        final result = await repository.removeWatchlistMovies(testMovieDetail);
        // assert
        expect(result, const Right('Removed from watchlist'));
      },
    );

    test(
      'should return DatabaseFailure when removing movies unsuccessful',
      () async {
        // arrange
        when(
          mockLocalDataSource.removeWatchlist(testWatchlistTableMovies),
        ).thenThrow(DatabaseException('Failed to remove watchlist'));
        // act
        final result = await repository.removeWatchlistMovies(testMovieDetail);
        // assert
        expect(
          result,
          const Left(DatabaseFailure('Failed to remove watchlist')),
        );
      },
    );

    test(
      'should return success message when removing tv series successful',
      () async {
        // arrange
        when(
          mockLocalDataSource.removeWatchlist(testWatchlistTableTvSeries),
        ).thenAnswer((_) async => 'Removed from watchlist');
        // act
        final result = await repository.removeWatchlistTvSeries(
          testTvSeriesDetail,
        );
        // assert
        expect(result, const Right('Removed from watchlist'));
      },
    );

    test(
      'should return DatabaseFailure when removing tv series unsuccessful',
      () async {
        // arrange
        when(
          mockLocalDataSource.removeWatchlist(testWatchlistTableTvSeries),
        ).thenThrow(DatabaseException('Failed to remove watchlist'));
        // act
        final result = await repository.removeWatchlistTvSeries(
          testTvSeriesDetail,
        );
        // assert
        expect(
          result,
          const Left(DatabaseFailure('Failed to remove watchlist')),
        );
      },
    );
  });

  group('Get watchlist status', () {
    test('should return watch status whether data is found', () async {
      // arrange
      const testMovieId = 1;
      when(
        mockLocalDataSource.getWatchlistById(testMovieId),
      ).thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToWatchlist(testMovieId);
      // assert
      expect(result, false);
    });
  });

  group('Get watchlist data', () {
    test('should return list of Watchlist', () async {
      // arrange
      when(mockLocalDataSource.getWatchlist()).thenAnswer(
        (_) async => [testWatchlistTableMovies, testWatchlistTableTvSeries],
      );
      // act
      final result = await repository.getWatchlistData();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, testListOfWatchlist);
    });
  });

  // TV SERIES

  group('Get TV Series', () {
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTvSeries(url),
        ).thenAnswer((_) async => testTvSeriesModelList);
        // act
        final result = await repository.getTvSeries(url);
        // assert
        verify(mockRemoteDataSource.getTvSeries(url));
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, testTvSeriesList);
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTvSeries(url),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getTvSeries(url);
        // assert
        verify(mockRemoteDataSource.getTvSeries(url));
        expect(result, equals(const Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected to internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTvSeries(url),
        ).thenThrow(const SocketException(connectionFailureMessage));
        // act
        final result = await repository.getTvSeries(url);
        // assert
        verify(mockRemoteDataSource.getTvSeries(url));
        expect(
          result,
          equals(const Left(ConnectionFailure(connectionFailureMessage))),
        );
      },
    );

    test('should return SSL failure when TlsException occurred', () async {
      // arrange
      when(
        mockRemoteDataSource.getTvSeries(url),
      ).thenThrow(const TlsException());
      // act
      final result = await repository.getTvSeries(url);
      // assert
      verify(mockRemoteDataSource.getTvSeries(url));
      expect(result, equals(const Left(SSLFailure(sslFailureMessage))));
    });
  });

  group('TV Series Detail', () {
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTvSeriesDetail(testTvSeriesId),
        ).thenAnswer((_) async => testTvSeriesDetailResponse);
        // act
        final result = await repository.getTvSeriesDetail(testTvSeriesId);
        // assert
        verify(mockRemoteDataSource.getTvSeriesDetail(testTvSeriesId));
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => null);
        expect(resultList, testTvSeriesDetail);
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTvSeriesDetail(testTvSeriesId),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getTvSeriesDetail(testTvSeriesId);
        // assert
        verify(mockRemoteDataSource.getTvSeriesDetail(testTvSeriesId));
        expect(result, equals(const Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected to internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTvSeriesDetail(testTvSeriesId),
        ).thenThrow(const SocketException(connectionFailureMessage));
        // act
        final result = await repository.getTvSeriesDetail(testTvSeriesId);
        // assert
        verify(mockRemoteDataSource.getTvSeriesDetail(testTvSeriesId));
        expect(
          result,
          equals(const Left(ConnectionFailure(connectionFailureMessage))),
        );
      },
    );

    test('should return SSL failure when TlsException occurred', () async {
      // arrange
      when(
        mockRemoteDataSource.getTvSeriesDetail(testTvSeriesId),
      ).thenThrow(const TlsException());
      // act
      final result = await repository.getTvSeriesDetail(testTvSeriesId);
      // assert
      verify(mockRemoteDataSource.getTvSeriesDetail(testTvSeriesId));
      expect(result, equals(const Left(SSLFailure(sslFailureMessage))));
    });
  });

  group('TV Series Recommendations', () {
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTvSeriesRecommendations(testTvSeriesId),
        ).thenAnswer((_) async => testTvSeriesModelList);
        // act
        final result = await repository.getTvSeriesRecommendations(
          testTvSeriesId,
        );
        // assert
        verify(mockRemoteDataSource.getTvSeriesRecommendations(testTvSeriesId));
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, testTvSeriesList);
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTvSeriesRecommendations(testTvSeriesId),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getTvSeriesRecommendations(
          testTvSeriesId,
        );
        // assert
        verify(mockRemoteDataSource.getTvSeriesRecommendations(testTvSeriesId));
        expect(result, equals(const Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected to internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTvSeriesRecommendations(testTvSeriesId),
        ).thenThrow(const SocketException(connectionFailureMessage));
        // act
        final result = await repository.getTvSeriesRecommendations(
          testTvSeriesId,
        );
        // assert
        verify(mockRemoteDataSource.getTvSeriesRecommendations(testTvSeriesId));
        expect(
          result,
          equals(const Left(ConnectionFailure(connectionFailureMessage))),
        );
      },
    );

    test('should return SSL failure when TlsException occurred', () async {
      // arrange
      when(
        mockRemoteDataSource.getTvSeriesRecommendations(testTvSeriesId),
      ).thenThrow(const TlsException());
      // act
      final result = await repository.getTvSeriesRecommendations(
        testTvSeriesId,
      );
      // assert
      verify(mockRemoteDataSource.getTvSeriesRecommendations(testTvSeriesId));
      expect(result, equals(const Left(SSLFailure(sslFailureMessage))));
    });
  });

  group('Search TV Series', () {
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.searchTvSeries(testTvSeriesQuery),
        ).thenAnswer((_) async => testTvSeriesModelList);
        // act
        final result = await repository.searchTvSeries(testTvSeriesQuery);
        // assert
        verify(mockRemoteDataSource.searchTvSeries(testTvSeriesQuery));
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, testTvSeriesList);
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.searchTvSeries(testTvSeriesQuery),
        ).thenThrow(ServerException());
        // act
        final result = await repository.searchTvSeries(testTvSeriesQuery);
        // assert
        verify(mockRemoteDataSource.searchTvSeries(testTvSeriesQuery));
        expect(result, equals(const Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected to internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.searchTvSeries(testTvSeriesQuery),
        ).thenThrow(const SocketException(connectionFailureMessage));
        // act
        final result = await repository.searchTvSeries(testTvSeriesQuery);
        // assert
        verify(mockRemoteDataSource.searchTvSeries(testTvSeriesQuery));
        expect(
          result,
          equals(const Left(ConnectionFailure(connectionFailureMessage))),
        );
      },
    );

    test('should return SSL failure when TlsException occurred', () async {
      // arrange
      when(
        mockRemoteDataSource.searchTvSeries(testTvSeriesQuery),
      ).thenThrow(const TlsException());
      // act
      final result = await repository.searchTvSeries(testTvSeriesQuery);
      // assert
      verify(mockRemoteDataSource.searchTvSeries(testTvSeriesQuery));
      expect(result, equals(const Left(SSLFailure(sslFailureMessage))));
    });
  });

  group('TV Series Episodes', () {
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTvSeriesEpisode(testTvSeriesId, 1),
        ).thenAnswer((_) async => testTvSeriesEpisodeResponse);
        // act
        final result = await repository.getTvSeriesEpisode(testTvSeriesId, 1);
        // assert
        verify(mockRemoteDataSource.getTvSeriesEpisode(testTvSeriesId, 1));
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => null);
        expect(resultList, testTvSeriesEpisode);
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTvSeriesEpisode(testTvSeriesId, 1),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getTvSeriesEpisode(testTvSeriesId, 1);
        // assert
        verify(mockRemoteDataSource.getTvSeriesEpisode(testTvSeriesId, 1));
        expect(result, equals(const Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected to internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTvSeriesEpisode(testTvSeriesId, 1),
        ).thenThrow(const SocketException(connectionFailureMessage));
        // act
        final result = await repository.getTvSeriesEpisode(testTvSeriesId, 1);
        // assert
        verify(mockRemoteDataSource.getTvSeriesEpisode(testTvSeriesId, 1));
        expect(
          result,
          equals(const Left(ConnectionFailure(connectionFailureMessage))),
        );
      },
    );

    test('should return SSL failure when TlsException occurred', () async {
      // arrange
      when(
        mockRemoteDataSource.getTvSeriesEpisode(testTvSeriesId, 1),
      ).thenThrow(const TlsException());
      // act
      final result = await repository.getTvSeriesEpisode(testTvSeriesId, 1);
      // assert
      verify(mockRemoteDataSource.getTvSeriesEpisode(testTvSeriesId, 1));
      expect(result, equals(const Left(SSLFailure(sslFailureMessage))));
    });
  });
}
