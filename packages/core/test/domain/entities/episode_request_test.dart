import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should be a class of EpisodeRequest when call constructor', () async {
    final result = EpisodeRequest(title: 'Title', id: 1, season: 1);
    expect(result, isInstanceOf<EpisodeRequest>());
  });
}
