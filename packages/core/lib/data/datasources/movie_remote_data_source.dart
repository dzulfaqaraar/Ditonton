import 'dart:convert';

import 'package:core/core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/io_client.dart';

import '../models/movie_detail_model.dart';
import '../models/movie_model.dart';
import '../models/movie_response.dart';
import '../models/tv_series_detail_response.dart';
import '../models/tv_series_episode_response.dart';
import '../models/tv_series_model.dart';
import '../models/tv_series_response.dart';

abstract class MovieRemoteDataSource {
  // Movies
  Future<List<MovieModel>> getMovies(String url);
  Future<MovieDetailResponse> getMovieDetail(int id);
  Future<List<MovieModel>> getMovieRecommendations(int id);
  Future<List<MovieModel>> searchMovies(String query);

  // TV Series
  Future<List<TvSeriesModel>> getTvSeries(String url);
  Future<TvSeriesDetailResponse> getTvSeriesDetail(int id);
  Future<List<TvSeriesModel>> getTvSeriesRecommendations(int id);
  Future<List<TvSeriesModel>> searchTvSeries(String query);
  Future<TvSeriesEpisodeResponse> getTvSeriesEpisode(int id, int season);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  static String get baseUrl =>
      dotenv.env['BASE_URL'] ?? 'https://api.themoviedb.org/3';
  static String get apiKey => 'api_key=${dotenv.env['API_KEY']}';

  IOClient client;

  MovieRemoteDataSourceImpl({required this.client});

  // Movies

  @override
  Future<List<MovieModel>> getMovies(String url) async {
    final response = await client.get(Uri.parse('$baseUrl$url?$apiKey'));

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<MovieDetailResponse> getMovieDetail(int id) async {
    final response = await client.get(Uri.parse('$baseUrl/movie/$id?$apiKey'));

    if (response.statusCode == 200) {
      return MovieDetailResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MovieModel>> getMovieRecommendations(int id) async {
    final response = await client.get(
      Uri.parse('$baseUrl/movie/$id/recommendations?$apiKey'),
    );

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    final response = await client.get(
      Uri.parse('$baseUrl/search/movie?$apiKey&query=$query'),
    );

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      throw ServerException();
    }
  }

  // TV Series

  @override
  Future<List<TvSeriesModel>> getTvSeries(String url) async {
    final response = await client.get(Uri.parse('$baseUrl$url?$apiKey'));

    if (response.statusCode == 200) {
      return TvSeriesResponse.fromJson(json.decode(response.body)).tvSeriesList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TvSeriesDetailResponse> getTvSeriesDetail(int id) async {
    final response = await client.get(Uri.parse('$baseUrl/tv/$id?$apiKey'));

    if (response.statusCode == 200) {
      return TvSeriesDetailResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvSeriesModel>> getTvSeriesRecommendations(int id) async {
    final response = await client.get(
      Uri.parse('$baseUrl/tv/$id/recommendations?$apiKey'),
    );

    if (response.statusCode == 200) {
      return TvSeriesResponse.fromJson(json.decode(response.body)).tvSeriesList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvSeriesModel>> searchTvSeries(String query) async {
    final response = await client.get(
      Uri.parse('$baseUrl/search/tv?$apiKey&query=$query'),
    );

    if (response.statusCode == 200) {
      return TvSeriesResponse.fromJson(json.decode(response.body)).tvSeriesList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TvSeriesEpisodeResponse> getTvSeriesEpisode(int id, int season) async {
    final response = await client.get(
      Uri.parse('$baseUrl/tv/$id/season/$season?$apiKey'),
    );

    if (response.statusCode == 200) {
      return TvSeriesEpisodeResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
