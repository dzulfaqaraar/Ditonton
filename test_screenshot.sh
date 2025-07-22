#!/bin/bash

# Screenshot test script using flutter drive
echo "Running screenshot tests with flutter drive..."

# Create screenshots directory if it doesn't exist
mkdir -p screenshots

# Run the screenshot test
flutter drive \
  --driver=integration_test/screenshot_driver.dart \
  --target=integration_test/screenshot_test.dart \
  --screenshot=screenshots/

echo "Screenshot tests completed. Screenshots saved in the 'screenshots' directory."