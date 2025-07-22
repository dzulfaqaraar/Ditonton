import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/presentation/bloc/bloc_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movies/movies.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';
import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([GetMovieDetail])
void main() {
  late MovieDetailBloc movieDetailBloc;
  late MockGetMovieDetail mockGetMovieDetail;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    movieDetailBloc = MovieDetailBloc(mockGetMovieDetail);
  });

  test('initial state should be empty', () {
    expect(movieDetailBloc.state, BlocEmpty());
  });

  blocTest<MovieDetailBloc, BlocState>(
    'Should emit [Loading, HasData] when data Movie Detail is gotten successfully',
    build: () {
      when(
        mockGetMovieDetail.execute(1),
      ).thenAnswer((_) async => const Right(testMovieDetail));
      return movieDetailBloc;
    },
    act: (bloc) => bloc.add(const OnFetchingDetail(1)),
    expect: () => [BlocLoading(), const BlocHasData(testMovieDetail)],
    verify: (bloc) {
      verify(mockGetMovieDetail.execute(1));
    },
  );

  blocTest<MovieDetailBloc, BlocState>(
    'Should emit [Loading, Error] when data Movie Detail is unsuccessful',
    build: () {
      when(
        mockGetMovieDetail.execute(1),
      ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return movieDetailBloc;
    },
    act: (bloc) => bloc.add(const OnFetchingDetail(1)),
    expect: () => [BlocLoading(), const BlocError('Server Failure')],
    verify: (bloc) {
      verify(mockGetMovieDetail.execute(1));
    },
  );
}
