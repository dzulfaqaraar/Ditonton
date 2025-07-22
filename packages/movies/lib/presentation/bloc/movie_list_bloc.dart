import 'package:core/domain/usecase/get_movies.dart';
import 'package:core/presentation/bloc/bloc_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'movie_list_event.dart';

class MovieListBloc extends Bloc<MovieListEvent, BlocState> {
  final GetMovies getMovies;

  MovieListBloc(this.getMovies) : super(BlocEmpty()) {
    on<OnFetchingList>((event, emit) async {
      emit(BlocLoading());

      final result = await getMovies.execute('/movie/now_playing');
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
