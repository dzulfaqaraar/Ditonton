# DITONTON

[![Flutter CI/CD](https://github.com/dzulfaqaraar/Ditonton/actions/workflows/ci.yml/badge.svg)](https://github.com/dzulfaqaraar/Ditonton/actions/workflows/ci.yml)
[![Codemagic build status](https://api.codemagic.io/apps/687fd23d97393fa71f43b9af/687fd23d97393fa71f43b9ae/status_badge.svg)](https://codemagic.io/app/687fd23d97393fa71f43b9af/687fd23d97393fa71f43b9ae/latest_build)

Submission Project for Dicoding Course

## Project Overview

This is "Ditonton" - a Flutter movie and TV series catalog application built with Clean Architecture principles. It's a multi-package project that consumes The Movie Database (TMDB) API to display movies and TV series information with watchlist functionality.

## Development Commands

### Essential Flutter Commands
- `flutter run` - Run the app in development mode with hot reload
- `flutter run --release` - Run the app in release mode  
- `flutter build apk` - Build Android APK
- `flutter build ios` - Build iOS app (requires macOS and Xcode)
- `flutter clean` - Clean build cache and generated files
- `flutter pub get` - Install dependencies from pubspec.yaml

### Testing Commands
- `flutter test` - Run tests for the main app
- `cd packages/core && flutter test` - Run tests for core package
- `cd packages/movies && flutter test` - Run tests for movies package
- `cd packages/tv_series && flutter test` - Run tests for TV series package
- `cd packages/search && flutter test` - Run tests for search package  
- `cd packages/watchlist && flutter test` - Run tests for watchlist package

#### Test from Root Directory
- `flutter test packages/core/` - Test core package from root
- `flutter test packages/movies/` - Test movies package from root
- `flutter test packages/tv_series/` - Test TV series package from root
- `flutter test packages/search/` - Test search package from root
- `flutter test packages/watchlist/` - Test watchlist package from root

#### Integration Tests using `flutter test` (Modern Approach)
- `flutter test integration_test/` - Run all integration tests (requires device/emulator)
- `flutter test integration_test/app_test.dart` - Run specific integration test file
- `flutter devices` - Check available devices for testing
- `flutter test integration_test/ -d android` - Run on Android device/emulator
- `flutter test integration_test/ -d web-server` - Run on web
- `flutter test integration_test/ --coverage` - Run with coverage report

#### Integration Tests using `flutter drive` (Legacy Approach)
- `flutter devices` - Check available devices for testing
- `flutter drive --driver=integration_test/driver.dart --target=integration_test/app_test.dart -d emulator-5554` - Run integration tests with flutter drive on specific emulator

**What is Flutter Drive:**

Flutter Drive is the traditional integration testing framework that uses a client-server architecture. It runs the app on a device/emulator and controls it from a separate driver process.

**Key Differences between `flutter drive` and `flutter test integration_test/`:**

| Aspect | `flutter drive` | `flutter test integration_test/` |
|--------|-----------------|-----------------------------------|
| **Architecture** | Client-server (driver controls remote app) | Single process (test runs in same isolate as app) |
| **Performance** | Slower due to network communication | Faster execution |
| **Setup** | Requires separate driver file | Uses IntegrationTestWidgetsFlutterBinding |
| **Debugging** | More complex debugging | Better debugging support |
| **Screenshots** | Built-in screenshot support | Limited screenshot capabilities |
| **Platform Support** | Supports all platforms including web | Limited web support |
| **Test Results** | JSON output with detailed metrics | Standard test output |
| **Resource Usage** | Higher memory and CPU usage | More efficient resource usage |

**When to use `flutter drive`:**
- Need screenshots or video recording of tests
- Testing on web platforms
- Require detailed performance metrics
- Legacy projects already using flutter_driver

**When to use `flutter test integration_test/`:**
- Modern Flutter projects (recommended approach)
- Faster test execution needed
- Better IDE integration required
- Simpler setup and maintenance

**Prerequisites for Integration Tests:**
- Device connected or emulator running
- App will be launched automatically during test execution
- Tests run end-to-end scenarios on actual app interface

### Code Analysis
- `flutter analyze` - Run static code analysis
- `dart format .` - Format Dart code according to style guidelines

### Dependencies Management
- `flutter pub upgrade` - Update dependencies to latest compatible versions
- `flutter pub outdated` - Check for outdated dependencies

## Project Architecture

### Multi-Package Architecture
The project is organized into feature-based packages:

- **`packages/core`** - Shared domain entities, data models, utilities, network layer, and database
- **`packages/movies`** - Movie-related features (detail, popular, top-rated, recommendations)
- **`packages/tv_series`** - TV series features (detail, episodes, popular, airing today)
- **`packages/search`** - Search functionality for movies and TV series
- **`packages/watchlist`** - Watchlist management across movies and TV series
- **`packages/about`** - About page module

### Clean Architecture Implementation
Each feature package follows Clean Architecture with:

- **Domain Layer**: Use cases, entities, repository interfaces
- **Data Layer**: Repository implementations, data sources (remote/local), models
- **Presentation Layer**: BLoC pattern for state management, pages, and widgets

### Key Architecture Patterns

#### State Management
- **BLoC Pattern**: Uses `flutter_bloc` for state management
- **Dependency Injection**: Uses `get_it` for service locator pattern
- **Repository Pattern**: Abstracts data sources through repository interfaces

#### Data Sources
- **Remote**: TMDB API integration with SSL certificate pinning
- **Local**: SQLite database with `sqflite_sqlcipher` for encrypted storage
- **Caching**: Implements caching strategy for network requests

#### Navigation
- Route-based navigation with centralized route management in `lib/main.dart`
- Routes defined in `packages/core/lib/utils/routes.dart`

### Environment Configuration
- **Environment Variables**: Uses `.env` file for API configuration
- **SSL Pinning**: Certificate-based security in `certificates/certificates.pem`
- **Flavors**: Supports multiple build environments (develop, production)

### Key Dependencies
- **State Management**: `flutter_bloc`, `provider`
- **Network**: `http`, custom SSL client configuration
- **Database**: `sqflite_sqlcipher` for encrypted local storage
- **Functional Programming**: `dartz` for Either type and functional patterns
- **Testing**: `mockito`, `bloc_test` for comprehensive testing
- **UI**: `cached_network_image`, `flutter_rating_bar`, `google_fonts`

### Database Schema
Local SQLite database stores:
- Watchlist items (movies and TV series)
- Cached data for offline functionality
- User preferences and app state

### API Integration
- **Base URL**: The Movie Database (TMDB) API v3
- **Authentication**: API key-based authentication
- **SSL Security**: Certificate pinning for secure communications
- **Error Handling**: Comprehensive failure handling with custom exception types

### Testing Strategy
- **Unit Tests**: For use cases, repositories, and data sources
- **Widget Tests**: For UI components and pages
- **BLoC Tests**: For state management logic using `bloc_test`
- **Integration Tests**: End-to-end testing in `integration_test/`

### Main App Structure
- **`lib/main.dart`** - App entry point with BLoC providers and routing
- **`lib/home_page.dart`** - Main navigation hub with drawer menu
- **`lib/injection.dart`** - Dependency injection container setup

When working with this codebase:
1. Each feature is isolated in its own package
2. Use BLoC pattern for any new state management
3. Follow Clean Architecture layers when adding features
4. Run tests for affected packages after making changes
5. The app supports both movies and TV series with shared watchlist functionality