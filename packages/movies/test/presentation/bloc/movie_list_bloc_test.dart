import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/usecase/get_movies.dart';
import 'package:core/presentation/bloc/bloc_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movies/movies.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';
import 'movie_list_bloc_test.mocks.dart';

@GenerateMocks([GetMovies])
void main() {
  late MovieListBloc popularMoviesBloc;
  late MockGetMovies mockGetMovies;

  const url = '/movie/now_playing';

  setUp(() {
    mockGetMovies = MockGetMovies();
    popularMoviesBloc = MovieListBloc(mockGetMovies);
  });

  test('initial state should be empty', () {
    expect(popularMoviesBloc.state, BlocEmpty());
  });

  blocTest<MovieListBloc, BlocState>(
    'Should emit [Loading, HasData] when data Movie List is gotten successfully',
    build: () {
      when(
        mockGetMovies.execute(url),
      ).thenAnswer((_) async => Right(testMovieList));
      return popularMoviesBloc;
    },
    act: (bloc) => bloc.add(const OnFetchingList()),
    expect: () => [BlocLoading(), BlocHasData(testMovieList)],
    verify: (bloc) {
      verify(mockGetMovies.execute(url));
    },
  );

  blocTest<MovieListBloc, BlocState>(
    'Should emit [Loading, Error] when data Movie List is unsuccessful',
    build: () {
      when(
        mockGetMovies.execute(url),
      ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return popularMoviesBloc;
    },
    act: (bloc) => bloc.add(const OnFetchingList()),
    expect: () => [BlocLoading(), const BlocError('Server Failure')],
    verify: (bloc) {
      verify(mockGetMovies.execute(url));
    },
  );
}
