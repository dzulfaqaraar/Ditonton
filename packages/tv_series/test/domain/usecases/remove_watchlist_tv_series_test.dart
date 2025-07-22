import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/domain/usecases/remove_watchlist_tv_series.dart';

import '../../../../core/test/helpers/test_helper.mocks.dart';
import '../../../../core/test/dummy_data/dummy_objects.dart';

void main() {
  late RemoveWatchlistTvSeries usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = RemoveWatchlistTvSeries(mockMovieRepository);
  });

  test('should remove watchlist tv series from repository', () async {
    // arrange
    when(
      mockMovieRepository.removeWatchlistTvSeries(testTvSeriesDetail),
    ).thenAnswer((_) async => const Right('Removed from watchlist'));
    // act
    final result = await usecase.execute(testTvSeriesDetail);
    // assert
    verify(mockMovieRepository.removeWatchlistTvSeries(testTvSeriesDetail));
    expect(result, const Right('Removed from watchlist'));
  });
}
