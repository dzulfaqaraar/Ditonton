import 'package:core/core.dart';
import 'package:dartz/dartz.dart';

class GetMovies {
  final MovieRepository repository;

  GetMovies(this.repository);

  Future<Either<Failure, List<Movie>>> execute(String url) {
    return repository.getMovies(url);
  }
}
