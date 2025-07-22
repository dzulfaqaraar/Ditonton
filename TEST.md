# Testing Documentation

This document explains the testing strategy and tools used in the Ditonton Flutter project.

## Test.sh Script Overview

The `test.sh` script is a bash utility for running **unit and widget tests only** with code coverage generation. It does **NOT** include integration tests.

### What test.sh Does

1. **Runs Unit and Widget Tests**: Executes `flutter test --coverage` for all packages
2. **Generates Code Coverage**: Creates combined coverage reports from all packages
3. **Automated Discovery**: Finds all directories with `pubspec.yaml` and `test/` folders
4. **Coverage Combination**: Merges coverage data from multiple packages into a single report
5. **HTML Report Generation**: Creates browsable coverage reports (if lcov is installed)

### What test.sh Does NOT Do

- **Integration Tests**: Does not run tests in `integration_test/` directory
- **Device-Dependent Tests**: Only runs tests that don't require emulator/device
- **End-to-End Testing**: Focuses on isolated unit testing, not full app workflows

### Why Integration Tests Are Excluded

Integration tests are **not included** in `test.sh` because:

1. **Device Requirements**: Integration tests require a running device/emulator
2. **Performance**: They are much slower than unit/widget tests (minutes vs seconds)
3. **Coverage Limitations**: Don't generate meaningful code coverage metrics
4. **CI/CD Separation**: Unit tests run in fast CI pipelines, integration tests in separate slower pipelines
5. **Different Purpose**: Unit tests verify individual components, integration tests verify full user workflows

### Script Behavior

- **Input**: Optional directory parameter (defaults to all packages)
- **Discovery**: Searches directories at maxdepth 2 for Flutter packages
- **Execution**: Runs `flutter pub get`, `build_runner build`, then `flutter test --coverage`
- **Output**: Combined `coverage/lcov.info` and HTML report
- **Error Handling**: Continues testing all packages even if some fail, reports errors at end

### Package Structure Tested

The script automatically tests these directories:
- `packages/core/test/` - Core functionality tests
- `packages/movies/test/` - Movie feature tests  
- `packages/tv_series/test/` - TV series feature tests
- `packages/search/test/` - Search functionality tests
- `packages/watchlist/test/` - Watchlist feature tests
- Root `test/` directory (if it exists)

### Usage Examples

#### **Executing Shell Scripts**

Different terminals and shells have different ways to execute `.sh` files:

```bash
# Method 1: Direct execution (requires executable permission)
chmod +x test.sh        # Make executable (run once)  
./test.sh              # Execute directly (bash, zsh, fish)

# Method 2: Shell interpreter (works without executable permission)
sh test.sh             # Works in all POSIX shells (bash, zsh, dash)
bash test.sh           # Explicitly use bash interpreter
```

**Recommended approach**: Use `sh test.sh` for maximum compatibility.

#### **Usage Examples**

```bash
# Run all unit/widget tests with coverage
sh test.sh

# Run tests for specific package
sh test.sh packages/core
```

## Integration Testing (Separate Process)

Integration tests are run separately using different commands:

### Modern Approach (Recommended)
```bash
flutter test integration_test/
flutter test integration_test/app_test.dart
```

### Legacy Approach (flutter_driver)
```bash
flutter drive --driver=integration_test/driver.dart --target=integration_test/app_test.dart
```

### Using the Integration Test Script (Recommended)

A dedicated `integration_test.sh` script has been created for comprehensive integration testing:

#### **Executing Shell Scripts**

Different terminals and shells have different ways to execute `.sh` files:

```bash
# Method 1: Direct execution (requires executable permission)
chmod +x integration_test.sh    # Make executable (run once)
./integration_test.sh           # Execute directly (bash, zsh, fish)

# Method 2: Shell interpreter (works without executable permission)
sh integration_test.sh          # Works in all POSIX shells (bash, zsh, dash)
bash integration_test.sh        # Explicitly use bash interpreter

# Method 3: Current shell execution  
source integration_test.sh      # Run in current shell context (not recommended for scripts)
```

**Recommended approach**: Use `sh integration_test.sh` for maximum compatibility across different terminals and operating systems.

#### **Usage Examples**

```bash
# Run all integration tests
sh integration_test.sh

# Run on specific device
sh integration_test.sh -d android
sh integration_test.sh -d emulator-5554

# Run specific test file
sh integration_test.sh -f app_test.dart

# Run with coverage
sh integration_test.sh -c

# Use flutter drive (legacy)
sh integration_test.sh -D -d emulator-5554

# List available devices
sh integration_test.sh -l

# Show help
sh integration_test.sh -h
```

