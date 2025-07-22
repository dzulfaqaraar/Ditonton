import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/domain/usecases/get_tv_series_detail.dart';

import '../../../../core/test/helpers/test_helper.mocks.dart';
import '../../../../core/test/dummy_data/dummy_objects.dart';

void main() {
  late GetTvSeriesDetail usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetTvSeriesDetail(mockMovieRepository);
  });

  group('GetTvSeriesDetail Tests', () {
    test('should get data for tv series detail from the repository', () async {
      // arrange
      when(
        mockMovieRepository.getTvSeriesDetail(testTvSeriesId),
      ).thenAnswer((_) async => const Right(testTvSeriesDetail));
      // act
      final result = await usecase.execute(testTvSeriesId);
      // assert
      expect(result, const Right(testTvSeriesDetail));
    });
  });
}
