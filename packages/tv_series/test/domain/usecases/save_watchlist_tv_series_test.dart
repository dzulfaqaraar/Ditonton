import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/domain/usecases/save_watchlist_tv_series.dart';

import '../../../../core/test/helpers/test_helper.mocks.dart';
import '../../../../core/test/dummy_data/dummy_objects.dart';

void main() {
  late SaveWatchlistTvSeries usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = SaveWatchlistTvSeries(mockMovieRepository);
  });

  test('should save tv series to the repository', () async {
    // arrange
    when(
      mockMovieRepository.saveWatchlistTvSeries(testTvSeriesDetail),
    ).thenAnswer((_) async => const Right('Added to Watchlist'));
    // act
    final result = await usecase.execute(testTvSeriesDetail);
    // assert
    verify(mockMovieRepository.saveWatchlistTvSeries(testTvSeriesDetail));
    expect(result, const Right('Added to Watchlist'));
  });
}
