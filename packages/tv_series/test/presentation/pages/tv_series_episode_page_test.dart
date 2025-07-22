import 'package:core/core.dart';
import 'package:core/presentation/bloc/bloc_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/tv_series.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';
import 'tv_series_episode_page_test.mocks.dart';

@GenerateMocks([TvSeriesEpisodeBloc])
void main() {
  late MockTvSeriesEpisodeBloc mockTvSeriesEpisodeBloc;

  setUp(() {
    mockTvSeriesEpisodeBloc = MockTvSeriesEpisodeBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TvSeriesEpisodeBloc>(
          create: (context) => mockTvSeriesEpisodeBloc,
        ),
      ],
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading', (
    WidgetTester tester,
  ) async {
    when(mockTvSeriesEpisodeBloc.state).thenReturn(BlocLoading());
    when(
      mockTvSeriesEpisodeBloc.stream,
    ).thenAnswer((_) => Stream.value(BlocLoading()));

    await tester.pumpWidget(
      makeTestableWidget(
        TvSeriesEpisodePage(
          request: EpisodeRequest(title: "Title", id: 1, season: 1),
        ),
      ),
    );

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (
    WidgetTester tester,
  ) async {
    when(
      mockTvSeriesEpisodeBloc.state,
    ).thenReturn(const BlocHasData<TvSeriesEpisode>(testTvSeriesEpisode));
    when(mockTvSeriesEpisodeBloc.stream).thenAnswer(
      (_) =>
          Stream.value(const BlocHasData<TvSeriesEpisode>(testTvSeriesEpisode)),
    );

    await tester.pumpWidget(
      makeTestableWidget(
        TvSeriesEpisodePage(
          request: EpisodeRequest(title: "Title", id: 1, season: 1),
        ),
      ),
    );

    final listViewFinder = find.byType(ListView);
    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (
    WidgetTester tester,
  ) async {
    when(
      mockTvSeriesEpisodeBloc.state,
    ).thenReturn(const BlocError('Error message'));
    when(
      mockTvSeriesEpisodeBloc.stream,
    ).thenAnswer((_) => Stream.value(const BlocError('Error message')));

    await tester.pumpWidget(
      makeTestableWidget(
        TvSeriesEpisodePage(
          request: EpisodeRequest(title: "Title", id: 1, season: 1),
        ),
      ),
    );

    final textFinder = find.byKey(const Key('error_message'));
    expect(textFinder, findsOneWidget);
  });
}
