import 'package:core/presentation/widgets/movie_card_list.dart';
import 'package:core/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ditonton/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // Reset GetIt to avoid duplicate registration between tests
    GetIt.I.reset();
  });

  tearDown(() async {
    // Reset GetIt after each test to prevent state pollution
    GetIt.I.reset();
  });

  group('Adding Watchlist', () {
    testWidgets("Movies", (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final itemFinder = find.byKey(Key('card_item_key')).first;
      await tester.tap(itemFinder);
      await tester.pumpAndSettle();

      final buttonWatchlistFinder = find.byType(ElevatedButton);

      final iconWatchlistFinder = find.descendant(
        of: buttonWatchlistFinder,
        matching: find.byType(Icon),
      );
      expect(iconWatchlistFinder, findsOneWidget);

      Icon iconWatchlist = tester.widget(iconWatchlistFinder);
      expect(iconWatchlist.icon, Icons.add);

      await tester.tap(buttonWatchlistFinder);
      await tester.pumpAndSettle();

      Icon iconWatchlistAfter = tester.widget(iconWatchlistFinder);
      expect(iconWatchlistAfter.icon, Icons.check);

      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('drawer_icon')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('menu_watchlist')));
      await tester.pumpAndSettle();

      final listViewFinder = find.byType(ListView);
      expect(listViewFinder, findsOneWidget);

      final movieCardFinder = find.byType(MovieCard);
      expect(movieCardFinder, findsOneWidget);

      await tester.tap(movieCardFinder);
      await tester.pumpAndSettle();

      final buttonWatchlistAfterFinder = find.byType(ElevatedButton);
      await tester.pumpAndSettle();

      await tester.tap(buttonWatchlistAfterFinder);
      await tester.pumpAndSettle();

      final iconWatchlistAfterFinder = find.descendant(
        of: buttonWatchlistFinder,
        matching: find.byType(Icon),
      );
      Icon iconWatchlistFinal = tester.widget(iconWatchlistAfterFinder);
      expect(iconWatchlistFinal.icon, Icons.add);
    });

    testWidgets("TV Series", (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('drawer_icon')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('menu_tv_series')));
      await tester.pumpAndSettle();

      final itemFinder = find.byKey(Key('card_item_key')).first;
      await tester.tap(itemFinder);
      await tester.pumpAndSettle();

      final buttonWatchlistFinder = find.byType(ElevatedButton);

      final iconWatchlistFinder = find.descendant(
        of: buttonWatchlistFinder,
        matching: find.byType(Icon),
      );
      expect(iconWatchlistFinder, findsOneWidget);

      Icon iconWatchlist = tester.widget(iconWatchlistFinder);
      expect(iconWatchlist.icon, Icons.add);

      await tester.tap(buttonWatchlistFinder);
      await tester.pumpAndSettle();

      Icon iconWatchlistAfter = tester.widget(iconWatchlistFinder);
      expect(iconWatchlistAfter.icon, Icons.check);

      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('drawer_icon')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('menu_watchlist')));
      await tester.pumpAndSettle();

      final listViewFinder = find.byType(ListView);
      expect(listViewFinder, findsOneWidget);

      final tvSeriesCardFinder = find.byType(TvSeriesCard);
      expect(tvSeriesCardFinder, findsOneWidget);

      await tester.tap(tvSeriesCardFinder);
      await tester.pumpAndSettle();

      final buttonWatchlistAfterFinder = find.byType(ElevatedButton);
      await tester.pumpAndSettle();

      await tester.tap(buttonWatchlistAfterFinder);
      await tester.pumpAndSettle();

      final iconWatchlistAfterFinder = find.descendant(
        of: buttonWatchlistFinder,
        matching: find.byType(Icon),
      );
      Icon iconWatchlistFinal = tester.widget(iconWatchlistAfterFinder);
      expect(iconWatchlistFinal.icon, Icons.add);
    });
  });
}
