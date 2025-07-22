import 'package:core/domain/usecase/get_movies.dart';
import 'package:core/presentation/bloc/bloc_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'top_rated_movies_event.dart';

class TopRatedMoviesBloc extends Bloc<TopRatedMoviesEvent, BlocState> {
  final GetMovies getMovies;

  TopRatedMoviesBloc(this.getMovies) : super(BlocEmpty()) {
    on<OnFetchingTopRated>((event, emit) async {
      emit(BlocLoading());

      final result = await getMovies.execute('/movie/top_rated');

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
