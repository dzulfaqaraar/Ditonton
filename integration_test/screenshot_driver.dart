import 'dart:io';
import 'package:integration_test/integration_test_driver_extended.dart';

Future<void> main() {
  return integrationDriver(
    onScreenshot:
        (
          String screenshotName,
          List<int> screenshotBytes, [
          Map<String, Object?>? args,
        ]) async {
          final Directory screenshotsDir = Directory('screenshots');

          if (!await screenshotsDir.exists()) {
            await screenshotsDir.create(recursive: true);
          }

          final File screenshot = File('screenshots/$screenshotName.png');
          await screenshot.writeAsBytes(screenshotBytes);

          return true;
        },
  );
}