**Script Features:**
- ✅ **Device Detection**: Automatically detects and validates available devices
- ✅ **Prerequisites Check**: Verifies Flutter installation and project structure
- ✅ **Multiple Test Files**: Can run single test file or all tests
- ✅ **Both Methods**: Supports both `flutter test` (modern) and `flutter drive` (legacy)
- ✅ **Coverage Reports**: Generates coverage reports with HTML output
- ✅ **Timeout Handling**: Prevents tests from hanging indefinitely
- ✅ **Colored Output**: Clear visual feedback during execution
- ✅ **Error Handling**: Comprehensive error messages and validation

## Complete Testing Strategy

For comprehensive testing of the Ditonton project:

1. **Fast Feedback Loop**: Run `./test.sh` for quick unit/widget test verification
2. **Full Coverage**: Run individual package tests during development
3. **End-to-End Validation**: Run integration tests before releases
4. **Continuous Integration**: Use `test.sh` in automated pipelines for fast feedback
5. **Manual Testing**: Run integration tests on multiple devices/platforms before deployment

## How to Distinguish Between Unit Tests and Widget Tests

Based on the actual test files in this Flutter project, here are the key differences:

### **UNIT TESTS** (Testing Business Logic)

#### Characteristics:
- **Function**: Uses `test()` function
- **Parameters**: No special parameters
- **Purpose**: Tests pure business logic, data models, repositories, use cases
- **Dependencies**: Mock external dependencies
- **No Flutter Widgets**: Tests functions and classes in isolation

#### Examples from this project:

**1. Use Case Tests** (`packages/core/test/domain/usecase/get_movies_test.dart`):
```dart
import 'package:flutter_test/flutter_test.dart';

test('should get list of movies from the repository', () async {
  // arrange
  when(mockMovieRepository.getMovies(url))
      .thenAnswer((_) async => Right(tMovies));
  // act
  final result = await usecase.execute(url);
  // assert
  expect(result, Right(tMovies));
});
```

**2. Repository Tests** (`packages/core/test/data/repositories/movie_repository_impl_test.dart`):
```dart
test('should return remote data when call to remote data source is successful', () async {
  // arrange
  when(mockRemoteDataSource.getMovies(url))
      .thenAnswer((_) async => tMovieModelList);
  // act
  final result = await repository.getMovies(url);
  // assert
  verify(mockRemoteDataSource.getMovies(url));
  expect(result, Right(tMovieList));
});
```

**3. BLoC Tests** (`packages/movies/test/presentation/bloc/movie_detail_bloc_test.dart`):
```dart
import 'package:bloc_test/bloc_test.dart';

blocTest<MovieDetailBloc, BlocState>(
  'Should emit [Loading, HasData] when data is gotten successfully',
  build: () => movieDetailBloc,
  act: (bloc) => bloc.add(const OnFetchingDetail(1)),
  expect: () => [BlocLoading(), const BlocHasData(testMovieDetail)],
);
```

### **WIDGET TESTS** (Testing UI Components)

#### Characteristics:
- **Function**: Uses `testWidgets()` function
- **Parameters**: Takes `(WidgetTester tester)` parameter
- **Purpose**: Tests UI widgets, pages, user interactions
- **Setup**: Uses `tester.pumpWidget()` to render widgets
- **Interactions**: Can simulate taps, scrolling, text input
- **Verification**: Uses `find` API to locate and verify widgets
- **Frame Updates**: Uses `pump()` and `pumpAndSettle()` to update widget tree

#### Examples from this project:

**1. Simple Widget Tests** (`packages/core/test/presentation/widgets/movie_card_list_test.dart`):
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

testWidgets('Page should display button', (WidgetTester tester) async {
  await tester.pumpWidget(makeTestableWidget(const MovieCard(movie: testMovie)));

  final inkWellFinder = find.byKey(const Key('movie_card_item'));
  expect(inkWellFinder, findsOneWidget);

  InkWell inkWell = tester.widget(inkWellFinder);
  expect(inkWell.onTap, isNotNull);
});
```

**2. Page Tests** (`packages/movies/test/presentation/pages/movie_detail_page_test.dart`):
```dart
testWidgets('Page should display Movie Detail when data load successfully',
    (WidgetTester tester) async {
  // arrange
  arrangeUsecaseDetailHasData();
  
  // act
  await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
  
  // assert
  final imageFinder = find.byType(CachedNetworkImage);
  expect(imageFinder, findsOneWidget);
});
```

### **INTEGRATION TESTS** (End-to-End Testing)

#### Characteristics:
- **Function**: Uses `testWidgets()` function with integration binding
- **Setup**: `IntegrationTestWidgetsFlutterBinding.ensureInitialized()`
- **Purpose**: Tests complete user workflows across the entire app
- **Dependencies**: Uses real app with real dependencies (no mocking)
- **Scope**: Full app flows from start to finish

#### Example from this project (`integration_test/app_test.dart`):
```dart
import 'package:integration_test/integration_test.dart';
import 'package:ditonton/main.dart' as app;

