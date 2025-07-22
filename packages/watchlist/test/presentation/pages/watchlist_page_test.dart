import 'package:core/core.dart';
import 'package:core/presentation/bloc/bloc_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:watchlist/watchlist.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';
import 'watchlist_page_test.mocks.dart';

@GenerateMocks([WatchlistBloc])
void main() {
  late MockWatchlistBloc mockWatchlistBloc;

  setUp(() {
    mockWatchlistBloc = MockWatchlistBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WatchlistBloc>(create: (context) => mockWatchlistBloc),
      ],
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading', (
    WidgetTester tester,
  ) async {
    when(mockWatchlistBloc.state).thenReturn(BlocLoading());
    when(
      mockWatchlistBloc.stream,
    ).thenAnswer((_) => Stream.value(BlocLoading()));

    await tester.pumpWidget(makeTestableWidget(const WatchlistPage()));

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (
    WidgetTester tester,
  ) async {
    when(mockWatchlistBloc.state).thenReturn(BlocHasData(testListOfWatchlist));
    when(
      mockWatchlistBloc.stream,
    ).thenAnswer((_) => Stream.value(BlocHasData(testListOfWatchlist)));

    await tester.pumpWidget(makeTestableWidget(const WatchlistPage()));

    final listViewFinder = find.byType(ListView);
    expect(listViewFinder, findsOneWidget);

    final movieCardViewFinder = find.descendant(
      of: listViewFinder,
      matching: find.byType(MovieCard),
    );
    expect(movieCardViewFinder, findsOneWidget);

    final tvSeriesCardViewFinder = find.descendant(
      of: listViewFinder,
      matching: find.byType(TvSeriesCard),
    );
    expect(tvSeriesCardViewFinder, findsOneWidget);
  });

  testWidgets('Page should display Text when data is empty', (
    WidgetTester tester,
  ) async {
    when(
      mockWatchlistBloc.state,
    ).thenReturn(const BlocHasData<List<Watchlist>>([]));
    when(
      mockWatchlistBloc.stream,
    ).thenAnswer((_) => Stream.value(const BlocHasData<List<Watchlist>>([])));

    await tester.pumpWidget(makeTestableWidget(const WatchlistPage()));

    final centerFinder = find.byType(Center);
    expect(centerFinder, findsOneWidget);

    final textFinder = find.descendant(
      of: centerFinder,
      matching: find.byType(Text),
    );
    expect(textFinder, findsOneWidget);

    Text text = tester.widget(textFinder);
    expect(text.data, 'No data');
    expect(text.style, titleLarge);
  });

  testWidgets('Page should display text with message when Error', (
    WidgetTester tester,
  ) async {
    when(mockWatchlistBloc.state).thenReturn(const BlocError('Error message'));
    when(
      mockWatchlistBloc.stream,
    ).thenAnswer((_) => Stream.value(const BlocError('Error message')));

    await tester.pumpWidget(makeTestableWidget(const WatchlistPage()));

    final textFinder = find.byKey(const Key('error_message'));
    expect(textFinder, findsOneWidget);
  });
}
