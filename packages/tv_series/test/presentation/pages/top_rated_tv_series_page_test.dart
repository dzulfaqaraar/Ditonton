import 'package:core/core.dart';
import 'package:core/presentation/bloc/bloc_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/tv_series.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';
import 'top_rated_tv_series_page_test.mocks.dart';

@GenerateMocks([TopRatedTvSeriesBloc])
void main() {
  late MockTopRatedTvSeriesBloc mockTopRatedTvSeriesBloc;

  setUp(() {
    mockTopRatedTvSeriesBloc = MockTopRatedTvSeriesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TopRatedTvSeriesBloc>(
          create: (context) => mockTopRatedTvSeriesBloc,
        ),
      ],
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading', (
    WidgetTester tester,
  ) async {
    when(mockTopRatedTvSeriesBloc.state).thenReturn(BlocLoading());
    when(
      mockTopRatedTvSeriesBloc.stream,
    ).thenAnswer((_) => Stream.value(BlocLoading()));

    await tester.pumpWidget(makeTestableWidget(const TopRatedTvSeriesPage()));

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (
    WidgetTester tester,
  ) async {
    when(
      mockTopRatedTvSeriesBloc.state,
    ).thenReturn(BlocHasData<List<TvSeries>>(testTvSeriesList));
    when(mockTopRatedTvSeriesBloc.stream).thenAnswer(
      (_) => Stream.value(BlocHasData<List<TvSeries>>(testTvSeriesList)),
    );

    await tester.pumpWidget(makeTestableWidget(const TopRatedTvSeriesPage()));

    final listViewFinder = find.byType(ListView);
    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (
    WidgetTester tester,
  ) async {
    when(
      mockTopRatedTvSeriesBloc.state,
    ).thenReturn(const BlocError('Error message'));
    when(
      mockTopRatedTvSeriesBloc.stream,
    ).thenAnswer((_) => Stream.value(const BlocError('Error message')));

    await tester.pumpWidget(makeTestableWidget(const TopRatedTvSeriesPage()));

    final textFinder = find.byKey(const Key('error_message'));
    expect(textFinder, findsOneWidget);
  });
}
