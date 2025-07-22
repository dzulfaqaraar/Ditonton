import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/presentation/bloc/bloc_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movies/movies.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';
import 'movie_recommendation_bloc_test.mocks.dart';

@GenerateMocks([GetMovieRecommendations])
void main() {
  late MovieRecommendationBloc movieRecommendationBloc;
  late MockGetMovieRecommendations mockGetMovieRecommendations;

  setUp(() {
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    movieRecommendationBloc = MovieRecommendationBloc(
      mockGetMovieRecommendations,
    );
  });

  test('initial state should be empty', () {
    expect(movieRecommendationBloc.state, BlocEmpty());
  });

  blocTest<MovieRecommendationBloc, BlocState>(
    'Should emit [Loading, HasData] when data Movie Recommendation is gotten successfully',
    build: () {
      when(
        mockGetMovieRecommendations.execute(1),
      ).thenAnswer((_) async => Right(testMovieList));
      return movieRecommendationBloc;
    },
    act: (bloc) => bloc.add(const OnFetchingRecommendation(1)),
    expect: () => [BlocLoading(), BlocHasData(testMovieList)],
    verify: (bloc) {
      verify(mockGetMovieRecommendations.execute(1));
    },
  );

  blocTest<MovieRecommendationBloc, BlocState>(
    'Should emit [Loading, Error] when data Movie Recommendation is unsuccessful',
    build: () {
      when(
        mockGetMovieRecommendations.execute(1),
      ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return movieRecommendationBloc;
    },
    act: (bloc) => bloc.add(const OnFetchingRecommendation(1)),
    expect: () => [BlocLoading(), const BlocError('Server Failure')],
    verify: (bloc) {
      verify(mockGetMovieRecommendations.execute(1));
    },
  );
}
