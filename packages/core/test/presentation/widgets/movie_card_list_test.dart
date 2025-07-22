import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  Widget makeTestableWidget(Widget body) {
    return MaterialApp(
      home: Scaffold(body: body),
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case detailMovieRoute:
            return MaterialPageRoute(
              builder: (_) => const Text('Movie Detail Page'),
            );
        }
        return null;
      },
    );
  }

  group('Movie Card', () {
    testWidgets('Page should display button', (WidgetTester tester) async {
      await tester.pumpWidget(
        makeTestableWidget(const MovieCard(movie: testMovie)),
      );

      final inkWellFinder = find.byKey(const Key('movie_card_item'));
      expect(inkWellFinder, findsOneWidget);

      InkWell inkWell = tester.widget(inkWellFinder);
      expect(inkWell.onTap, isNotNull);
    });

    testWidgets('Page should display image', (WidgetTester tester) async {
      await tester.pumpWidget(
        makeTestableWidget(const MovieCard(movie: testMovie)),
      );

      final imageClipFinder = find.byType(ClipRRect);
      expect(imageClipFinder, findsOneWidget);

      final imageFinder = find.byType(CachedNetworkImage);
      expect(imageFinder, findsOneWidget);

      CachedNetworkImage image = tester.widget(imageFinder);
      expect(image.errorWidget, isNotNull);
    });

    testWidgets('Button should open detail page', (WidgetTester tester) async {
      await tester.pumpWidget(
        makeTestableWidget(const MovieCard(movie: testMovie)),
      );

      final inkWellFinder = find.byKey(const Key('movie_card_item'));
      expect(inkWellFinder, findsOneWidget);

      InkWell inkWell = tester.widget(inkWellFinder);
      expect(inkWell.onTap, isNotNull);

      await tester.tap(inkWellFinder);
      await tester.pump();
    });
  });
}
