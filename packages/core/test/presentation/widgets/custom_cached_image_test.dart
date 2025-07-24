import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/presentation/widgets/custom_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomCachedImage Widget Tests', () {
    const testImageUrl = 'https://example.com/test_image.jpg';

    Widget makeTestableWidget(Widget body) {
      return MaterialApp(home: Scaffold(body: body));
    }

    testWidgets('should display CachedNetworkImage with given imageUrl', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        makeTestableWidget(const CustomCachedImage(imageUrl: testImageUrl)),
      );

      final cachedNetworkImageFinder = find.byType(CachedNetworkImage);
      expect(cachedNetworkImageFinder, findsOneWidget);

      final CachedNetworkImage cachedNetworkImage = tester.widget(
        cachedNetworkImageFinder,
      );
      expect(cachedNetworkImage.imageUrl, testImageUrl);
    });

    testWidgets('should display default placeholder', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        makeTestableWidget(const CustomCachedImage(imageUrl: testImageUrl)),
      );

      final cachedNetworkImageFinder = find.byType(CachedNetworkImage);
      expect(cachedNetworkImageFinder, findsOneWidget);

      final CachedNetworkImage cachedNetworkImage = tester.widget(
        cachedNetworkImageFinder,
      );

      final placeholderWidget = cachedNetworkImage.placeholder!(
        tester.element(cachedNetworkImageFinder),
        testImageUrl,
      );

      expect(placeholderWidget, isA<Center>());
      final Center centerWidget = placeholderWidget as Center;
      expect(centerWidget.child, isA<CircularProgressIndicator>());
    });

    testWidgets('should display default error widget', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        makeTestableWidget(const CustomCachedImage(imageUrl: testImageUrl)),
      );

      final cachedNetworkImageFinder = find.byType(CachedNetworkImage);
      expect(cachedNetworkImageFinder, findsOneWidget);

      final CachedNetworkImage cachedNetworkImage = tester.widget(
        cachedNetworkImageFinder,
      );

      final errorWidget = cachedNetworkImage.errorWidget!(
        tester.element(cachedNetworkImageFinder),
        testImageUrl,
        Exception('Network error'),
      );

      expect(errorWidget, isA<Icon>());
      final Icon errorIcon = errorWidget as Icon;
      expect(errorIcon.icon, Icons.error);
    });

    testWidgets('should create CustomCachedImage widget', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        makeTestableWidget(const CustomCachedImage(imageUrl: testImageUrl)),
      );

      final customCachedImageFinder = find.byType(CustomCachedImage);
      expect(customCachedImageFinder, findsOneWidget);

      final CustomCachedImage customCachedImage = tester.widget(
        customCachedImageFinder,
      );
      expect(customCachedImage.imageUrl, testImageUrl);
    });

    testWidgets('should set width and height properties correctly', (
      WidgetTester tester,
    ) async {
      const testWidth = 200.0;
      const testHeight = 300.0;

      await tester.pumpWidget(
        makeTestableWidget(
          const CustomCachedImage(
            imageUrl: testImageUrl,
            width: testWidth,
            height: testHeight,
          ),
        ),
      );

      final cachedNetworkImageFinder = find.byType(CachedNetworkImage);
      expect(cachedNetworkImageFinder, findsOneWidget);

      final CachedNetworkImage cachedNetworkImage = tester.widget(
        cachedNetworkImageFinder,
      );

      expect(cachedNetworkImage.width, testWidth);
      expect(cachedNetworkImage.height, testHeight);
    });

    testWidgets('should set fit property correctly', (
      WidgetTester tester,
    ) async {
      const testFit = BoxFit.cover;

      await tester.pumpWidget(
        makeTestableWidget(
          const CustomCachedImage(imageUrl: testImageUrl, fit: testFit),
        ),
      );

      final cachedNetworkImageFinder = find.byType(CachedNetworkImage);
      expect(cachedNetworkImageFinder, findsOneWidget);

      final CachedNetworkImage cachedNetworkImage = tester.widget(
        cachedNetworkImageFinder,
      );

      expect(cachedNetworkImage.fit, testFit);
    });

    testWidgets('should set all optional parameters correctly', (
      WidgetTester tester,
    ) async {
      const testWidth = 150.0;
      const testHeight = 250.0;
      const testFit = BoxFit.fitWidth;

      await tester.pumpWidget(
        makeTestableWidget(
          const CustomCachedImage(
            imageUrl: testImageUrl,
            width: testWidth,
            height: testHeight,
            fit: testFit,
          ),
        ),
      );

      final customCachedImageFinder = find.byType(CustomCachedImage);
      expect(customCachedImageFinder, findsOneWidget);

      final CustomCachedImage customCachedImage = tester.widget(
        customCachedImageFinder,
      );

      expect(customCachedImage.imageUrl, testImageUrl);
      expect(customCachedImage.width, testWidth);
      expect(customCachedImage.height, testHeight);
      expect(customCachedImage.fit, testFit);

      final cachedNetworkImageFinder = find.byType(CachedNetworkImage);
      expect(cachedNetworkImageFinder, findsOneWidget);

      final CachedNetworkImage cachedNetworkImage = tester.widget(
        cachedNetworkImageFinder,
      );

      expect(cachedNetworkImage.width, testWidth);
      expect(cachedNetworkImage.height, testHeight);
      expect(cachedNetworkImage.fit, testFit);
    });
  });
}
