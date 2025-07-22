import 'package:core/core.dart';
import 'package:core/presentation/bloc/bloc_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/tv_series.dart';

part 'tv_series_recommendation_event.dart';

class TvSeriesRecommendationBloc
    extends Bloc<TvSeriesRecommendationEvent, BlocState> {
  final GetTvSeriesRecommendations getTvSeriesRecommendations;

  TvSeriesRecommendationBloc(this.getTvSeriesRecommendations)
    : super(BlocEmpty()) {
    on<OnFetchingRecommendation>((event, emit) async {
      emit(BlocLoading());

      final recommendation = await getTvSeriesRecommendations.execute(event.id);

      recommendation.fold(
        (failure) {
          emit(BlocError(failure.message));
        },
        (data) {
          emit(BlocHasData<List<TvSeries>>(data));
        },
      );
    });
  }
}
