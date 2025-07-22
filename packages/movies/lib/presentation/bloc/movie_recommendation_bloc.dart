import 'package:core/presentation/bloc/bloc_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/domain/usecases/get_movie_recommendations.dart';

part 'movie_recommendation_event.dart';

class MovieRecommendationBloc
    extends Bloc<MovieRecommendationEvent, BlocState> {
  final GetMovieRecommendations getMovieRecommendations;

  MovieRecommendationBloc(this.getMovieRecommendations) : super(BlocEmpty()) {
    on<OnFetchingRecommendation>((event, emit) async {
      emit(BlocLoading());

      final recommendation = await getMovieRecommendations.execute(event.id);

      recommendation.fold(
        (failure) {
          emit(BlocError(failure.message));
        },
        (movies) {
          emit(BlocHasData(movies));
        },
      );
    });
  }
}
