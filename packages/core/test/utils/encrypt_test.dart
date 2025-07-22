import 'package:core/core.dart';
import 'package:core/utils/encrypt.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:string_validator/string_validator.dart';

void main() {
  test('should encrypt the plain text as base64', () async {
    final result = encrypt('password');
    expect(isBase64(result), true);
  });
}
