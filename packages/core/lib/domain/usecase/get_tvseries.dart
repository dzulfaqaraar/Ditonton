import 'package:core/core.dart';
import 'package:dartz/dartz.dart';

class GetTvSeries {
  final MovieRepository repository;

  GetTvSeries(this.repository);

  Future<Either<Failure, List<TvSeries>>> execute(String url) {
    return repository.getTvSeries(url);
  }
}
