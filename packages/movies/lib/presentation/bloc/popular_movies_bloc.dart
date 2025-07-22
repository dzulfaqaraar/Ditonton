import 'package:core/domain/usecase/get_movies.dart';
import 'package:core/presentation/bloc/bloc_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'popular_movies_event.dart';

class PopularMoviesBloc extends Bloc<PopularMoviesEvent, BlocState> {
  final GetMovies getMovies;

  PopularMoviesBloc(this.getMovies) : super(BlocEmpty()) {
    on<OnFetchingPopular>((event, emit) async {
      emit(BlocLoading());

      final result = await getMovies.execute('/movie/popular');

      result.fold(
        (failure) {
          emit(BlocError(failure.message));
        },
        (moviesData) {
          emit(BlocHasData(moviesData));
        },
      );
    });
  }
}
