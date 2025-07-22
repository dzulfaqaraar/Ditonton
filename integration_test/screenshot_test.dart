import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:get_it/get_it.dart';
import 'package:ditonton/main.dart' as app;

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  setUpAll(() async {
    GetIt.I.reset();
  });

  tearDown(() async {
    GetIt.I.reset();
  });

  group('Screenshot Tests', () {
    testWidgets('Home page screenshot', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await binding.takeScreenshot('home_page');
    });

    testWidgets('Movie detail screenshot', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final movieCard = find.byKey(Key('card_item_key')).first;
      await tester.tap(movieCard);
      await tester.pumpAndSettle();

      await binding.takeScreenshot('movie_detail');
    });

    testWidgets('TV series page screenshot', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('drawer_icon')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('menu_tv_series')));
      await tester.pumpAndSettle();

      await binding.takeScreenshot('tv_series_page');
    });

    testWidgets('TV series detail screenshot', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('drawer_icon')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('menu_tv_series')));
      await tester.pumpAndSettle();

      final tvSeriesCard = find.byKey(Key('card_item_key')).first;
      await tester.tap(tvSeriesCard);
      await tester.pumpAndSettle();

      await binding.takeScreenshot('tv_series_detail');
    });

    testWidgets('Watchlist page screenshot', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Add a movie to watchlist first
      final movieCard = find.byKey(Key('card_item_key')).first;
      await tester.tap(movieCard);
      await tester.pumpAndSettle();

      final addToWatchlistButton = find.byType(ElevatedButton);
      await tester.tap(addToWatchlistButton);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('drawer_icon')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('menu_watchlist')));
      await tester.pumpAndSettle();

      await binding.takeScreenshot('watchlist_page');
    });

    testWidgets('Search page screenshot', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('drawer_icon')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('menu_search')));
      await tester.pumpAndSettle();

      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'Spider-Man');
      await tester.pumpAndSettle();

      await binding.takeScreenshot('search_page');
    });

    testWidgets('About page screenshot', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('drawer_icon')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('menu_about')));
      await tester.pumpAndSettle();

      await binding.takeScreenshot('about_page');
    });

    testWidgets('Popular movies screenshot', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final seeMoreButton = find.text('See More').first;
      await tester.tap(seeMoreButton);
      await tester.pumpAndSettle();

      await binding.takeScreenshot('popular_movies');
    });
  });
}