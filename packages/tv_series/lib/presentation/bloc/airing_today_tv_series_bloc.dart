import 'package:core/domain/usecase/get_tvseries.dart';
import 'package:core/presentation/bloc/bloc_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'airing_today_tv_series_event.dart';

class AiringTodayTvSeriesBloc
    extends Bloc<AiringTodayTvSeriesEvent, BlocState> {
  final GetTvSeries getTvSeries;

  AiringTodayTvSeriesBloc(this.getTvSeries) : super(BlocEmpty()) {
    on<OnFetchingAiringToday>((event, emit) async {
      emit(BlocLoading());

      final result = await getTvSeries.execute('/tv/airing_today');

      result.fold(
        (failure) {
          emit(BlocError(failure.message));
        },
        (data) {
          emit(BlocHasData(data));
        },
      );
    });
  }
}
