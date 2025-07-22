import 'dart:convert';

import 'package:core/core.dart';
import 'package:core/data/models/movie_detail_model.dart';
import 'package:core/data/models/movie_response.dart';
import 'package:core/data/models/tv_series_detail_response.dart';
import 'package:core/data/models/tv_series_episode_response.dart';
import 'package:core/data/models/tv_series_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../json_reader.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late String apiKey;
  late String baseUrl;

  late MovieRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Set up environment variables for testing
    dotenv.testLoad(
      mergeWith: {
        'BASE_URL': 'https://api.themoviedb.org/3',
        'API_KEY': 'test_api_key_for_testing',
      },
    );
    baseUrl = dotenv.env['BASE_URL']!;
    apiKey = 'api_key=${dotenv.env['API_KEY']}';

    mockHttpClient = MockHttpClient();
    dataSource = MovieRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get Now Playing Movies', () {
    final tMovieList = MovieResponse.fromJson(
      json.decode(readJson('dummy_data/movie_now_playing.json')),
    ).movieList;

    test(
      'should return list of Movie Model when the response code is 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/movie/now_playing?$apiKey')),
        ).thenAnswer(
          (_) async =>
              http.Response(readJson('dummy_data/movie_now_playing.json'), 200),
        );
        // act
        final result = await dataSource.getMovies('/movie/now_playing');
        // assert
        expect(result, equals(tMovieList));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/movie/now_playing?$apiKey')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getMovies('/movie/now_playing');
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get Popular Movies', () {
    final tMovieList = MovieResponse.fromJson(
      json.decode(readJson('dummy_data/movie_popular.json')),
    ).movieList;

    test(
      'should return list of movies when response is success (200)',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/movie/popular?$apiKey')),
        ).thenAnswer(
          (_) async =>
              http.Response(readJson('dummy_data/movie_popular.json'), 200),
        );
        // act
        final result = await dataSource.getMovies('/movie/popular');
        // assert
        expect(result, tMovieList);
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/movie/popular?$apiKey')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getMovies('/movie/popular');
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get Top Rated Movies', () {
    final tMovieList = MovieResponse.fromJson(
      json.decode(readJson('dummy_data/movie_top_rated.json')),
    ).movieList;

    test('should return list of movies when response code is 200 ', () async {
      // arrange
      when(
        mockHttpClient.get(Uri.parse('$baseUrl/movie/top_rated?$apiKey')),
      ).thenAnswer(
        (_) async =>
            http.Response(readJson('dummy_data/movie_top_rated.json'), 200),
      );
      // act
      final result = await dataSource.getMovies('/movie/top_rated');
      // assert
      expect(result, tMovieList);
    });

    test(
      'should throw ServerException when response code is other than 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/movie/top_rated?$apiKey')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getMovies('/movie/top_rated');
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get movie detail', () {
    const tId = 1;
    final tMovieDetail = MovieDetailResponse.fromJson(
      json.decode(readJson('dummy_data/movie_detail.json')),
    );

    test('should return movie detail when the response code is 200', () async {
      // arrange
      when(
        mockHttpClient.get(Uri.parse('$baseUrl/movie/$tId?$apiKey')),
      ).thenAnswer(
        (_) async =>
            http.Response(readJson('dummy_data/movie_detail.json'), 200),
      );
      // act
      final result = await dataSource.getMovieDetail(tId);
      // assert
      expect(result, equals(tMovieDetail));
    });

    test(
      'should throw Server Exception when the response code is 404 or other',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/movie/$tId?$apiKey')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getMovieDetail(tId);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get movie recommendations', () {
    final tMovieList = MovieResponse.fromJson(
      json.decode(readJson('dummy_data/movie_recommendations.json')),
    ).movieList;
    const tId = 1;

    test(
      'should return list of Movie Model when the response code is 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(
            Uri.parse('$baseUrl/movie/$tId/recommendations?$apiKey'),
          ),
        ).thenAnswer(
          (_) async => http.Response(
            readJson('dummy_data/movie_recommendations.json'),
            200,
          ),
        );
        // act
        final result = await dataSource.getMovieRecommendations(tId);
        // assert
        expect(result, equals(tMovieList));
      },
    );

    test(
      'should throw Server Exception when the response code is 404 or other',
      () async {
        // arrange
        when(
          mockHttpClient.get(
            Uri.parse('$baseUrl/movie/$tId/recommendations?$apiKey'),
          ),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getMovieRecommendations(tId);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('search movies', () {
    final tSearchResult = MovieResponse.fromJson(
      json.decode(readJson('dummy_data/search_spiderman_movie.json')),
    ).movieList;
    const tQuery = 'Spiderman';

    test('should return list of movies when response code is 200', () async {
      // arrange
      when(
        mockHttpClient.get(
          Uri.parse('$baseUrl/search/movie?$apiKey&query=$tQuery'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          readJson('dummy_data/search_spiderman_movie.json'),
          200,
        ),
      );
      // act
      final result = await dataSource.searchMovies(tQuery);
      // assert
      expect(result, tSearchResult);
    });

    test(
      'should throw ServerException when response code is other than 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(
            Uri.parse('$baseUrl/search/movie?$apiKey&query=$tQuery'),
          ),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.searchMovies(tQuery);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  // TV SERIES

  group('get Airing Today TV Series', () {
    final tvSeriesList = TvSeriesResponse.fromJson(
      json.decode(readJson('dummy_data/tv_series_airing_today.json')),
    ).tvSeriesList;

    test(
      'should return list of TV Series Model when the response code is 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/tv/airing_today?$apiKey')),
        ).thenAnswer(
          (_) async => http.Response(
            readJson('dummy_data/tv_series_airing_today.json'),
            200,
          ),
        );
        // act
        final result = await dataSource.getTvSeries('/tv/airing_today');
        // assert
        expect(result, equals(tvSeriesList));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/tv/airing_today?$apiKey')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getTvSeries('/tv/airing_today');
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get Popular TV Series', () {
    final tvSeriesList = TvSeriesResponse.fromJson(
      json.decode(readJson('dummy_data/tv_series_popular.json')),
    ).tvSeriesList;

    test(
      'should return list of TV Series Model when the response code is 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/tv/popular?$apiKey')),
        ).thenAnswer(
          (_) async =>
              http.Response(readJson('dummy_data/tv_series_popular.json'), 200),
        );
        // act
        final result = await dataSource.getTvSeries('/tv/popular');
        // assert
        expect(result, equals(tvSeriesList));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/tv/popular?$apiKey')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getTvSeries('/tv/popular');
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get Top Rated TV Series', () {
    final tvSeriesList = TvSeriesResponse.fromJson(
      json.decode(readJson('dummy_data/tv_series_top_rated.json')),
    ).tvSeriesList;

    test(
      'should return list of TV Series Model when the response code is 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/tv/top_rated?$apiKey')),
        ).thenAnswer(
          (_) async => http.Response(
            readJson('dummy_data/tv_series_top_rated.json'),
            200,
          ),
        );
        // act
        final result = await dataSource.getTvSeries('/tv/top_rated');
        // assert
        expect(result, equals(tvSeriesList));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/tv/top_rated?$apiKey')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getTvSeries('/tv/top_rated');
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get TV Series Detail', () {
    final tvSeriesDetail = TvSeriesDetailResponse.fromJson(
      json.decode(readJson('dummy_data/tv_series_detail.json')),
    );
    const tvSeriesId = 1;

    test(
      'should return list of TV Series Model when the response code is 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/tv/$tvSeriesId?$apiKey')),
        ).thenAnswer(
          (_) async =>
              http.Response(readJson('dummy_data/tv_series_detail.json'), 200),
        );
        // act
        final result = await dataSource.getTvSeriesDetail(tvSeriesId);
        // assert
        expect(result, equals(tvSeriesDetail));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/tv/$tvSeriesId?$apiKey')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getTvSeriesDetail(tvSeriesId);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get TV Series Recommendations', () {
    final tvSeriesList = TvSeriesResponse.fromJson(
      json.decode(readJson('dummy_data/tv_series_recommendations.json')),
    ).tvSeriesList;
    const tvSeriesId = 1;

    test(
      'should return list of TV Series Model when the response code is 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(
            Uri.parse('$baseUrl/tv/$tvSeriesId/recommendations?$apiKey'),
          ),
        ).thenAnswer(
          (_) async => http.Response(
            readJson('dummy_data/tv_series_recommendations.json'),
            200,
          ),
        );
        // act
        final result = await dataSource.getTvSeriesRecommendations(tvSeriesId);
        // assert
        expect(result, equals(tvSeriesList));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(
          mockHttpClient.get(
            Uri.parse('$baseUrl/tv/$tvSeriesId/recommendations?$apiKey'),
          ),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getTvSeriesRecommendations(tvSeriesId);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('search TV Series', () {
    final tvSeriesList = TvSeriesResponse.fromJson(
      json.decode(readJson('dummy_data/search_hospital_tv_series.json')),
    ).tvSeriesList;
    const query = 'hospital';

    test(
      'should return list of TV Series Model when the response code is 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(
            Uri.parse('$baseUrl/search/tv?$apiKey&query=$query'),
          ),
        ).thenAnswer(
          (_) async => http.Response(
            readJson('dummy_data/search_hospital_tv_series.json'),
            200,
          ),
        );
        // act
        final result = await dataSource.searchTvSeries(query);
        // assert
        expect(result, equals(tvSeriesList));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(
          mockHttpClient.get(
            Uri.parse('$baseUrl/search/tv?$apiKey&query=$query'),
          ),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.searchTvSeries(query);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get TV Series Episodes', () {
    final tvSeriesEpisode = TvSeriesEpisodeResponse.fromJson(
      json.decode(readJson('dummy_data/tv_series_episode.json')),
    );
    const tvSeriesId = 1;

    test(
      'should return list of Episodes for TV Series when the response code is 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(
            Uri.parse('$baseUrl/tv/$tvSeriesId/season/1?$apiKey'),
          ),
        ).thenAnswer(
          (_) async =>
              http.Response(readJson('dummy_data/tv_series_episode.json'), 200),
        );
        // act
        final result = await dataSource.getTvSeriesEpisode(tvSeriesId, 1);
        // assert
        expect(result, equals(tvSeriesEpisode));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(
          mockHttpClient.get(
            Uri.parse('$baseUrl/tv/$tvSeriesId/season/1?$apiKey'),
          ),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getTvSeriesEpisode(tvSeriesId, 1);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });
}
