import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/utils/utils.dart';

void main() {
  group('Utils Tests', () {
    test('routeObserver should be a RouteObserver instance', () {
      expect(routeObserver, isA<RouteObserver<ModalRoute>>());
    });

    test('routeObserver should be the same instance', () {
      final observer1 = routeObserver;
      final observer2 = routeObserver;
      expect(identical(observer1, observer2), isTrue);
    });
  });
}
