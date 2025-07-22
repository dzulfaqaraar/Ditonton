import 'package:core/core.dart';
import 'package:core/presentation/bloc/bloc_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/domain/usecases/get_tv_series_episode.dart';

part 'tv_series_episode_event.dart';

class TvSeriesEpisodeBloc extends Bloc<TvSeriesEpisodeEvent, BlocState> {
  final GetTvSeriesEpisode getTvSeriesEpisode;

  TvSeriesEpisodeBloc(this.getTvSeriesEpisode) : super(BlocEmpty()) {
    on<OnFetchingEpisode>((event, emit) async {
      emit(BlocLoading());

      final result = await getTvSeriesEpisode.execute(event.id, event.season);

      result.fold(
        (failure) {
          emit(BlocError(failure.message));
        },
        (data) {
          emit(BlocHasData<TvSeriesEpisode?>(data));
        },
      );
    });
  }
}
