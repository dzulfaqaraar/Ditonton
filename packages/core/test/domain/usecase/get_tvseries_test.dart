import 'package:core/domain/usecase/get_tvseries.dart';
import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../core/test/helpers/test_helper.mocks.dart';

void main() {
  late GetTvSeries usecase;
  late MockMovieRepository mockMovieRepository;

  const url = 'https://any-url.com';
  final tTvSeries = <TvSeries>[];

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetTvSeries(mockMovieRepository);
  });

  test('should get list of tv series from the repository', () async {
    // arrange
    when(
      mockMovieRepository.getTvSeries(url),
    ).thenAnswer((_) async => Right(tTvSeries));
    // act
    final result = await usecase.execute(url);
    // assert
    expect(result, Right(tTvSeries));
  });
}
