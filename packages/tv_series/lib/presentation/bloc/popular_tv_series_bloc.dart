import 'package:core/domain/usecase/get_tvseries.dart';
import 'package:core/presentation/bloc/bloc_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'popular_tv_series_event.dart';

class PopularTvSeriesBloc extends Bloc<PopularTvSeriesEvent, BlocState> {
  final GetTvSeries getTvSeries;

  PopularTvSeriesBloc(this.getTvSeries) : super(BlocEmpty()) {
    on<OnFetchingPopular>((event, emit) async {
      emit(BlocLoading());

      final result = await getTvSeries.execute('/tv/popular');

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
