import 'package:core/domain/usecase/get_movies.dart';
import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../core/test/helpers/test_helper.mocks.dart';

void main() {
  late GetMovies usecase;
  late MockMovieRepository mockMovieRepository;

  const url = 'https://any-url.com';
  final tMovies = <Movie>[];

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetMovies(mockMovieRepository);
  });

  test('should get list of movies from the repository', () async {
    // arrange
    when(
      mockMovieRepository.getMovies(url),
    ).thenAnswer((_) async => Right(tMovies));
    // act
    final result = await usecase.execute(url);
    // assert
    expect(result, Right(tMovies));
  });
}
