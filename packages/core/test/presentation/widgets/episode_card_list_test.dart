import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  Widget makeTestableWidget(Widget body) {
    return MaterialApp(home: Scaffold(body: body));
  }

  group('Episode Card', () {
    testWidgets('Page should display header', (WidgetTester tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          EpisodeCard(episode: testTvSeriesEpisode.episodes!.first),
        ),
      );

      final headerFinder = find.byKey(const Key('episode_header'));
      expect(headerFinder, findsOneWidget);

      final imageClipFinder = find.byType(ClipRRect);
      expect(imageClipFinder, findsOneWidget);

      final imageFinder = find.byType(CachedNetworkImage);
      expect(imageFinder, findsOneWidget);

      CachedNetworkImage image = tester.widget(imageFinder);
      expect(image.errorWidget, isNotNull);

      final textFinder = find.descendant(
        of: headerFinder,
        matching: find.byType(Text),
      );
      expect(textFinder, findsWidgets);

      Text textName = tester.widget(textFinder.at(0));
      expect(textName.style, headlineSmall);

      Text textOverview = tester.widget(textFinder.at(1));
      expect(textOverview.style, bodyMedium);
      expect(textOverview.maxLines, 2);
    });

    testWidgets('Page should display content when expanded', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        makeTestableWidget(
          EpisodeCard(episode: testTvSeriesEpisode.episodes!.first),
        ),
      );

      final inkWellFinder = find.byKey(const Key('episode_card_item'));
      await tester.tap(inkWellFinder);
      await tester.pump();

      final overviewFinder = find.text('Overview');
      expect(overviewFinder, findsOneWidget);

      Text textOverview = tester.widget(overviewFinder);
      expect(textOverview.style, titleLarge);

      final guestStarsTextFinder = find.text('Guest Stars');
      expect(guestStarsTextFinder, findsOneWidget);

      Text textGuestStars = tester.widget(guestStarsTextFinder);
      expect(textGuestStars.style, titleLarge);

      final guestStarsListFinder = find.byType(ListView);
      expect(guestStarsListFinder, findsOneWidget);
    });

    testWidgets(
      'Page should display error icon when episode image fails to load',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          makeTestableWidget(EpisodeCard(episode: episodeWithInvalidImage)),
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
      },
    );

    testWidgets(
      'Page should display error icon when guest star image fails to load',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            EpisodeCard(episode: episodeWithInvalidGuestImage),
          ),
        );

        // Expand the episode to show guest stars
        final inkWellFinder = find.byKey(const Key('episode_card_item'));
        await tester.tap(inkWellFinder);
        await tester.pump();

        final imageFinderList = find.byType(CachedNetworkImage);
        expect(
          imageFinderList,
          findsNWidgets(2),
        ); // Episode image + Guest star image

        // Test the guest star image (second CachedNetworkImage)
        CachedNetworkImage guestImage = tester.widget(imageFinderList.at(1));
        expect(guestImage.errorWidget, isNotNull);

        // Test that errorWidget returns an Icon widget with error icon
        final context = tester.element(imageFinderList.at(1));
        final errorWidget = guestImage.errorWidget!(
          context,
          'invalid_url',
          Exception('Image load failed'),
        );

        expect(errorWidget, isA<Icon>());
        final icon = errorWidget as Icon;
        expect(icon.icon, Icons.error);
      },
    );

    testWidgets('Page should display button', (WidgetTester tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          EpisodeCard(episode: testTvSeriesEpisode.episodes!.first),
        ),
      );

      final inkWellFinder = find.byKey(const Key('episode_card_item'));
      expect(inkWellFinder, findsOneWidget);

      InkWell inkWell = tester.widget(inkWellFinder);
      expect(inkWell.onTap, isNotNull);

      final iconFinder = find.descendant(
        of: inkWellFinder,
        matching: find.byType(Icon),
      );
      expect(iconFinder, findsOneWidget);

      Icon icon = tester.widget(iconFinder);
      expect(icon.icon, Icons.arrow_drop_down);

      final expandFinder = find.text('Expand');
      expect(expandFinder, findsOneWidget);

      await tester.tap(inkWellFinder);
      await tester.pump();

      final inkWellFinder2 = find.byKey(const Key('episode_card_item'));
      final iconFinder2 = find.descendant(
        of: inkWellFinder2,
        matching: find.byType(Icon),
      );

      Icon iconAfter = tester.widget(iconFinder2);
      expect(iconAfter.icon, Icons.arrow_drop_up);

      final expandAfterFinder = find.text('Close');
      expect(expandAfterFinder, findsOneWidget);
    });
  });
}