testWidgets("Movies", (tester) async {
  app.main(); // Launch real app
  await tester.pumpAndSettle();

  final itemFinder = find.byKey(Key('card_item_key')).first;
  await tester.tap(itemFinder);
  await tester.pumpAndSettle();

  final buttonWatchlistFinder = find.byType(ElevatedButton);
  await tester.tap(buttonWatchlistFinder);
  await tester.pumpAndSettle();
});
```

## Test Types Comparison

| Aspect | Unit Tests | Widget Tests | Integration Tests |
|--------|------------|-------------|------------------|
| **Function** | `test()` | `testWidgets()` | `testWidgets()` |
| **Parameter** | None | `(WidgetTester tester)` | `(WidgetTester tester)` |
| **Imports** | `flutter_test/flutter_test.dart` | `flutter_test/flutter_test.dart` | `integration_test/integration_test.dart` |
| **Purpose** | Business logic, use cases, models | UI components, widgets, pages | Complete app flows |
| **Scope** | Individual functions/classes | Widget behavior | Full application |
| **Dependencies** | Mock external dependencies | Mock BLoCs/providers | Real dependencies |
| **Speed** | Fast (milliseconds) | Medium (seconds) | Slow (minutes) |
| **Device Required** | No | No | Yes |
| **Setup** | Simple test setup | `makeTestableWidget()` helper | Real app initialization |
| **Command** | `sh test.sh` | `sh test.sh` | `sh integration_test.sh` |

## Examples by Category in This Project

**Unit Tests Found:**
- Use cases: `get_movies_test.dart`, `get_movie_detail_test.dart`
- Repositories: `movie_repository_impl_test.dart` 
- Data sources: `movie_remote_data_source_test.dart`, `movie_local_data_source_test.dart`
- Models: `movie_model_test.dart`, `movie_detail_model_test.dart`
- BLoCs: `movie_detail_bloc_test.dart`, `movie_list_bloc_test.dart`

**Widget Tests Found:**
- Widgets: `movie_card_list_test.dart`, `tv_series_card_list_test.dart`
- Pages: `movie_detail_page_test.dart`, `movie_page_test.dart`, `popular_movies_page_test.dart`

**Integration Tests Found:**
- Full app flows: `app_test.dart`

## Test Types Summary

| Test Type | Command | Speed | Device Required | Coverage | Purpose |
|-----------|---------|-------|-----------------|----------|---------|
| Unit Tests | `sh test.sh` | Fast | No | High | Component verification |
| Widget Tests | `sh test.sh` | Fast | No | Medium | UI component testing |
| Integration Tests | `sh integration_test.sh` | Slow | Yes | Low | End-to-end workflows |

This separation ensures fast development cycles while maintaining comprehensive test coverage across all application layers.

## Widget Testing: Understanding `pump()` vs `pumpAndSettle()`

When writing widget tests, you need to trigger frame updates to reflect changes in the UI. Flutter provides two main methods:

### `pump()` - Single Frame Update

**What it does:**
- Triggers exactly **one frame** of animation/rebuild
- Advances the test clock by the specified duration (default: Duration.zero)
- Returns immediately after one frame
- Useful for precise frame-by-frame control

**When to use:**
- Testing intermediate animation states
- When you need precise timing control
- Testing loading states that change quickly
- When you want to verify UI at specific moments

**Examples from this project:**

```dart
// From tv_series_detail_page_test.dart
await tester.pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));
await tester.pump(); // Single frame update to reflect initial state

// Try to scroll within the CustomScrollView to make seasons visible
final customScrollView = find.byType(CustomScrollView);
if (customScrollView.evaluate().isNotEmpty) {
  await tester.drag(customScrollView, const Offset(0, -100));
  await tester.pump(); // Single frame after scroll
}
```

### `pumpAndSettle()` - Wait Until Stable

**What it does:**
- Triggers frames repeatedly until there are **no more pending frames**
- Waits for all animations, futures, and timers to complete
- Continues pumping until the widget tree is stable
- Has a timeout (default: 10 minutes) to prevent infinite loops

**When to use:**
- After navigation (routes, page transitions)
- After user interactions (taps, form submissions)
- When loading data asynchronously
- After animations that should complete
- Most common choice for integration tests

**Examples from this project:**

```dart
// From integration_test/app_test.dart
app.main();
await tester.pumpAndSettle(); // Wait for app to fully load

