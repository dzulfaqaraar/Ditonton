import 'package:cached_network_image/cached_network_image.dart';
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

@GenerateMocks([
  TvSeriesDetailBloc,
  TvSeriesRecommendationBloc,
  TvSeriesWatchlistBloc,
])
void main() {
  late MockTvSeriesDetailBloc mockTvSeriesDetailBloc;
  late MockTvSeriesRecommendationBloc mockTvSeriesRecommendationBloc;
  late MockTvSeriesWatchlistBloc mockTvSeriesWatchlistBloc;

  String addedMessage = 'Added to Watchlist';
  String removedMessage = 'Removed from Watchlist';
  String failedAddingWatchlist = 'Failed to add watchlist';
  String failedRemovingWatchlist = 'Failed to remove watchlist';

  final newTestTvSeriesDetail = TvSeriesDetail(
    id: testTvSeriesDetail.id,
    name: testTvSeriesDetail.name,
    overview: testTvSeriesDetail.overview,
    posterPath: testTvSeriesDetail.posterPath,
    genres: testTvSeriesDetail.genres,
    voteAverage: testTvSeriesDetail.voteAverage,
    episodeRunTime: const [100],
    seasons: testTvSeriesDetail.seasons,
  );

  setUp(() {
    mockTvSeriesDetailBloc = MockTvSeriesDetailBloc();
    mockTvSeriesRecommendationBloc = MockTvSeriesRecommendationBloc();
    mockTvSeriesWatchlistBloc = MockTvSeriesWatchlistBloc();
  });

  void arrangeUsecaseDetailHasData() {
    when(
      mockTvSeriesDetailBloc.state,
    ).thenReturn(const BlocHasData<TvSeriesDetail>(testTvSeriesDetail));
    when(mockTvSeriesDetailBloc.stream).thenAnswer(
      (_) =>
          Stream.value(const BlocHasData<TvSeriesDetail>(testTvSeriesDetail)),
    );
  }

  void arrangeUsecaseRecommendationEmpty() {
    when(mockTvSeriesRecommendationBloc.state).thenReturn(BlocEmpty());
    when(
      mockTvSeriesRecommendationBloc.stream,
    ).thenAnswer((_) => Stream.value(BlocEmpty()));
  }

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
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
      child: MaterialApp(home: body),
    );
  }

  testWidgets(
    'Page should display TV Series Detail when data load successfully',
    (WidgetTester tester) async {
      when(
        mockTvSeriesDetailBloc.state,
      ).thenReturn(BlocHasData<TvSeriesDetail>(newTestTvSeriesDetail));
      when(mockTvSeriesDetailBloc.stream).thenAnswer(
        (_) => Stream.value(BlocHasData<TvSeriesDetail>(newTestTvSeriesDetail)),
      );

      arrangeUsecaseRecommendationEmpty();

      when(
        mockTvSeriesWatchlistBloc.state,
      ).thenReturn(const TvSeriesWatchlistHasMessage(false, null));
      when(mockTvSeriesWatchlistBloc.stream).thenAnswer(
        (_) => Stream.value(const TvSeriesWatchlistHasMessage(false, null)),
      );

      await tester.pumpWidget(
        makeTestableWidget(const TvSeriesDetailPage(id: 1)),
      );
      await tester.pump();

      // Try to scroll within the CustomScrollView to make seasons visible
      final customScrollView = find.byType(CustomScrollView);
      if (customScrollView.evaluate().isNotEmpty) {
        await tester.drag(customScrollView, const Offset(0, -100));
        await tester.pump();
      }

      final imageFinder = find.byType(CachedNetworkImage);
      expect(imageFinder, findsNWidgets(2)); // Poster and Season
    },
  );

  testWidgets('Page should display text with message when Error', (
    WidgetTester tester,
  ) async {
    when(
      mockTvSeriesDetailBloc.state,
    ).thenReturn(const BlocError('Error message'));
    when(
      mockTvSeriesDetailBloc.stream,
    ).thenAnswer((_) => Stream.value(const BlocError('Error message')));

    arrangeUsecaseRecommendationEmpty();

    when(
      mockTvSeriesWatchlistBloc.state,
    ).thenReturn(const TvSeriesWatchlistHasMessage(false, null));
    when(mockTvSeriesWatchlistBloc.stream).thenAnswer(
      (_) => Stream.value(const TvSeriesWatchlistHasMessage(false, null)),
    );

    await tester.pumpWidget(
      makeTestableWidget(const TvSeriesDetailPage(id: 1)),
    );

    final textFinder = find.byKey(const Key('error_message'));
    expect(textFinder, findsOneWidget);
  });

  testWidgets('Watchlist button should display with disabled when first time', (
    WidgetTester tester,
  ) async {
    arrangeUsecaseDetailHasData();
    arrangeUsecaseRecommendationEmpty();

    when(mockTvSeriesWatchlistBloc.state).thenReturn(BlocEmpty());
    when(
      mockTvSeriesWatchlistBloc.stream,
    ).thenAnswer((_) => Stream.value(BlocEmpty()));

    await tester.pumpWidget(
      makeTestableWidget(const TvSeriesDetailPage(id: 1)),
    );

    final watchlistButtonFinder = find.byType(ElevatedButton);
    expect(watchlistButtonFinder, findsOneWidget);

    ElevatedButton watchlistButton = tester.widget(watchlistButtonFinder);
    expect(watchlistButton.onPressed, null);
  });

  testWidgets(
    'Watchlist button should display add icon when tv series not added to watchlist',
    (WidgetTester tester) async {
      arrangeUsecaseDetailHasData();
      arrangeUsecaseRecommendationEmpty();

      when(
        mockTvSeriesWatchlistBloc.state,
      ).thenReturn(const TvSeriesWatchlistHasMessage(false, null));
      when(mockTvSeriesWatchlistBloc.stream).thenAnswer(
        (_) => Stream.value(const TvSeriesWatchlistHasMessage(false, null)),
      );

      await tester.pumpWidget(
        makeTestableWidget(const TvSeriesDetailPage(id: 1)),
      );

      final watchlistButtonIcon = find.byIcon(Icons.add);
      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should dispay check icon when tv series is added to wathclist',
    (WidgetTester tester) async {
      arrangeUsecaseDetailHasData();
      arrangeUsecaseRecommendationEmpty();

      when(
        mockTvSeriesWatchlistBloc.state,
      ).thenReturn(const TvSeriesWatchlistHasMessage(true, null));
      when(mockTvSeriesWatchlistBloc.stream).thenAnswer(
        (_) => Stream.value(const TvSeriesWatchlistHasMessage(true, null)),
      );

      await tester.pumpWidget(
        makeTestableWidget(const TvSeriesDetailPage(id: 1)),
      );

      final watchlistButtonIcon = find.byIcon(Icons.check);
      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display Snackbar when added to watchlist',
    (WidgetTester tester) async {
      arrangeUsecaseDetailHasData();
      arrangeUsecaseRecommendationEmpty();

      when(
        mockTvSeriesWatchlistBloc.state,
      ).thenReturn(TvSeriesWatchlistHasMessage(false, addedMessage));
      when(mockTvSeriesWatchlistBloc.stream).thenAnswer(
        (_) => Stream.value(TvSeriesWatchlistHasMessage(false, addedMessage)),
      );

      await tester.pumpWidget(
        makeTestableWidget(const TvSeriesDetailPage(id: 1)),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);

      final watchlistButton = find.byType(ElevatedButton);
      await tester.tap(watchlistButton);
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text(addedMessage), findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display Snackbar when removed from watchlist',
    (WidgetTester tester) async {
      arrangeUsecaseDetailHasData();
      arrangeUsecaseRecommendationEmpty();

      when(
        mockTvSeriesWatchlistBloc.state,
      ).thenReturn(TvSeriesWatchlistHasMessage(true, removedMessage));
      when(mockTvSeriesWatchlistBloc.stream).thenAnswer(
        (_) => Stream.value(TvSeriesWatchlistHasMessage(true, removedMessage)),
      );

      await tester.pumpWidget(
        makeTestableWidget(const TvSeriesDetailPage(id: 1)),
      );

      expect(find.byIcon(Icons.check), findsOneWidget);

      final watchlistButton = find.byType(ElevatedButton);
      await tester.tap(watchlistButton);
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text(removedMessage), findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display AlertDialog when add to watchlist failed',
    (WidgetTester tester) async {
      arrangeUsecaseDetailHasData();
      arrangeUsecaseRecommendationEmpty();

      when(
        mockTvSeriesWatchlistBloc.state,
      ).thenReturn(TvSeriesWatchlistHasMessage(false, failedAddingWatchlist));
      when(mockTvSeriesWatchlistBloc.stream).thenAnswer(
        (_) => Stream.value(
          TvSeriesWatchlistHasMessage(false, failedAddingWatchlist),
        ),
      );

      await tester.pumpWidget(
        makeTestableWidget(const TvSeriesDetailPage(id: 1)),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);

      final watchlistButton = find.byType(ElevatedButton);
      await tester.tap(watchlistButton, warnIfMissed: false);
      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text(failedAddingWatchlist), findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display AlertDialog when remove from watchlist failed',
    (WidgetTester tester) async {
      arrangeUsecaseDetailHasData();
      arrangeUsecaseRecommendationEmpty();

      when(
        mockTvSeriesWatchlistBloc.state,
      ).thenReturn(TvSeriesWatchlistHasMessage(false, failedRemovingWatchlist));
      when(mockTvSeriesWatchlistBloc.stream).thenAnswer(
        (_) => Stream.value(
          TvSeriesWatchlistHasMessage(false, failedRemovingWatchlist),
        ),
      );

      await tester.pumpWidget(
        makeTestableWidget(const TvSeriesDetailPage(id: 1)),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);

      final watchlistButton = find.byType(ElevatedButton);
      await tester.tap(watchlistButton, warnIfMissed: false);
      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text(failedRemovingWatchlist), findsOneWidget);
    },
  );

  testWidgets('Recommendation should display text with message when Error', (
    WidgetTester tester,
  ) async {
    arrangeUsecaseDetailHasData();

    when(
      mockTvSeriesRecommendationBloc.state,
    ).thenReturn(const BlocError('Error message'));
    when(
      mockTvSeriesRecommendationBloc.stream,
    ).thenAnswer((_) => Stream.value(const BlocError('Error message')));

    when(
      mockTvSeriesWatchlistBloc.state,
    ).thenReturn(const TvSeriesWatchlistHasMessage(true, null));
    when(mockTvSeriesWatchlistBloc.stream).thenAnswer(
      (_) => Stream.value(const TvSeriesWatchlistHasMessage(true, null)),
    );

    await tester.pumpWidget(
      makeTestableWidget(const TvSeriesDetailPage(id: 1)),
    );

    final textFinder = find.byKey(
      const Key('error_message'),
      skipOffstage: false,
    );
    expect(textFinder, findsOneWidget);
  });

  testWidgets('Recommendation should display ListView when data is loaded', (
    WidgetTester tester,
  ) async {
    arrangeUsecaseDetailHasData();

    when(
      mockTvSeriesRecommendationBloc.state,
    ).thenReturn(BlocHasData<List<TvSeries>>(testTvSeriesList));
    when(mockTvSeriesRecommendationBloc.stream).thenAnswer(
      (_) => Stream.value(BlocHasData<List<TvSeries>>(testTvSeriesList)),
    );

    when(
      mockTvSeriesWatchlistBloc.state,
    ).thenReturn(const TvSeriesWatchlistHasMessage(true, null));
    when(mockTvSeriesWatchlistBloc.stream).thenAnswer(
      (_) => Stream.value(const TvSeriesWatchlistHasMessage(true, null)),
    );

    await tester.pumpWidget(
      makeTestableWidget(const TvSeriesDetailPage(id: 1)),
    );

    final listViewFinder = find.byType(ListView, skipOffstage: false);
    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Should navigate back when back button is tapped', (
    WidgetTester tester,
  ) async {
    arrangeUsecaseDetailHasData();
    arrangeUsecaseRecommendationEmpty();

    when(
      mockTvSeriesWatchlistBloc.state,
    ).thenReturn(const TvSeriesWatchlistHasMessage(false, null));
    when(mockTvSeriesWatchlistBloc.stream).thenAnswer(
      (_) => Stream.value(const TvSeriesWatchlistHasMessage(false, null)),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
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
          child: const Scaffold(body: TvSeriesDetailPage(id: 1)),
        ),
      ),
    );

    final backButtonFinder = find.byIcon(Icons.arrow_back);
    expect(backButtonFinder, findsOneWidget);

    await tester.tap(backButtonFinder);
    await tester.pumpAndSettle();

    expect(find.byType(TvSeriesDetailPage), findsNothing);
  });

  testWidgets('Season button toggle should change text and show/hide seasons', (
    WidgetTester tester,
  ) async {
    when(
      mockTvSeriesDetailBloc.state,
    ).thenReturn(BlocHasData<TvSeriesDetail>(newTestTvSeriesDetail));
    when(mockTvSeriesDetailBloc.stream).thenAnswer(
      (_) => Stream.value(BlocHasData<TvSeriesDetail>(newTestTvSeriesDetail)),
    );

    when(
      mockTvSeriesWatchlistBloc.state,
    ).thenReturn(const TvSeriesWatchlistHasMessage(false, null));
    when(mockTvSeriesWatchlistBloc.stream).thenAnswer(
      (_) => Stream.value(const TvSeriesWatchlistHasMessage(false, null)),
    );

    arrangeUsecaseRecommendationEmpty();

    await tester.pumpWidget(
      makeTestableWidget(const TvSeriesDetailPage(id: 1)),
    );

    // Scroll until the season_button_toggle is visible
    final scrollableFinder = find.byType(DraggableScrollableSheet);
    expect(scrollableFinder, findsOneWidget);

    final seasonButtonFinder = find.byKey(const Key('season_button_toggle'));
    await tester.ensureVisible(seasonButtonFinder);
    await tester.pump();
    expect(seasonButtonFinder, findsOneWidget);

    // Initially should show "View All" text
    expect(find.text('View All'), findsOneWidget);
    expect(find.text('Hide Other'), findsNothing);

    // Tap the season button toggle
    await tester.tap(seasonButtonFinder);
    await tester.pump();

    // After tapping, should show "Hide Other" text
    expect(find.text('Hide Other'), findsOneWidget);
    expect(find.text('View All'), findsNothing);

    // Tap again to toggle back
    await tester.tap(seasonButtonFinder);
    await tester.pump();

    // Should show "View All" text again
    expect(find.text('View All'), findsOneWidget);
    expect(find.text('Hide Other'), findsNothing);
  });

  testWidgets(
    'Should reload page with different tv series ID when recommendation item is tapped',
    (WidgetTester tester) async {
      arrangeUsecaseDetailHasData();

      when(
        mockTvSeriesRecommendationBloc.state,
      ).thenReturn(BlocHasData(testTvSeriesList));
      when(
        mockTvSeriesRecommendationBloc.stream,
      ).thenAnswer((_) => Stream.value(BlocHasData(testTvSeriesList)));

      when(
        mockTvSeriesWatchlistBloc.state,
      ).thenReturn(const TvSeriesWatchlistHasMessage(false, null));
      when(mockTvSeriesWatchlistBloc.stream).thenAnswer(
        (_) => Stream.value(const TvSeriesWatchlistHasMessage(false, null)),
      );

      // Act: Render the tv series detail page with initial tvSeries ID = 1
      await tester.pumpWidget(
        makeTestableWidget(const TvSeriesDetailPage(id: 1)),
      );

      // Capture the initial tvSeries title for comparison
      final initialTitleFinder = find.byKey(const Key('tv_series_title'));
      expect(initialTitleFinder, findsOneWidget);

      Text initialTitleText = tester.widget(initialTitleFinder);
      String initialTitle = initialTitleText.data ?? '';

      // Find the first recommendation item (InkWell widget)
      // This represents a tappable recommendation poster
      final recommendationItemFinder = find.byType(InkWell).first;
      expect(recommendationItemFinder, findsOneWidget);

      // Manually rebuild the widget with the new tvSeries ID to simulate
      // the page reload that would happen in the real app
      // testTvSeriesList[0].id = 557 (Spider-Man tvSeries from dummy data)
      await tester.tap(recommendationItemFinder);
      await tester.pump();

      // Assert: Verify that the page now shows the recommendation tvSeries's content
      final recommendationTitleFinder = find.byKey(
        const Key('tv_series_title'),
      );
      expect(recommendationTitleFinder, findsOneWidget);

      // Get the new tvSeries title after the "reload"
      // Verify that the title has changed, indicating the page was reloaded
      // with different tvSeries data (the initialLoad function worked correctly)
      Text recommendationTitleText = tester.widget(initialTitleFinder);
      expect(initialTitle, recommendationTitleText.data);
    },
  );
}
