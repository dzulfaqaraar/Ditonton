import 'dart:io';
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

  Future<void> takeScreenshot(String screenshotName) async {
    if (Platform.isAndroid) {
      await binding.convertFlutterSurfaceToImage();
    }
    await binding.takeScreenshot(screenshotName);
  }

  group('Screenshot Tests', () {
    testWidgets('Movies page screenshot', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await takeScreenshot('1.movies_page');
    });

    testWidgets('Movie detail screenshot', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final movieCard = find.byKey(Key('card_item_key')).first;
      await tester.tap(movieCard);
      await tester.pumpAndSettle();

      await takeScreenshot('2.movies_detail');
    });

    testWidgets('Movies popular screenshot', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final seeMoreButton = find.text('See More').first;
      await tester.tap(seeMoreButton);
      await tester.pumpAndSettle();

      await takeScreenshot('3.movies_popular');
    });

    testWidgets('Movies top rated screenshot', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final seeMoreButtons = find.text('See More');
      if (seeMoreButtons.evaluate().length >= 2) {
        await tester.tap(seeMoreButtons.at(1));
        await tester.pumpAndSettle();
      }

      await takeScreenshot('4.movies_top_rated');
    });

    testWidgets('Movies search screenshot', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final searchIcon = find.byIcon(Icons.search);
      await tester.tap(searchIcon);
      await tester.pumpAndSettle();

      final searchField = find.byType(TextField);
      if (searchField.evaluate().isNotEmpty) {
        await tester.enterText(searchField, 'Harry');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();
        await tester.pump(const Duration(seconds: 2));
      }

      await takeScreenshot('5.movies_search_page');
    });

    testWidgets('TV Series page screenshot', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('drawer_icon')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('menu_tv_series')));
      await tester.pumpAndSettle();

      await takeScreenshot('6.tv_series_page');
    });

    testWidgets('TV Series detail screenshot', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('drawer_icon')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('menu_tv_series')));
      await tester.pumpAndSettle();

      final tvSeriesCard = find.byKey(Key('card_item_key')).first;
      await tester.tap(tvSeriesCard);
      await tester.pumpAndSettle();

      await takeScreenshot('7.tv_series_detail');
    });

    testWidgets('TV Series airing today screenshot', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('drawer_icon')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('menu_tv_series')));
      await tester.pumpAndSettle();

      final seeMoreButtons = find.text('See More');
      if (seeMoreButtons.evaluate().isNotEmpty) {
        await tester.tap(seeMoreButtons.first);
        await tester.pumpAndSettle();
      }

      await takeScreenshot('8.tv_series_airing_today');
    });

    testWidgets('TV Series popular screenshot', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('drawer_icon')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('menu_tv_series')));
      await tester.pumpAndSettle();

      final seeMoreButtons = find.text('See More');
      if (seeMoreButtons.evaluate().length >= 2) {
        await tester.tap(seeMoreButtons.at(1));
        await tester.pumpAndSettle();
      }

      await takeScreenshot('9.tv_series_popular');
    });

    testWidgets('TV Series top rated screenshot', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('drawer_icon')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('menu_tv_series')));
      await tester.pumpAndSettle();

      final seeMoreButtons = find.text('See More');
      if (seeMoreButtons.evaluate().length >= 3) {
        await tester.tap(seeMoreButtons.at(2));
        await tester.pumpAndSettle();
      }

      await takeScreenshot('10.tv_series_top_rated');
    });

    testWidgets('TV Series search screenshot', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('drawer_icon')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('menu_tv_series')));
      await tester.pumpAndSettle();

      final searchIcon = find.byIcon(Icons.search);
      await tester.tap(searchIcon);
      await tester.pumpAndSettle();

      final searchField = find.byType(TextField);
      if (searchField.evaluate().isNotEmpty) {
        await tester.enterText(searchField, 'One Piece');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();
        await tester.pump(const Duration(seconds: 2));
      }

      await takeScreenshot('11.tv_series_search_page');
    });

    testWidgets('TV Series season screenshot', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('drawer_icon')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('menu_tv_series')));
      await tester.pumpAndSettle();

      final searchIcon = find.byIcon(Icons.search);
      await tester.tap(searchIcon);
      await tester.pumpAndSettle();

      final searchField = find.byType(TextField);
      if (searchField.evaluate().isNotEmpty) {
        await tester.enterText(searchField, 'One Piece');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();
        await tester.pump(const Duration(seconds: 2));
      }

      final tvSeriesCard = find.byKey(Key('tv_series_card_item')).first;
      await tester.tap(tvSeriesCard);
      await tester.pumpAndSettle();

      final seasonButton = find.byKey(Key('season_button_toggle'));
      if (seasonButton.evaluate().isNotEmpty) {
        await tester.tap(seasonButton);
        await tester.pumpAndSettle();
      }

      // Scroll to bottom more before taking screenshot
      final customScrollView = find.byType(CustomScrollView);
      if (customScrollView.evaluate().isNotEmpty) {
        await tester.drag(customScrollView, const Offset(0, -600));
        await tester.pump();
      }

      // Check if season has View All button and click it
      final viewAllButton = find.text('View All');
      if (viewAllButton.evaluate().isNotEmpty) {
        await tester.tap(viewAllButton);
        await tester.pumpAndSettle();

        // Additional scroll to bottom
        await tester.drag(customScrollView, const Offset(0, -300));
        await tester.pumpAndSettle();
      }

      await takeScreenshot('12.tv_series_season');
    });

    testWidgets('TV Series episode screenshot', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('drawer_icon')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('menu_tv_series')));
      await tester.pumpAndSettle();

      final searchIcon = find.byIcon(Icons.search);
      await tester.tap(searchIcon);
      await tester.pumpAndSettle();

      final searchField = find.byType(TextField);
      if (searchField.evaluate().isNotEmpty) {
        await tester.enterText(searchField, 'One Piece');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();
        await tester.pump(const Duration(seconds: 2));
      }

      final tvSeriesCard = find.byKey(Key('tv_series_card_item')).first;
      await tester.tap(tvSeriesCard);
      await tester.pumpAndSettle();

      final seasonButton = find.byKey(Key('season_button_toggle'));
      if (seasonButton.evaluate().isNotEmpty) {
        await tester.tap(seasonButton);
        await tester.pumpAndSettle();
      }

      final customScrollView = find.byType(CustomScrollView);
      if (customScrollView.evaluate().isNotEmpty) {
        await tester.drag(customScrollView, const Offset(0, -600));
        await tester.pump();
      }

      final seasonCard = find.byKey(Key('season_card_item')).first;
      if (seasonCard.evaluate().isNotEmpty) {
        await tester.tap(seasonCard);
        await tester.pumpAndSettle();
      }

      await takeScreenshot('13.tv_series_episode');
    });

    testWidgets('Watchlist page screenshot', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Movies Page

      final movieCard = find.byKey(Key('card_item_key')).first;
      await tester.tap(movieCard);
      await tester.pumpAndSettle();

      final movieWatchlistButton = find.byKey(Key('watchlist_text'));
      if (movieWatchlistButton.evaluate().isNotEmpty) {
        await tester.tap(movieWatchlistButton);
        await tester.pumpAndSettle();
      }

      final movieBackButton = find.byIcon(Icons.arrow_back);
      if (movieBackButton.evaluate().isNotEmpty) {
        await tester.tap(movieBackButton);
        await tester.pumpAndSettle();
      }

      // TV Series Page

      await tester.tap(find.byKey(Key('drawer_icon')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('menu_tv_series')));
      await tester.pumpAndSettle();

      final tvSeriesCard = find.byKey(Key('card_item_key')).first;
      await tester.tap(tvSeriesCard);
      await tester.pumpAndSettle();

      final tvSeriesWatchlistButton = find.byKey(Key('watchlist_text'));
      if (tvSeriesWatchlistButton.evaluate().isNotEmpty) {
        await tester.tap(tvSeriesWatchlistButton);
        await tester.pumpAndSettle();
      }

      final tvSeriesBackButton = find.byIcon(Icons.arrow_back);
      if (tvSeriesBackButton.evaluate().isNotEmpty) {
        await tester.tap(tvSeriesBackButton);
        await tester.pumpAndSettle();
      }

      // Wait for snackbar animations
      await tester.pump(const Duration(seconds: 3));

      // Watchlist Page

      await tester.tap(find.byKey(Key('drawer_icon')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('menu_watchlist')));
      await tester.pumpAndSettle();

      await takeScreenshot('14.watchlist_page');
    });

    testWidgets('About page screenshot', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('drawer_icon')));
      await tester.pumpAndSettle();

      final aboutTile = find.byIcon(Icons.info_outline);
      await tester.tap(aboutTile);
      await tester.pumpAndSettle();

      await takeScreenshot('15.about_page');
    });
  });
}
