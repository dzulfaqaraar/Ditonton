import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/usecase/get_tvseries.dart';
import 'package:core/presentation/bloc/bloc_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/tv_series.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';
import 'airing_today_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetTvSeries])
void main() {
  late AiringTodayTvSeriesBloc airingTodayTvSeriesBloc;
  late MockGetTvSeries mockGetTvSeries;

  const url = '/tv/airing_today';

  setUp(() {
    mockGetTvSeries = MockGetTvSeries();
    airingTodayTvSeriesBloc = AiringTodayTvSeriesBloc(mockGetTvSeries);
  });

  test('initial state should be empty', () {
    expect(airingTodayTvSeriesBloc.state, BlocEmpty());
  });

  blocTest<AiringTodayTvSeriesBloc, BlocState>(
    'Should emit [Loading, HasData] when data Airing Today is gotten successfully',
    build: () {
      when(
        mockGetTvSeries.execute(url),
      ).thenAnswer((_) async => Right(testTvSeriesList));
      return airingTodayTvSeriesBloc;
    },
    act: (bloc) => bloc.add(const OnFetchingAiringToday()),
    expect: () => [BlocLoading(), BlocHasData(testTvSeriesList)],
    verify: (bloc) {
      verify(mockGetTvSeries.execute(url));
    },
  );

  blocTest<AiringTodayTvSeriesBloc, BlocState>(
    'Should emit [Loading, Error] when data Airing Today is unsuccessful',
    build: () {
      when(
        mockGetTvSeries.execute(url),
      ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return airingTodayTvSeriesBloc;
    },
    act: (bloc) => bloc.add(const OnFetchingAiringToday()),
    expect: () => [BlocLoading(), const BlocError('Server Failure')],
    verify: (bloc) {
      verify(mockGetTvSeries.execute(url));
    },
  );
}
