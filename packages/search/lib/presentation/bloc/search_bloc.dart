import 'package:core/core.dart';
import 'package:core/presentation/bloc/bloc_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:search/search.dart';

part 'search_event.dart';

class SearchBloc extends Bloc<SearchEvent, BlocState> {
  final SearchMovies _searchMovies;
  final SearchTvSeries _searchTvSeries;

  SearchBloc(this._searchMovies, this._searchTvSeries) : super(BlocEmpty()) {
    on<OnQueryChangedMovie>((event, emit) async {
      final query = event.query;

      emit(BlocLoading());
      final result = await _searchMovies.execute(query);

      result.fold(
        (failure) {
          emit(BlocError(failure.message));
        },
        (data) {
          emit(BlocHasData<List<Movie>>(data));
        },
      );
    }, transformer: debounce(const Duration(milliseconds: 500)));

    on<OnQueryChangedTvSeries>((event, emit) async {
      final query = event.query;

      emit(BlocLoading());
      final result = await _searchTvSeries.execute(query);

      result.fold(
        (failure) {
          emit(BlocError(failure.message));
        },
        (data) {
          emit(BlocHasData<List<TvSeries>>(data));
        },
      );
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }
}
