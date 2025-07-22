import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/presentation/bloc/bloc_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movies/movies.dart';
import 'package:watchlist/domain/usecases/get_watchlist_status.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';
import 'movie_watchlist_bloc_test.mocks.dart';

@GenerateMocks([GetWatchListStatus, SaveWatchlistMovies, RemoveWatchlistMovies])
void main() {
  late MovieWatchlistBloc movieWatchlistBloc;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlistMovies mockSaveWatchlistMovies;
  late MockRemoveWatchlistMovies mockRemoveWatchlistMovies;

  String addedMessage = 'Added to Watchlist';
  String removedMessage = 'Removed from Watchlist';
  String failedAddingWatchlist = 'Failed to add watchlist';
  String failedRemovingWatchlist = 'Failed to remove watchlist';

  setUp(() {
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlistMovies = MockSaveWatchlistMovies();
    mockRemoveWatchlistMovies = MockRemoveWatchlistMovies();
    movieWatchlistBloc = MovieWatchlistBloc(
      getWatchListStatus: mockGetWatchListStatus,
      saveWatchlist: mockSaveWatchlistMovies,
      removeWatchlist: mockRemoveWatchlistMovies,
    );
  });

  test('initial state should be empty', () {
    expect(movieWatchlistBloc.state, BlocEmpty());
  });

  blocTest<MovieWatchlistBloc, BlocState>(
    'Should emit [HasMessage] when loading Watchlist is gotten successfully',
    build: () {
      when(mockGetWatchListStatus.execute(1)).thenAnswer((_) async => true);
      return movieWatchlistBloc;
    },
    act: (bloc) => bloc.add(const OnLoadingWatchlist(1)),
    expect: () => [const MovieWatchlistHasMessage(true, null)],
    verify: (bloc) {
      verify(mockGetWatchListStatus.execute(1));
    },
  );

  blocTest<MovieWatchlistBloc, BlocState>(
    'Should emit [HasMessage] when adding Watchlist is successfully',
    build: () {
      when(mockGetWatchListStatus.execute(1)).thenAnswer((_) async => true);
      when(
        mockSaveWatchlistMovies.execute(testMovieDetail),
      ).thenAnswer((_) async => Right(addedMessage));
      return movieWatchlistBloc;
    },
    act: (bloc) => bloc.add(const OnAddingWatchlist(testMovieDetail)),
    expect: () => [MovieWatchlistHasMessage(true, addedMessage)],
    verify: (bloc) {
      verify(mockSaveWatchlistMovies.execute(testMovieDetail));
    },
  );

  blocTest<MovieWatchlistBloc, BlocState>(
    'Should emit [HasMessage] when adding Watchlist is unsuccessfully',
    build: () {
      when(mockGetWatchListStatus.execute(1)).thenAnswer((_) async => false);
      when(
        mockSaveWatchlistMovies.execute(testMovieDetail),
      ).thenAnswer((_) async => Left(DatabaseFailure(failedAddingWatchlist)));
      return movieWatchlistBloc;
    },
    act: (bloc) => bloc.add(const OnAddingWatchlist(testMovieDetail)),
    expect: () => [MovieWatchlistHasMessage(false, failedAddingWatchlist)],
    verify: (bloc) {
      verify(mockSaveWatchlistMovies.execute(testMovieDetail));
    },
  );

  blocTest<MovieWatchlistBloc, BlocState>(
    'Should emit [HasMessage] when removing Watchlist is successfully',
    build: () {
      when(mockGetWatchListStatus.execute(1)).thenAnswer((_) async => true);
      when(
        mockRemoveWatchlistMovies.execute(testMovieDetail),
      ).thenAnswer((_) async => Right(removedMessage));
      return movieWatchlistBloc;
    },
    act: (bloc) => bloc.add(const OnRemovingWatchlist(testMovieDetail)),
    expect: () => [MovieWatchlistHasMessage(true, removedMessage)],
    verify: (bloc) {
      verify(mockRemoveWatchlistMovies.execute(testMovieDetail));
    },
  );

  blocTest<MovieWatchlistBloc, BlocState>(
    'Should emit [HasMessage] when removing Watchlist is unsuccessfully',
    build: () {
      when(mockGetWatchListStatus.execute(1)).thenAnswer((_) async => false);
      when(
        mockRemoveWatchlistMovies.execute(testMovieDetail),
      ).thenAnswer((_) async => Left(DatabaseFailure(failedRemovingWatchlist)));
      return movieWatchlistBloc;
    },
    act: (bloc) => bloc.add(const OnRemovingWatchlist(testMovieDetail)),
    expect: () => [MovieWatchlistHasMessage(false, failedRemovingWatchlist)],
    verify: (bloc) {
      verify(mockRemoveWatchlistMovies.execute(testMovieDetail));
    },
  );
}
