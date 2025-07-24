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
          case episodeTvSeriesRoute:
            return MaterialPageRoute(
              builder: (_) => const Text('TV Series Episode Page'),
            );
        }
        return null;
      },
    );
  }

  group('Season Card', () {
    testWidgets('Page should display button', (WidgetTester tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          SeasonCard(
            tvSeries: testTvSeriesDetail,
            season: testTvSeriesDetail.seasons!.first,
          ),
        ),
      );

      final inkWellFinder = find.byKey(const Key('season_card_item'));
      expect(inkWellFinder, findsOneWidget);

      InkWell inkWell = tester.widget(inkWellFinder);
      expect(inkWell.onTap, isNotNull);
    });

    testWidgets('Page should display image', (WidgetTester tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          SeasonCard(
            tvSeries: testTvSeriesDetail,
            season: testTvSeriesDetail.seasons!.first,
          ),
        ),
      );

      final imageClipFinder = find.byType(ClipRRect);
      expect(imageClipFinder, findsWidgets);

      final imageFinder = find.byType(CachedNetworkImage);
      expect(imageFinder, findsOneWidget);

      CachedNetworkImage image = tester.widget(imageFinder);
      expect(image.errorWidget, isNotNull);
    });

    testWidgets('Page should display content', (WidgetTester tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          SeasonCard(
            tvSeries: testTvSeriesDetail,
            season: testTvSeriesDetail.seasons!.first,
          ),
        ),
      );

      final textFinder = find.byType(Text);

      final textNameFinder = textFinder.at(0);
      expect(textNameFinder, findsOneWidget);

      Text textName = tester.widget(textNameFinder);
      expect(textName.style, titleLarge);

      final textEpisodeFinder = textFinder.at(1);
      expect(textEpisodeFinder, findsOneWidget);

      Text textEpisode = tester.widget(textEpisodeFinder);
      expect(textEpisode.style, bodyMedium);

      final dividerFinder = find.byType(VerticalDivider);
      expect(dividerFinder, findsNothing);

      // Air date and overview are not shown for test data
      expect(textFinder, findsNWidgets(2));
    });

    testWidgets('Page should display air date and divider', (
      WidgetTester tester,
    ) async {
      final season = testTvSeriesDetail.seasons!.first;
      final newSeason = Season(
        id: season.id,
        name: season.name,
        airDate: '2022-07-24',
        overview: season.overview,
        posterPath: season.posterPath,
        episodeCount: season.episodeCount,
        seasonNumber: season.seasonNumber,
      );
      await tester.pumpWidget(
        makeTestableWidget(
          SeasonCard(tvSeries: testTvSeriesDetail, season: newSeason),
        ),
      );

      final dividerFinder = find.byType(VerticalDivider);
      expect(dividerFinder, findsOneWidget);
    });

    testWidgets(
      'Page should display overview with SizedBox and Text overflow',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            SeasonCard(
              tvSeries: testTvSeriesDetail,
              season: seasonWithOverview,
            ),
          ),
        );

        final sizedBoxFinder = find.byType(SizedBox);
        expect(sizedBoxFinder, findsWidgets);

        final textFinder = find.byType(Text);
        final overviewTextFinder = textFinder.at(2);
        expect(overviewTextFinder, findsOneWidget);

        Text overviewText = tester.widget(overviewTextFinder);
        expect(overviewText.maxLines, 2);
        expect(overviewText.overflow, TextOverflow.ellipsis);
        expect(overviewText.data, seasonWithOverview.overview);
      },
    );

    testWidgets('Page should display error icon when image fails to load', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        makeTestableWidget(
          SeasonCard(
            tvSeries: testTvSeriesDetail,
            season: seasonWithInvalidImage,
          ),
        ),
      );

      final imageFinder = find.byType(CachedNetworkImage);
      expect(imageFinder, findsOneWidget);

      CachedNetworkImage image = tester.widget(imageFinder);
      expect(image.errorWidget, isNotNull);

      // Test that errorWidget returns an Icon widget with error icon
      final context = tester.element(imageFinder);
      final errorWidget = image.errorWidget!(
        context,
        'invalid_url',
        Exception('Image load failed'),
      );

      expect(errorWidget, isA<Icon>());
      final icon = errorWidget as Icon;
      expect(icon.icon, Icons.error);
    });

    testWidgets('Button should open detail page', (WidgetTester tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          SeasonCard(
            tvSeries: testTvSeriesDetail,
            season: testTvSeriesDetail.seasons!.first,
          ),
        ),
      );

      final inkWellFinder = find.byKey(const Key('season_card_item'));
      expect(inkWellFinder, findsOneWidget);

      InkWell inkWell = tester.widget(inkWellFinder);
      expect(inkWell.onTap, isNotNull);

      await tester.tap(inkWellFinder);
      await tester.pump();
    });
  });
}
