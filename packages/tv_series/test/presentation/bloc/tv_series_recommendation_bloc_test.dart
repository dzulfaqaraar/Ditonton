import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/presentation/bloc/bloc_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/tv_series.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';
import 'tv_series_recommendation_bloc_test.mocks.dart';

@GenerateMocks([GetTvSeriesRecommendations])
void main() {
  late TvSeriesRecommendationBloc tvSeriesRecommendationBloc;
  late MockGetTvSeriesRecommendations mockGetTvSeriesRecommendations;

  setUp(() {
    mockGetTvSeriesRecommendations = MockGetTvSeriesRecommendations();
    tvSeriesRecommendationBloc = TvSeriesRecommendationBloc(
      mockGetTvSeriesRecommendations,
    );
  });

  test('initial state should be empty', () {
    expect(tvSeriesRecommendationBloc.state, BlocEmpty());
  });

  blocTest<TvSeriesRecommendationBloc, BlocState>(
    'Should emit [Loading, HasData] when data Recommendation is gotten successfully',
    build: () {
      when(
        mockGetTvSeriesRecommendations.execute(1),
      ).thenAnswer((_) async => Right(testTvSeriesList));
      return tvSeriesRecommendationBloc;
    },
    act: (bloc) => bloc.add(const OnFetchingRecommendation(1)),
    expect: () => [
      BlocLoading(),
      BlocHasData<List<TvSeries>>(testTvSeriesList),
    ],
    verify: (bloc) {
      verify(mockGetTvSeriesRecommendations.execute(1));
    },
  );

  blocTest<TvSeriesRecommendationBloc, BlocState>(
    'Should emit [Loading, Error] when data Recommendation is unsuccessful',
    build: () {
      when(
        mockGetTvSeriesRecommendations.execute(1),
      ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return tvSeriesRecommendationBloc;
    },
    act: (bloc) => bloc.add(const OnFetchingRecommendation(1)),
    expect: () => [BlocLoading(), const BlocError('Server Failure')],
    verify: (bloc) {
      verify(mockGetTvSeriesRecommendations.execute(1));
    },
  );
}
