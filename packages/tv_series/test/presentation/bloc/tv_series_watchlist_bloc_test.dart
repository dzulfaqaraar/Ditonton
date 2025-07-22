import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/presentation/bloc/bloc_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/tv_series.dart';
import 'package:watchlist/watchlist.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';
import 'tv_series_watchlist_bloc_test.mocks.dart';

@GenerateMocks([
  GetWatchListStatus,
  SaveWatchlistTvSeries,
  RemoveWatchlistTvSeries,
])
void main() {
  late TvSeriesWatchlistBloc tvSeriesWatchlistBloc;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlistTvSeries mockSaveWatchlistTvSeries;
  late MockRemoveWatchlistTvSeries mockRemoveWatchlistTvSeries;

  String addedMessage = 'Added to Watchlist';
  String removedMessage = 'Removed from Watchlist';
  String failedAddingWatchlist = 'Failed to add watchlist';
  String failedRemovingWatchlist = 'Failed to remove watchlist';

  setUp(() {
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlistTvSeries = MockSaveWatchlistTvSeries();
    mockRemoveWatchlistTvSeries = MockRemoveWatchlistTvSeries();
    tvSeriesWatchlistBloc = TvSeriesWatchlistBloc(
      getWatchListStatus: mockGetWatchListStatus,
      saveWatchlist: mockSaveWatchlistTvSeries,
      removeWatchlist: mockRemoveWatchlistTvSeries,
    );
  });

  test('initial state should be empty', () {
    expect(tvSeriesWatchlistBloc.state, BlocEmpty());
  });

  blocTest<TvSeriesWatchlistBloc, BlocState>(
    'Should emit [HasMessage] when loading Watchlist is gotten successfully',
    build: () {
      when(mockGetWatchListStatus.execute(1)).thenAnswer((_) async => true);
      return tvSeriesWatchlistBloc;
    },
    act: (bloc) => bloc.add(const OnLoadingWatchlist(1)),
    expect: () => [const TvSeriesWatchlistHasMessage(true, null)],
    verify: (bloc) {
      verify(mockGetWatchListStatus.execute(1));
    },
  );

  blocTest<TvSeriesWatchlistBloc, BlocState>(
    'Should emit [HasMessage] when adding Watchlist is successfully',
    build: () {
      when(mockGetWatchListStatus.execute(1)).thenAnswer((_) async => true);
      when(
        mockSaveWatchlistTvSeries.execute(testTvSeriesDetail),
      ).thenAnswer((_) async => Right(addedMessage));
      return tvSeriesWatchlistBloc;
    },
    act: (bloc) => bloc.add(const OnAddingWatchlist(testTvSeriesDetail)),
    expect: () => [TvSeriesWatchlistHasMessage(true, addedMessage)],
    verify: (bloc) {
      verify(mockSaveWatchlistTvSeries.execute(testTvSeriesDetail));
    },
  );

  blocTest<TvSeriesWatchlistBloc, BlocState>(
    'Should emit [HasMessage] when adding Watchlist is unsuccessfully',
    build: () {
      when(mockGetWatchListStatus.execute(1)).thenAnswer((_) async => false);
      when(
        mockSaveWatchlistTvSeries.execute(testTvSeriesDetail),
      ).thenAnswer((_) async => Left(DatabaseFailure(failedAddingWatchlist)));
      return tvSeriesWatchlistBloc;
    },
    act: (bloc) => bloc.add(const OnAddingWatchlist(testTvSeriesDetail)),
    expect: () => [TvSeriesWatchlistHasMessage(false, failedAddingWatchlist)],
    verify: (bloc) {
      verify(mockSaveWatchlistTvSeries.execute(testTvSeriesDetail));
    },
  );

  blocTest<TvSeriesWatchlistBloc, BlocState>(
    'Should emit [HasMessage] when removing Watchlist is successfully',
    build: () {
      when(mockGetWatchListStatus.execute(1)).thenAnswer((_) async => true);
      when(
        mockRemoveWatchlistTvSeries.execute(testTvSeriesDetail),
      ).thenAnswer((_) async => Right(removedMessage));
      return tvSeriesWatchlistBloc;
    },
    act: (bloc) => bloc.add(const OnRemovingWatchlist(testTvSeriesDetail)),
    expect: () => [TvSeriesWatchlistHasMessage(true, removedMessage)],
    verify: (bloc) {
      verify(mockRemoveWatchlistTvSeries.execute(testTvSeriesDetail));
    },
  );

  blocTest<TvSeriesWatchlistBloc, BlocState>(
    'Should emit [HasMessage] when removing Watchlist is unsuccessfully',
    build: () {
      when(mockGetWatchListStatus.execute(1)).thenAnswer((_) async => false);
      when(
        mockRemoveWatchlistTvSeries.execute(testTvSeriesDetail),
      ).thenAnswer((_) async => Left(DatabaseFailure(failedRemovingWatchlist)));
      return tvSeriesWatchlistBloc;
    },
    act: (bloc) => bloc.add(const OnRemovingWatchlist(testTvSeriesDetail)),
    expect: () => [TvSeriesWatchlistHasMessage(false, failedRemovingWatchlist)],
    verify: (bloc) {
      verify(mockRemoveWatchlistTvSeries.execute(testTvSeriesDetail));
    },
  );
}
