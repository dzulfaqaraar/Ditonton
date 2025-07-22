import 'package:core/presentation/bloc/bloc_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/domain/usecases/get_movie_detail.dart';

part 'movie_detail_event.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, BlocState> {
  final GetMovieDetail getMovieDetail;

  MovieDetailBloc(this.getMovieDetail) : super(BlocEmpty()) {
    on<OnFetchingDetail>((event, emit) async {
      emit(BlocLoading());

      final detail = await getMovieDetail.execute(event.id);

      detail.fold(
        (failure) {
          emit(BlocError(failure.message));
        },
        (movie) {
          emit(BlocHasData(movie));
        },
      );
    });
  }
}
