# Setup Guide

This guide will help you set up the Testable Flutter App development environment.

## Prerequisites

### Required

- **Flutter SDK** 3.8.1 or higher
  - Download from [flutter.dev](https://flutter.dev/docs/get-started/install)
  - Verify installation: `flutter doctor`

- **Dart SDK** 3.8.1 or higher
  - Included with Flutter SDK

- **Git** for version control
  - Download from [git-scm.com](https://git-scm.com/downloads)

### Optional

- **Android Studio** for Android development
  - Download from [developer.android.com](https://developer.android.com/studio)
  - Install Flutter and Dart plugins

- **Xcode** for iOS development (macOS only)
  - Download from Mac App Store
  - Install Xcode Command Line Tools: `xcode-select --install`

- **Node.js** 16+ for server
  - Download from [nodejs.org](https://nodejs.org/)
  - Verify installation: `node --version`

- **Docker** for containerized development
  - Download from [docker.com](https://www.docker.com/get-started)

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/testable.git
cd testable
```

### 2. Run Setup Script

**Using Makefile (Recommended)**:
```bash
make setup
```

**Using Setup Script**:
```bash
chmod +x scripts/setup.sh
./scripts/setup.sh
```

**Manual Setup**:
```bash
# Copy environment file
cp .env.example .env

# Install Flutter dependencies
flutter pub get

# Generate code
flutter pub run build_runner build --delete-conflicting-outputs

# Install server dependencies
cd server && npm install && cd ..
```

### 3. Configure Environment

Edit `.env` file with your configuration:

```env
BASE_URL=http://localhost:3000
ENV=dev
ENABLE_LOGGING=true
```

### 4. Verify Installation

```bash
# Check Flutter installation
flutter doctor

# Run tests
flutter test

# Analyze code
flutter analyze
```

## Development Setup

### IDE Setup

#### VS Code

1. Install Flutter extension
2. Install Dart extension
3. Install Flutter Intl extension (optional)
4. Configure settings:

```json
{
  "dart.flutterSdkPath": "/path/to/flutter",
  "dart.lineLength": 80,
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": true
  }
}
```

#### Android Studio

1. Install Flutter plugin
2. Install Dart plugin
3. Configure Flutter SDK path
4. Enable format on save

### Code Generation

Generate code for models, routes, and serialization:

```bash
# Generate once
make generate

# Watch mode (auto-generate on file changes)
make generate-watch
```

### Running the App

**Development Mode**:
```bash
make run-dev
# OR
flutter run --dart-define=ENV=dev
```

**Production Mode**:
```bash
make run-prod
# OR
flutter run --dart-define=ENV=prod --release
```

### Starting the Server

```bash
# Using Makefile
make server

# Manual
cd server && npm run dev
```

## Docker Setup

### Using Docker Compose

```bash
# Start services
make docker-up
# OR
docker-compose up -d

# Stop services
make docker-down
# OR
docker-compose down
```

### Building Docker Image

```bash
cd server
docker build -t testable-server .
docker run -p 3000:3000 testable-server
```

## Testing Setup

### Running Tests

```bash
# Run all tests
make test

# Run tests with coverage
make test-coverage

# Run specific test file
flutter test test/features/auth/auth_test.dart
```

### Test Coverage

```bash
# Generate coverage report
flutter test --coverage

# View coverage (requires lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## Troubleshooting

### Common Issues

#### Flutter Doctor Issues

```bash
# Fix Flutter doctor issues
flutter doctor --android-licenses
flutter doctor -v
```

#### Code Generation Issues

```bash
# Clean and regenerate
flutter clean
flutter pub get
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

#### Dependency Issues

```bash
# Clean pub cache
flutter pub cache repair

# Update dependencies
flutter pub upgrade
```

#### Server Issues

```bash
# Clear node modules
cd server
rm -rf node_modules
npm install
```

### Platform-Specific Issues

#### Android

- **Gradle Issues**: Update Gradle wrapper
- **SDK Issues**: Install required SDKs via Android Studio
- **Emulator Issues**: Create new AVD or use physical device

#### iOS

- **CocoaPods Issues**: Run `pod install` in `ios/` directory
- **Signing Issues**: Configure signing in Xcode
- **Simulator Issues**: Reset simulator or use physical device

## Next Steps

1. Read [Architecture Documentation](ARCHITECTURE.md)
2. Review [Contributing Guidelines](../CONTRIBUTING.md)
3. Check [API Documentation](API.md)
4. Explore the codebase

## Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Documentation](https://dart.dev/guides)
- [Riverpod Documentation](https://riverpod.dev/)
- [Auto Route Documentation](https://autoroute.vercel.app/)

---

**Need Help?** Open an issue or contact the maintainers.

