import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/domain/usecases/get_tv_series_recommendations.dart';

import '../../../../core/test/helpers/test_helper.mocks.dart';
import '../../../../core/test/dummy_data/dummy_objects.dart';

void main() {
  late GetTvSeriesRecommendations usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetTvSeriesRecommendations(mockMovieRepository);
  });

  group('GetTvSeriesRecommendations Tests', () {
    test('should get list of tv series from the repository', () async {
      // arrange
      when(
        mockMovieRepository.getTvSeriesRecommendations(testTvSeriesId),
      ).thenAnswer((_) async => Right(testTvSeriesList));
      // act
      final result = await usecase.execute(testTvSeriesId);
      // assert
      expect(result, Right(testTvSeriesList));
    });
  });
}
