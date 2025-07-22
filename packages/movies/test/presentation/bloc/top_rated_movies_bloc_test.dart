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
  late TopRatedMoviesBloc popularMoviesBloc;
  late MockGetMovies mockGetMovies;

  const url = '/movie/top_rated';

  setUp(() {
    mockGetMovies = MockGetMovies();
    popularMoviesBloc = TopRatedMoviesBloc(mockGetMovies);
  });

  test('initial state should be empty', () {
    expect(popularMoviesBloc.state, BlocEmpty());
  });

  blocTest<TopRatedMoviesBloc, BlocState>(
    'Should emit [Loading, HasData] when data Top Rated Movie is gotten successfully',
    build: () {
      when(
        mockGetMovies.execute(url),
      ).thenAnswer((_) async => Right(testMovieList));
      return popularMoviesBloc;
    },
    act: (bloc) => bloc.add(const OnFetchingTopRated()),
    expect: () => [BlocLoading(), BlocHasData(testMovieList)],
    verify: (bloc) {
      verify(mockGetMovies.execute(url));
    },
  );

  blocTest<TopRatedMoviesBloc, BlocState>(
    'Should emit [Loading, Error] when data Top Rated Movie is unsuccessful',
    build: () {
      when(
        mockGetMovies.execute(url),
      ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return popularMoviesBloc;
    },
    act: (bloc) => bloc.add(const OnFetchingTopRated()),
    expect: () => [BlocLoading(), const BlocError('Server Failure')],
    verify: (bloc) {
      verify(mockGetMovies.execute(url));
    },
  );
}
