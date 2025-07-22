import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/presentation/bloc/bloc_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:watchlist/watchlist.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';
import 'watchlist_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistData])
void main() {
  late WatchlistBloc watchlistBloc;
  late MockGetWatchlistData mockGetWatchlistData;

  setUp(() {
    mockGetWatchlistData = MockGetWatchlistData();
    watchlistBloc = WatchlistBloc(mockGetWatchlistData);
  });

  test('initial state should be empty', () {
    expect(watchlistBloc.state, BlocEmpty());
  });

  blocTest<WatchlistBloc, BlocState>(
    'Should emit [Loading, HasData] when data watchlist is gotten successfully',
    build: () {
      when(
        mockGetWatchlistData.execute(),
      ).thenAnswer((_) async => Right(testListOfWatchlist));
      return watchlistBloc;
    },
    act: (bloc) => bloc.add(const OnFetchingData()),
    expect: () => [BlocLoading(), BlocHasData(testListOfWatchlist)],
    verify: (bloc) {
      verify(mockGetWatchlistData.execute());
    },
  );

  blocTest<WatchlistBloc, BlocState>(
    'Should emit [Loading, Error] when get search watchlist is unsuccessful',
    build: () {
      when(
        mockGetWatchlistData.execute(),
      ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return watchlistBloc;
    },
    act: (bloc) => bloc.add(const OnFetchingData()),
    expect: () => [BlocLoading(), const BlocError('Server Failure')],
    verify: (bloc) {
      verify(mockGetWatchlistData.execute());
    },
  );
}
