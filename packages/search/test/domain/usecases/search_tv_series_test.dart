import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:search/domain/usecases/search_tv_series.dart';

import '../../../../core/test/helpers/test_helper.mocks.dart';
import '../../../../core/test/dummy_data/dummy_objects.dart';

void main() {
  late SearchTvSeries usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = SearchTvSeries(mockMovieRepository);
  });

  group('SearchTvSeries Tests', () {
    test('should get list of tv series from the repository', () async {
      // arrange
      when(
        mockMovieRepository.searchTvSeries(testTvSeriesQuery),
      ).thenAnswer((_) async => Right(testTvSeriesList));
      // act
      final result = await usecase.execute(testTvSeriesQuery);
      // assert
      expect(result, Right(testTvSeriesList));
    });
  });
}
