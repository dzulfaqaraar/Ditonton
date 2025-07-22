import 'package:core/core.dart';
import 'package:core/domain/usecase/get_tvseries.dart';
import 'package:core/presentation/bloc/bloc_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'top_rated_tv_series_event.dart';

class TopRatedTvSeriesBloc extends Bloc<TopRatedTvSeriesEvent, BlocState> {
  final GetTvSeries getTvSeries;

  TopRatedTvSeriesBloc(this.getTvSeries) : super(BlocEmpty()) {
    on<OnFetchingTopRated>((event, emit) async {
      emit(BlocLoading());

      final result = await getTvSeries.execute('/tv/top_rated');

      result.fold(
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
