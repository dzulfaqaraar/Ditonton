import 'dart:io';

import 'package:core/core.dart';
import 'package:dartz/dartz.dart';

import '../models/watchlist_table.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;
  final MovieLocalDataSource localDataSource;

  static const connectionFailureMessage = 'Failed to connect to the network';
  static const sslFailureMessage = 'Failed to verify the internet connection';

  MovieRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  // Movies

  @override
  Future<Either<Failure, List<Movie>>> getMovies(String url) async {
    try {
      final result = await remoteDataSource.getMovies(url);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure(connectionFailureMessage));
    } on TlsException {
      return const Left(SSLFailure(sslFailureMessage));
    }
  }

  @override
  Future<Either<Failure, MovieDetail>> getMovieDetail(int id) async {
    try {
      final result = await remoteDataSource.getMovieDetail(id);
      return Right(result.toEntity());
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure(connectionFailureMessage));
    } on TlsException {
      return const Left(SSLFailure(sslFailureMessage));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getMovieRecommendations(int id) async {
    try {
      final result = await remoteDataSource.getMovieRecommendations(id);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure(connectionFailureMessage));
    } on TlsException {
      return const Left(SSLFailure(sslFailureMessage));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> searchMovies(String query) async {
    try {
      final result = await remoteDataSource.searchMovies(query);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure(connectionFailureMessage));
    } on TlsException {
      return const Left(SSLFailure(sslFailureMessage));
    }
  }

  // TV Series

  @override
  Future<Either<Failure, List<TvSeries>>> getTvSeries(String url) async {
    try {
      final result = await remoteDataSource.getTvSeries(url);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure(connectionFailureMessage));
    } on TlsException {
      return const Left(SSLFailure(sslFailureMessage));
    }
  }

  @override
  Future<Either<Failure, TvSeriesDetail?>> getTvSeriesDetail(int id) async {
    try {
      final result = await remoteDataSource.getTvSeriesDetail(id);
      return Right(result.toEntity());
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure(connectionFailureMessage));
    } on TlsException {
      return const Left(SSLFailure(sslFailureMessage));
    }
  }

  @override
  Future<Either<Failure, List<TvSeries>>> getTvSeriesRecommendations(
    int id,
  ) async {
    try {
      final result = await remoteDataSource.getTvSeriesRecommendations(id);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure(connectionFailureMessage));
    } on TlsException {
      return const Left(SSLFailure(sslFailureMessage));
    }
  }

  @override
  Future<Either<Failure, List<TvSeries>>> searchTvSeries(String query) async {
    try {
      final result = await remoteDataSource.searchTvSeries(query);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure(connectionFailureMessage));
    } on TlsException {
      return const Left(SSLFailure(sslFailureMessage));
    }
  }

  @override
  Future<Either<Failure, TvSeriesEpisode?>> getTvSeriesEpisode(
    int id,
    int season,
  ) async {
    try {
      final result = await remoteDataSource.getTvSeriesEpisode(id, season);
      return Right(result.toEntity());
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure(connectionFailureMessage));
    } on TlsException {
      return const Left(SSLFailure(sslFailureMessage));
    }
  }

  // Other

  @override
  Future<bool> isAddedToWatchlist(int id) async {
    final result = await localDataSource.getWatchlistById(id);
    return result != null;
  }

  @override
  Future<Either<Failure, List<Watchlist>>> getWatchlistData() async {
    final result = await localDataSource.getWatchlist();
    return Right(result.map((data) => data.toEntity()).toList());
  }

  @override
  Future<Either<Failure, String>> saveWatchlistMovies(MovieDetail movie) async {
    try {
      final result = await localDataSource.insertWatchlist(
        WatchlistTable.fromEntityMovies(movie),
      );
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<Failure, String>> removeWatchlistMovies(
    MovieDetail movie,
  ) async {
    try {
      final result = await localDataSource.removeWatchlist(
        WatchlistTable.fromEntityMovies(movie),
      );
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> saveWatchlistTvSeries(
    TvSeriesDetail? tvSeries,
  ) async {
    try {
      final result = await localDataSource.insertWatchlist(
        WatchlistTable.fromEntityTvSeries(tvSeries),
      );
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<Failure, String>> removeWatchlistTvSeries(
    TvSeriesDetail? tvSeries,
  ) async {
    try {
      final result = await localDataSource.removeWatchlist(
        WatchlistTable.fromEntityTvSeries(tvSeries),
      );
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }
}