final itemFinder = find.byKey(Key('card_item_key')).first;
await tester.tap(itemFinder);
await tester.pumpAndSettle(); // Wait for navigation and page load

await tester.tap(buttonWatchlistFinder);
await tester.pumpAndSettle(); // Wait for watchlist operation to complete
```

```dart
// From movie_detail_page_test.dart
await tester.tap(watchlistButton);
await tester.pump(); // Just one frame to trigger the tap

expect(find.byType(SnackBar), findsOneWidget);
expect(find.text(addedMessage), findsOneWidget);
```

### Key Differences Summary

| Aspect | `pump()` | `pumpAndSettle()` |
|--------|----------|-------------------|
| **Frames Processed** | Exactly 1 frame | Until no more frames pending |
| **Duration** | Advances by specified duration | Advances until stable |
| **Use Case** | Precise frame control | Wait for completion |
| **Performance** | Fast | Slower (waits for stability) |
| **Animations** | Shows intermediate states | Waits for animation end |
| **Async Operations** | Doesn't wait | Waits for completion |
| **Typical Usage** | Fine-grained testing | General widget testing |
| **Timeout** | None | 10 minutes default |

### Best Practices from This Project

**Use `pump()` when:**
```dart
// Testing immediate UI state changes
await tester.tap(button);
await tester.pump(); // Check immediate response

// Testing loading indicators
expect(find.byType(CircularProgressIndicator), findsOneWidget);
await tester.pump(); // Don't wait for loading to finish
```

**Use `pumpAndSettle()` when:**
```dart
// After app launch
app.main();
await tester.pumpAndSettle(); // Wait for full initialization

// After navigation
await tester.tap(navigationButton);
await tester.pumpAndSettle(); // Wait for route transition

// After async operations
await tester.tap(submitButton);
await tester.pumpAndSettle(); // Wait for API call and UI update
```

**Common Patterns in This Project:**
1. **Initial Setup**: `pumpWidget()` → `pumpAndSettle()`
2. **User Interactions**: `tap()` → `pumpAndSettle()`
3. **Scrolling**: `drag()` → `pump()` (for immediate feedback)
4. **Navigation**: `tap()` → `pumpAndSettle()` (wait for route)
5. **Form Submission**: `enterText()` → `tap()` → `pumpAndSettle()`

Understanding when to use each method is crucial for writing reliable widget and integration tests that accurately reflect real user interactions.

## Screenshot Testing Documentation

The Ditonton project includes comprehensive **automated screenshot testing** to capture visual states of all app pages. This provides visual regression testing and documentation of the UI across different screens.

### Screenshot Test Overview

**File Location**: `integration_test/screenshot_test.dart`  
**Driver File**: `integration_test/screenshot_driver.dart`  
**Output Directory**: `screenshots/`

### Test Architecture

The screenshot test system uses the **Integration Test framework** with a custom driver for automatic screenshot capture and storage:

```dart
// Custom screenshot function with Android platform support
Future<void> takeScreenshot(String screenshotName) async {
  if (Platform.isAndroid) {
    await binding.convertFlutterSurfaceToImage();
  }
  await binding.takeScreenshot(screenshotName);
}
```

### Test Coverage

The screenshot tests capture **14 different app screens** with comprehensive user flow coverage:

#### **Movies Section (5 Screenshots)**
1. **`movies_page`** - Main movies page with lists
2. **`movies_detail`** - Movie detail page after tapping first card
3. **`movies_popular`** - Popular movies list (via "See More")
4. **`movies_top_rated`** - Top rated movies list (via second "See More")
5. **`movies_search_page`** - Movie search results for "Harry"

#### **TV Series Section (7 Screenshots)**
6. **`tv_series_page`** - Main TV series page
7. **`tv_series_detail`** - TV series detail page
8. **`tv_series_airing_today`** - Airing today TV series list
9. **`tv_series_popular`** - Popular TV series list
10. **`tv_series_top_rated`** - Top rated TV series list
11. **`tv_series_search_page`** - TV series search results for "One Piece"
12. **`tv_series_episode`** - TV series episode page with season navigation

#### **App Features (2 Screenshots)**
13. **`watchlist_page`** - Watchlist page with added items
14. **`about_page`** - About page

### Complex Navigation Flows

Several tests demonstrate sophisticated user interaction patterns:

#### **Advanced Search Flow (TV Series Episode Test)**
```dart
// Navigate to TV series search
await tester.tap(find.byKey(Key('drawer_icon')));
await tester.tap(find.byKey(Key('menu_tv_series')));
await tester.tap(find.byIcon(Icons.search));

