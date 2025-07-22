import 'package:core/core.dart';
import 'package:core/presentation/bloc/bloc_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/tv_series.dart';

part 'tv_series_detail_event.dart';

class TvSeriesDetailBloc extends Bloc<TvSeriesDetailEvent, BlocState> {
  final GetTvSeriesDetail getTvSeriesDetail;

  TvSeriesDetailBloc(this.getTvSeriesDetail) : super(BlocEmpty()) {
    on<OnFetchingDetail>((event, emit) async {
      emit(BlocLoading());

      final detailResult = await getTvSeriesDetail.execute(event.id);

      detailResult.fold(
        (failure) {
          emit(BlocError(failure.message));
        },
        (data) {
          if (data != null) {
            emit(BlocHasData<TvSeriesDetail>(data));
          } else {
            emit(BlocEmpty());
          }
        },
      );
    });
  }
}
