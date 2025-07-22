import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget makeTestableWidget(Widget body) {
    return MaterialApp(home: Scaffold(body: body));
  }

  group('Sub Heading View', () {
    testWidgets('Page should display title and button with icon', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        makeTestableWidget(SubHeadingView(title: 'Popular', onTap: () {})),
      );

      final titleFinder = find.text('Popular');
      expect(titleFinder, findsOneWidget);

      Text title = tester.widget(titleFinder);
      expect(title.style, titleLarge);

      final buttonFinder = find.byType(InkWell);
      expect(buttonFinder, findsOneWidget);

      final seeMoreTextFinder = find.descendant(
        of: buttonFinder,
        matching: find.text('See More'),
      );
      expect(seeMoreTextFinder, findsWidgets);

      final seeMoreIconFinder = find.descendant(
        of: buttonFinder,
        matching: find.byType(Icon),
      );
      expect(seeMoreIconFinder, findsWidgets);

      Icon seeMoreIcon = tester.widget(seeMoreIconFinder);
      expect(seeMoreIcon.icon, Icons.arrow_forward_ios);
    });
  });
}
