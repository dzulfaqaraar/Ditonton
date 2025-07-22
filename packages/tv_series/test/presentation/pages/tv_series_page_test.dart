import 'package:core/core.dart';
import 'package:core/presentation/bloc/bloc_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/tv_series.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';
import 'tv_series_detail_page_test.mocks.dart';
import 'tv_series_page_test.mocks.dart';

@GenerateMocks([
  AiringTodayTvSeriesBloc,
  PopularTvSeriesBloc,
  TopRatedTvSeriesBloc,
])
void main() {
  late MockAiringTodayTvSeriesBloc mockAiringTodayTvSeriesBloc;
  late MockPopularTvSeriesBloc mockPopularTvSeriesBloc;
  late MockTopRatedTvSeriesBloc mockTopRatedTvSeriesBloc;

  late MockTvSeriesDetailBloc mockTvSeriesDetailBloc;
  late MockTvSeriesRecommendationBloc mockTvSeriesRecommendationBloc;
  late MockTvSeriesWatchlistBloc mockTvSeriesWatchlistBloc;

  setUp(() {
    mockAiringTodayTvSeriesBloc = MockAiringTodayTvSeriesBloc();
    mockPopularTvSeriesBloc = MockPopularTvSeriesBloc();
    mockTopRatedTvSeriesBloc = MockTopRatedTvSeriesBloc();

    mockTvSeriesDetailBloc = MockTvSeriesDetailBloc();
    mockTvSeriesRecommendationBloc = MockTvSeriesRecommendationBloc();
    mockTvSeriesWatchlistBloc = MockTvSeriesWatchlistBloc();
  });

  void arrangeUsecaseAiringTodayLoading() {
    when(mockAiringTodayTvSeriesBloc.state).thenReturn(BlocLoading());
    when(
      mockAiringTodayTvSeriesBloc.stream,
    ).thenAnswer((_) => Stream.value(BlocLoading()));
  }

  void arrangeUsecasePopularLoading() {
    when(mockPopularTvSeriesBloc.state).thenReturn(BlocLoading());
    when(
      mockPopularTvSeriesBloc.stream,
    ).thenAnswer((_) => Stream.value(BlocLoading()));
  }

  void arrangeUsecaseTopRatedLoading() {
    when(mockTopRatedTvSeriesBloc.state).thenReturn(BlocLoading());
    when(
      mockTopRatedTvSeriesBloc.stream,
    ).thenAnswer((_) => Stream.value(BlocLoading()));
  }

  void arrangeUsecaseDetail() {
    when(
      mockTvSeriesWatchlistBloc.state,
    ).thenReturn(const TvSeriesWatchlistHasMessage(false, null));
    when(mockTvSeriesWatchlistBloc.stream).thenAnswer(
      (_) => Stream.value(const TvSeriesWatchlistHasMessage(false, null)),
    );

    when(
      mockTvSeriesDetailBloc.state,
    ).thenReturn(const BlocHasData<TvSeriesDetail>(testTvSeriesDetail));
    when(mockTvSeriesDetailBloc.stream).thenAnswer(
      (_) =>
          Stream.value(const BlocHasData<TvSeriesDetail>(testTvSeriesDetail)),
    );

    when(mockTvSeriesRecommendationBloc.state).thenReturn(BlocEmpty());
    when(
      mockTvSeriesRecommendationBloc.stream,
    ).thenAnswer((_) => Stream.value(BlocEmpty()));
  }

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PopularTvSeriesBloc>(
          create: (context) => mockPopularTvSeriesBloc,
        ),
        BlocProvider<TopRatedTvSeriesBloc>(
          create: (context) => mockTopRatedTvSeriesBloc,
        ),
        BlocProvider<AiringTodayTvSeriesBloc>(
          create: (context) => mockAiringTodayTvSeriesBloc,
        ),
        BlocProvider<TvSeriesDetailBloc>(
          create: (context) => mockTvSeriesDetailBloc,
        ),
        BlocProvider<TvSeriesRecommendationBloc>(
          create: (context) => mockTvSeriesRecommendationBloc,
        ),
        BlocProvider<TvSeriesWatchlistBloc>(
          create: (context) => mockTvSeriesWatchlistBloc,
        ),
      ],
      child: MaterialApp(
        home: Scaffold(body: body),
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case airingTodayTvSeriesRoute:
              return MaterialPageRoute(
                builder: (_) => const AiringTodayTvSeriesPage(),
              );
            case popularTvSeriesRoute:
              return MaterialPageRoute(
                builder: (_) => const PopularTvSeriesPage(),
              );
            case topRatedTvSeriesRoute:
              return MaterialPageRoute(
                builder: (_) => const TopRatedTvSeriesPage(),
              );
            case detailTvSeriesRoute:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvSeriesDetailPage(id: id),
                settings: settings,
              );
          }
          return null;
        },
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading', (
    WidgetTester tester,
  ) async {
    arrangeUsecaseAiringTodayLoading();
    arrangeUsecasePopularLoading();
    arrangeUsecaseTopRatedLoading();

    await tester.pumpWidget(makeTestableWidget(const TvSeriesPage()));

    final nowPlayingTitleFinder = find.text('Airing Today');
    expect(nowPlayingTitleFinder, findsOneWidget);

    final popularTitleFinder = find.text('Popular');
    expect(popularTitleFinder, findsOneWidget);

    final topRatedTitleFinder = find.text('Top Rated');
    expect(topRatedTitleFinder, findsOneWidget);

    final progressFinder = find.byType(CircularProgressIndicator);
    expect(progressFinder, findsNWidgets(3));
  });

  testWidgets(
    'Airing Today section should display ListView when data is loaded',
    (WidgetTester tester) async {
      when(
        mockAiringTodayTvSeriesBloc.state,
      ).thenReturn(BlocHasData(testTvSeriesList));
      when(
        mockAiringTodayTvSeriesBloc.stream,
      ).thenAnswer((_) => Stream.value(BlocHasData(testTvSeriesList)));

      arrangeUsecasePopularLoading();
      arrangeUsecaseTopRatedLoading();

      await tester.pumpWidget(makeTestableWidget(const TvSeriesPage()));

      final subheadingFinder = find.byType(SubHeadingView);

      final subheadingTitleFinder = find.descendant(
        of: subheadingFinder,
        matching: find.text('Airing Today'),
      );
      expect(subheadingTitleFinder, findsOneWidget);

      final subheadingButtonFinder = find.descendant(
        of: subheadingFinder,
        matching: find.byType(InkWell),
      );
      expect(subheadingButtonFinder, findsWidgets);

      final listFinder = find.byType(ListView);
      expect(listFinder, findsOneWidget);

      await tester.tap(subheadingButtonFinder.at(0));
      await tester.pump();
    },
  );

  testWidgets('Popular section should display ListView when data is loaded', (
    WidgetTester tester,
  ) async {
    arrangeUsecaseAiringTodayLoading();

    when(
      mockPopularTvSeriesBloc.state,
    ).thenReturn(BlocHasData(testTvSeriesList));
    when(
      mockPopularTvSeriesBloc.stream,
    ).thenAnswer((_) => Stream.value(BlocHasData(testTvSeriesList)));

    arrangeUsecaseTopRatedLoading();

    await tester.pumpWidget(makeTestableWidget(const TvSeriesPage()));

    final subheadingFinder = find.byType(SubHeadingView);

    final subheadingTitleFinder = find.descendant(
      of: subheadingFinder,
      matching: find.text('Popular'),
    );
    expect(subheadingTitleFinder, findsOneWidget);

    final subheadingButtonFinder = find.descendant(
      of: subheadingFinder,
      matching: find.byType(InkWell),
    );
    expect(subheadingButtonFinder, findsWidgets);

    final listFinder = find.byType(ListView);
    expect(listFinder, findsOneWidget);

    await tester.tap(subheadingButtonFinder.at(1));
    await tester.pump();
  });

  testWidgets('Top Rated section should display ListView when data is loaded', (
    WidgetTester tester,
  ) async {
    arrangeUsecaseAiringTodayLoading();
    arrangeUsecasePopularLoading();

    when(
      mockTopRatedTvSeriesBloc.state,
    ).thenReturn(BlocHasData<List<TvSeries>>(testTvSeriesList));
    when(mockTopRatedTvSeriesBloc.stream).thenAnswer(
      (_) => Stream.value(BlocHasData<List<TvSeries>>(testTvSeriesList)),
    );

    await tester.pumpWidget(makeTestableWidget(const TvSeriesPage()));

    final subheadingFinder = find.byType(SubHeadingView);

    final subheadingTitleFinder = find.descendant(
      of: subheadingFinder,
      matching: find.text('Top Rated'),
    );
    expect(subheadingTitleFinder, findsOneWidget);

    final subheadingButtonFinder = find.descendant(
      of: subheadingFinder,
      matching: find.byType(InkWell),
    );
    expect(subheadingButtonFinder, findsWidgets);

    final listFinder = find.byType(ListView);
    expect(listFinder, findsOneWidget);

    await tester.tap(subheadingButtonFinder.at(2));
    await tester.pump();
  });

  testWidgets(
    'Airing Today should open TvSeries Detail Page when item clicked',
    (WidgetTester tester) async {
      when(
        mockAiringTodayTvSeriesBloc.state,
      ).thenReturn(BlocHasData(testTvSeriesList));
      when(
        mockAiringTodayTvSeriesBloc.stream,
      ).thenAnswer((_) => Stream.value(BlocHasData(testTvSeriesList)));

      arrangeUsecasePopularLoading();
      arrangeUsecaseTopRatedLoading();

      arrangeUsecaseDetail();

      await tester.pumpWidget(makeTestableWidget(const TvSeriesPage()));

      final listFinder = find.byType(ListView);
      expect(listFinder, findsOneWidget);

      final buttonFinder = find.descendant(
        of: listFinder,
        matching: find.byKey(const Key('card_item_key')),
      );
      expect(buttonFinder, findsOneWidget);

      await tester.tap(buttonFinder);
      await tester.pump();
    },
  );

  testWidgets('Popular should open TvSeries Detail Page when item clicked', (
    WidgetTester tester,
  ) async {
    arrangeUsecaseAiringTodayLoading();

    when(
      mockPopularTvSeriesBloc.state,
    ).thenReturn(BlocHasData(testTvSeriesList));
    when(
      mockPopularTvSeriesBloc.stream,
    ).thenAnswer((_) => Stream.value(BlocHasData(testTvSeriesList)));

    arrangeUsecaseTopRatedLoading();

    arrangeUsecaseDetail();

    await tester.pumpWidget(makeTestableWidget(const TvSeriesPage()));

    final listFinder = find.byType(ListView);
    expect(listFinder, findsOneWidget);

    final buttonFinder = find.descendant(
      of: listFinder,
      matching: find.byKey(const Key('card_item_key')),
    );
    expect(buttonFinder, findsOneWidget);

    await tester.tap(buttonFinder);
    await tester.pump();
  });

  testWidgets('Top Rated should open TvSeries Detail Page when item clicked', (
    WidgetTester tester,
  ) async {
    arrangeUsecaseAiringTodayLoading();
    arrangeUsecasePopularLoading();

    when(
      mockTopRatedTvSeriesBloc.state,
    ).thenReturn(BlocHasData<List<TvSeries>>(testTvSeriesList));
    when(mockTopRatedTvSeriesBloc.stream).thenAnswer(
      (_) => Stream.value(BlocHasData<List<TvSeries>>(testTvSeriesList)),
    );

    arrangeUsecaseDetail();

    await tester.pumpWidget(makeTestableWidget(const TvSeriesPage()));

    final listFinder = find.byType(ListView);
    expect(listFinder, findsOneWidget);

    final buttonFinder = find.descendant(
      of: listFinder,
      matching: find.byKey(const Key('card_item_key')),
    );
    expect(buttonFinder, findsOneWidget);

    await tester.tap(buttonFinder);
    await tester.pump();
  });
}