// Search for "One Piece" and wait for results
await tester.enterText(searchField, 'One Piece');
await tester.pump(const Duration(seconds: 2));

// Navigate to series detail and episodes
await tester.tap(find.byKey(Key('tv_series_card_item')).first);
await tester.tap(find.byKey(Key('season_button_toggle')));

// Scroll to reveal season cards and click first season
await tester.drag(customScrollView, const Offset(0, -600));
await tester.tap(find.byKey(Key('season_card_item')).first);
```

#### **Watchlist Integration Flow**
```dart
// Add movie to watchlist
final movieCard = find.byKey(Key('card_item_key')).first;
await tester.tap(movieCard);
await tester.tap(find.byKey(Key('watchlist_text')));
await tester.tap(find.byIcon(Icons.arrow_back));

// Add TV series to watchlist  
await tester.tap(find.byKey(Key('drawer_icon')));
await tester.tap(find.byKey(Key('menu_tv_series')));
final tvSeriesCard = find.byKey(Key('card_item_key')).first;
await tester.tap(tvSeriesCard);
await tester.tap(find.byKey(Key('watchlist_text')));

// Navigate to watchlist page to see added items
await tester.tap(find.byKey(Key('menu_watchlist')));
```

### Key Testing Techniques

#### **Drawer Navigation Pattern**
Most tests use consistent navigation through the app drawer:
```dart
await tester.tap(find.byKey(Key('drawer_icon')));
await tester.pumpAndSettle();
await tester.tap(find.byKey(Key('menu_tv_series')));
await tester.pumpAndSettle();
```

#### **Smart Button Selection**
Tests handle multiple "See More" buttons intelligently:
```dart
final seeMoreButtons = find.text('See More');
if (seeMoreButtons.evaluate().length >= 2) {
  await tester.tap(seeMoreButtons.at(1)); // Second button
}
```

#### **Search with Timing**
Search tests wait for API responses:
```dart
await tester.enterText(searchField, 'One Piece');
await tester.pumpAndSettle();
await tester.pump(const Duration(seconds: 2)); // Wait for results
```

#### **Advanced Scrolling**
Complex scrolling for nested content:
```dart
// Scroll within CustomScrollView to reveal season cards
final customScrollView = find.byType(CustomScrollView);
if (customScrollView.evaluate().isNotEmpty) {
  await tester.drag(customScrollView, const Offset(0, -600));
  await tester.pump();
}
```

### Screenshot Driver Implementation

The custom screenshot driver automatically saves images as PNG files:

```dart
return integrationDriver(
  onScreenshot: (String screenshotName, List<int> screenshotBytes, [args]) async {
    final Directory screenshotsDir = Directory('screenshots');
    
    if (!await screenshotsDir.exists()) {
      await screenshotsDir.create(recursive: true);
    }
    
    final File screenshot = File('screenshots/$screenshotName.png');
    await screenshot.writeAsBytes(screenshotBytes);
    
    return true;
  },
);
```

### Running Screenshot Tests

**Command:**
```bash
# Method 1: Direct execution (requires executable permission)
chmod +x test_screenshot.sh        # Make executable (run once)  
./test_screenshot.sh              # Execute directly (bash, zsh, fish)

# Method 2: Shell interpreter (works without executable permission)
sh test_screenshot.sh             # Works in all POSIX shells (bash, zsh, dash)
bash test_screenshot.sh           # Explicitly use bash interpreter
```

**Output:**
- All screenshots saved to `screenshots/` directory as PNG files
- Sequential numbering provides clear navigation flow documentation
- Named screenshots clearly indicate the captured screen state

### Benefits of Screenshot Testing

1. **Visual Regression Detection**: Automatically detect UI changes
2. **Documentation**: Visual reference of all app screens
3. **Quality Assurance**: Verify UI consistency across updates
4. **Design Review**: Easy visual comparison of app states
5. **Onboarding**: New developers can see complete app flow

### Screenshot Test Best Practices

- **Consistent Naming**: Sequential numbers with descriptive names
- **Complete Flows**: Tests cover entire user journeys, not just individual screens
- **Error Handling**: Tests include conditional logic for optional UI elements
- **Platform Support**: Android-specific screenshot handling implemented
- **Timing Awareness**: Proper delays for search results and animations

The screenshot testing system provides comprehensive visual coverage of the Ditonton app, ensuring UI consistency and serving as living documentation of the complete user experience.