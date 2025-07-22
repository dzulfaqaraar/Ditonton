import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/domain/usecases/get_tv_series_episode.dart';

import '../../../../core/test/helpers/test_helper.mocks.dart';
import '../../../../core/test/dummy_data/dummy_objects.dart';

void main() {
  late GetTvSeriesEpisode usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetTvSeriesEpisode(mockMovieRepository);
  });

  group('GetTvSeriesEpisode Tests', () {
    test('should get data for tv series episode from the repository', () async {
      // arrange
      when(
        mockMovieRepository.getTvSeriesEpisode(testTvSeriesId, 1),
      ).thenAnswer((_) async => const Right(testTvSeriesEpisode));
      // act
      final result = await usecase.execute(testTvSeriesId, 1);
      // assert
      expect(result, const Right(testTvSeriesEpisode));
    });
  });
}
