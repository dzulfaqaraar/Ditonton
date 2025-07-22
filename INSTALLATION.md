# Installation Guide - Ditonton

This guide will help you set up the Ditonton Flutter project for development and testing.

## Prerequisites

### System Requirements
- **Flutter SDK**: `3.32.7` (stable channel)
- **Dart SDK**: `^3.8.1` 
- **Android Studio** or **VS Code** with Flutter extensions
- **Git** for version control

### Platform-Specific Requirements

#### Android Development
- **Java Development Kit (JDK)**: Version 17 (Zulu distribution recommended)
- **Android SDK**: API level 34 (compile), minimum API level 21
- **Android NDK**: Version 27.0.12077973
- **Android Emulator** or physical Android device

#### iOS Development (macOS only)
- **Xcode**: Latest version
- **iOS Simulator** or physical iOS device
- **CocoaPods**: For iOS dependency management

## Installation Steps

### 1. Clone the Repository

```bash
git clone <repository-url>
cd Ditonton
```

### 2. Install Flutter Dependencies

Run the following commands to install dependencies for all packages:

```bash
# Install main app dependencies
flutter pub get

# Install dependencies for all packages
cd packages/core && flutter pub get && flutter pub run build_runner build
cd ../movies && flutter pub get && flutter pub run build_runner build
cd ../tv_series && flutter pub get && flutter pub run build_runner build
cd ../search && flutter pub get && flutter pub run build_runner build
cd ../watchlist && flutter pub get && flutter pub run build_runner build
cd ../about && flutter pub get
cd ../..
```

### 3. Environment Configuration

#### 3.1 Create Environment File
Copy the example environment file and configure your API credentials:

```bash
cp .env.example .env
```

#### 3.2 Configure API Settings
Edit the `.env` file with your TMDB API credentials:

```env
# API Base URL
BASE_URL=https://api.themoviedb.org/3

# TMDB API Key (get from https://www.themoviedb.org/settings/api)
API_KEY=your_actual_api_key_here
```

**How to get TMDB API Key:**
1. Visit [The Movie Database (TMDB)](https://www.themoviedb.org/)
2. Create an account or sign in
3. Go to [API Settings](https://www.themoviedb.org/settings/api)
4. Request an API key
5. Copy your API key to the `.env` file

### 4. SSL Certificate Setup

#### 4.1 Certificate Purpose
The app uses SSL certificate pinning for secure communication with the TMDB API. The certificate file `certificates/certificates.pem` contains the certificate chain for `api.themoviedb.org`.

#### 4.2 Certificate Management
The current certificate is pre-configured, but if you need to update it:

1. **Extract certificate from the API URL:**
```bash
# Method 1: Using openssl
echo | openssl s_client -servername api.themoviedb.org -connect api.themoviedb.org:443 2>/dev/null | openssl x509 -text

# Method 2: Using browser
# Navigate to https://api.themoviedb.org/3 in browser
# Click lock icon → Certificate → Details → Export
```

2. **Save certificate:**
```bash
mkdir -p certificates
# Save the certificate content to certificates/certificates.pem
```

The certificate file should contain the complete certificate chain in PEM format.

### 5. Android Configuration

#### 5.1 Local Properties Setup
Create or update `android/local.properties`:

```properties
flutter.compileSdk=34
flutter.minSdk=21
flutter.targetSdk=34
flutter.ndkVersion=27.0.12077973
sdk.dir=/path/to/your/android/sdk
```

#### 5.2 Gradle Configuration
The project uses Kotlin Gradle scripts. Ensure your Android SDK is properly configured.

### 6. iOS Configuration (macOS only)

#### 6.1 Install CocoaPods Dependencies
```bash
cd ios
pod install
cd ..
```

## Running the Application

### Development Mode
```bash
flutter run
```

### Release Mode
```bash
flutter run --release
```

### Platform-Specific Runs
```bash
# Android
flutter run -d android

# iOS (macOS only)
flutter run -d ios
```

## Troubleshooting

### Common Issues

#### 1. API Key Issues
- Ensure your TMDB API key is valid and active
- Check that `.env` file exists and contains the correct API key
- Verify the API key has proper permissions

#### 2. Certificate Issues
- If you get SSL certificate errors, ensure `certificates/certificates.pem` is present
- The certificate may need updating if TMDB changes their SSL certificate

#### 3. Build Issues
```bash
# Clean build cache
flutter clean

# Re-install dependencies
flutter pub get

# Run build_runner for code generation
flutter pub run build_runner build --delete-conflicting-outputs
```

#### 4. Android Build Issues
- Ensure Java 17 is installed and configured
- Check Android SDK path in `local.properties`
- Update Android SDK tools if needed

#### 5. iOS Build Issues (macOS)
- Run `pod install` in the `ios` directory
- Check Xcode version compatibility
- Ensure iOS deployment target is compatible

### Environment Variables
The app expects these environment variables:
- `BASE_URL`: TMDB API base URL
- `API_KEY`: Your TMDB API key

### Package Dependencies
Key dependencies that may require special attention:
- `sqflite_sqlcipher`: Encrypted database storage
- `flutter_dotenv`: Environment variable management
- `http`: Network requests with SSL certificate pinning
- `flutter_bloc`: State management

## Development Workflow

1. **Make Changes**: Edit code in appropriate packages
2. **Run Tests**: Test affected packages
3. **Code Analysis**: Run `flutter analyze` and `dart format .`
4. **Build Verification**: Ensure builds work for target platforms
5. **Integration Testing**: Run end-to-end tests

For issues or questions, please refer to the project documentation or create an issue in the repository.