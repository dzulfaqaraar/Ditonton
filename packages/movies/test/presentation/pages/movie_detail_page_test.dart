import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/presentation/bloc/bloc_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movies/movies.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';
import 'movie_detail_page_test.mocks.dart';

@GenerateMocks([MovieDetailBloc, MovieRecommendationBloc, MovieWatchlistBloc])
void main() {
  late MockMovieDetailBloc mockMovieDetailBloc;
  late MockMovieRecommendationBloc mockMovieRecommendationBloc;
  late MockMovieWatchlistBloc mockMovieWatchlistBloc;

  String addedMessage = 'Added to Watchlist';
  String removedMessage = 'Removed from Watchlist';
  String failedAddingWatchlist = 'Failed to add watchlist';
  String failedRemovingWatchlist = 'Failed to remove watchlist';

  final newTestMovieDetail = MovieDetail(
    adult: testMovieDetail.adult,
    backdropPath: testMovieDetail.backdropPath,
    genres: testMovieDetail.genres,
    id: testMovieDetail.id,
    originalTitle: testMovieDetail.originalTitle,
    overview: testMovieDetail.overview,
    posterPath: testMovieDetail.posterPath,
    releaseDate: testMovieDetail.releaseDate,
    runtime: 40,
    title: testMovieDetail.title,
    voteAverage: testMovieDetail.voteAverage,
    voteCount: testMovieDetail.voteCount,
  );

  setUp(() {
    mockMovieDetailBloc = MockMovieDetailBloc();
    mockMovieRecommendationBloc = MockMovieRecommendationBloc();
    mockMovieWatchlistBloc = MockMovieWatchlistBloc();
  });

  void arrangeUsecaseDetailHasData() {
    when(mockMovieDetailBloc.state).thenReturn(BlocHasData(newTestMovieDetail));
    when(
      mockMovieDetailBloc.stream,
    ).thenAnswer((_) => Stream.value(BlocHasData(newTestMovieDetail)));
  }

  void arrangeUsecaseRecommendationEmpty() {
    when(mockMovieRecommendationBloc.state).thenReturn(BlocEmpty());
    when(
      mockMovieRecommendationBloc.stream,
    ).thenAnswer((_) => Stream.value(BlocEmpty()));
  }

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieDetailBloc>(create: (context) => mockMovieDetailBloc),
        BlocProvider<MovieRecommendationBloc>(
          create: (context) => mockMovieRecommendationBloc,
        ),
        BlocProvider<MovieWatchlistBloc>(
          create: (context) => mockMovieWatchlistBloc,
        ),
      ],
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display Movie Detail when data load successfully', (
    WidgetTester tester,
  ) async {
    arrangeUsecaseDetailHasData();
    arrangeUsecaseRecommendationEmpty();

    when(
      mockMovieWatchlistBloc.state,
    ).thenReturn(const MovieWatchlistHasMessage(false, null));
    when(mockMovieWatchlistBloc.stream).thenAnswer(
      (_) => Stream.value(const MovieWatchlistHasMessage(false, null)),
    );

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    final imageFinder = find.byType(CachedNetworkImage);
    expect(imageFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (
    WidgetTester tester,
  ) async {
    when(
      mockMovieDetailBloc.state,
    ).thenReturn(const BlocError('Error message'));
    when(
      mockMovieDetailBloc.stream,
    ).thenAnswer((_) => Stream.value(const BlocError('Error message')));

    arrangeUsecaseRecommendationEmpty();

    when(
      mockMovieWatchlistBloc.state,
    ).thenReturn(const MovieWatchlistHasMessage(false, null));
    when(mockMovieWatchlistBloc.stream).thenAnswer(
      (_) => Stream.value(const MovieWatchlistHasMessage(false, null)),
    );

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    final textFinder = find.byKey(const Key('error_message'));
    expect(textFinder, findsOneWidget);
  });

  testWidgets('Watchlist button should display with disabled when first time', (
    WidgetTester tester,
  ) async {
    arrangeUsecaseDetailHasData();
    arrangeUsecaseRecommendationEmpty();

    when(mockMovieWatchlistBloc.state).thenReturn(BlocEmpty());
    when(
      mockMovieWatchlistBloc.stream,
    ).thenAnswer((_) => Stream.value(BlocEmpty()));

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    final watchlistButtonFinder = find.byType(ElevatedButton);
    expect(watchlistButtonFinder, findsOneWidget);

    ElevatedButton watchlistButton = tester.widget(watchlistButtonFinder);
    expect(watchlistButton.onPressed, null);
  });

  testWidgets(
    'Watchlist button should display add icon when movie not added to watchlist',
    (WidgetTester tester) async {
      arrangeUsecaseDetailHasData();
      arrangeUsecaseRecommendationEmpty();

      when(
        mockMovieWatchlistBloc.state,
      ).thenReturn(const MovieWatchlistHasMessage(false, null));
      when(mockMovieWatchlistBloc.stream).thenAnswer(
        (_) => Stream.value(const MovieWatchlistHasMessage(false, null)),
      );

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

      final watchlistButtonIcon = find.byIcon(Icons.add);
      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should dispay check icon when movie is added to wathclist',
    (WidgetTester tester) async {
      arrangeUsecaseDetailHasData();
      arrangeUsecaseRecommendationEmpty();

      when(
        mockMovieWatchlistBloc.state,
      ).thenReturn(const MovieWatchlistHasMessage(true, null));
      when(mockMovieWatchlistBloc.stream).thenAnswer(
        (_) => Stream.value(const MovieWatchlistHasMessage(true, null)),
      );

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

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
        mockMovieWatchlistBloc.state,
      ).thenReturn(MovieWatchlistHasMessage(false, addedMessage));
      when(mockMovieWatchlistBloc.stream).thenAnswer(
        (_) => Stream.value(MovieWatchlistHasMessage(false, addedMessage)),
      );

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

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
        mockMovieWatchlistBloc.state,
      ).thenReturn(MovieWatchlistHasMessage(true, removedMessage));
      when(mockMovieWatchlistBloc.stream).thenAnswer(
        (_) => Stream.value(MovieWatchlistHasMessage(true, removedMessage)),
      );

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

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
        mockMovieWatchlistBloc.state,
      ).thenReturn(MovieWatchlistHasMessage(false, failedAddingWatchlist));
      when(mockMovieWatchlistBloc.stream).thenAnswer(
        (_) => Stream.value(
          MovieWatchlistHasMessage(false, failedAddingWatchlist),
        ),
      );

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

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
        mockMovieWatchlistBloc.state,
      ).thenReturn(MovieWatchlistHasMessage(false, failedRemovingWatchlist));
      when(mockMovieWatchlistBloc.stream).thenAnswer(
        (_) => Stream.value(
          MovieWatchlistHasMessage(false, failedRemovingWatchlist),
        ),
      );

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

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
      mockMovieRecommendationBloc.state,
    ).thenReturn(const BlocError('Error message'));
    when(
      mockMovieRecommendationBloc.stream,
    ).thenAnswer((_) => Stream.value(const BlocError('Error message')));

    when(
      mockMovieWatchlistBloc.state,
    ).thenReturn(const MovieWatchlistHasMessage(true, null));
    when(mockMovieWatchlistBloc.stream).thenAnswer(
      (_) => Stream.value(const MovieWatchlistHasMessage(true, null)),
    );

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    final textFinder = find.byKey(const Key('error_message'));
    expect(textFinder, findsOneWidget);
  });

  testWidgets('Recommendation should display ListView when data is loaded', (
    WidgetTester tester,
  ) async {
    arrangeUsecaseDetailHasData();

    when(
      mockMovieRecommendationBloc.state,
    ).thenReturn(BlocHasData(testMovieList));
    when(
      mockMovieRecommendationBloc.stream,
    ).thenAnswer((_) => Stream.value(BlocHasData(testMovieList)));

    when(
      mockMovieWatchlistBloc.state,
    ).thenReturn(const MovieWatchlistHasMessage(true, null));
    when(mockMovieWatchlistBloc.stream).thenAnswer(
      (_) => Stream.value(const MovieWatchlistHasMessage(true, null)),
    );

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    final listViewFinder = find.byType(ListView);
    expect(listViewFinder, findsOneWidget);

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
  });

  testWidgets('Should navigate back when back button is tapped', (
    WidgetTester tester,
  ) async {
    arrangeUsecaseDetailHasData();
    arrangeUsecaseRecommendationEmpty();

    when(
      mockMovieWatchlistBloc.state,
    ).thenReturn(const MovieWatchlistHasMessage(false, null));
    when(mockMovieWatchlistBloc.stream).thenAnswer(
      (_) => Stream.value(const MovieWatchlistHasMessage(false, null)),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<MovieDetailBloc>(
              create: (context) => mockMovieDetailBloc,
            ),
            BlocProvider<MovieRecommendationBloc>(
              create: (context) => mockMovieRecommendationBloc,
            ),
            BlocProvider<MovieWatchlistBloc>(
              create: (context) => mockMovieWatchlistBloc,
            ),
          ],
          child: const Scaffold(body: MovieDetailPage(id: 1)),
        ),
      ),
    );

    final backButtonFinder = find.byIcon(Icons.arrow_back);
    expect(backButtonFinder, findsOneWidget);

    await tester.tap(backButtonFinder);
    await tester.pumpAndSettle();

    expect(find.byType(MovieDetailPage), findsNothing);
  });
}
