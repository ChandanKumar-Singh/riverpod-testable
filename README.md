# 🚀 Testable Flutter App

> **Enterprise-grade, production-ready Flutter application** with clean architecture, comprehensive testing, CI/CD, and best practices.

[![CI/CD](https://github.com/yourusername/testable/workflows/CI/CD%20Pipeline/badge.svg)](https://github.com/yourusername/testable/actions)
[![Code Coverage](https://codecov.io/gh/yourusername/testable/branch/main/graph/badge.svg)](https://codecov.io/gh/yourusername/testable)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

## 📋 Table of Contents

- [Features](#-features)
- [Architecture](#-architecture)
- [Getting Started](#-getting-started)
- [Project Structure](#-project-structure)
- [Development](#-development)
- [Testing](#-testing)
- [Building](#-building)
- [Deployment](#-deployment)
- [Documentation](#-documentation)
- [Contributing](#-contributing)
- [License](#-license)

## ✨ Features

### Core Features
- ✅ **Authentication System** - Email/password and OTP-based login
- ✅ **User Management** - Profile management and user settings
- ✅ **Payment Integration** - Payment processing and history
- ✅ **Theme Management** - Light/Dark theme with system detection
- ✅ **Localization** - Multi-language support (English, Hindi)
- ✅ **Connectivity Monitoring** - Real-time network status detection
- ✅ **Secure Storage** - Encrypted storage for sensitive data
- ✅ **Error Handling** - Comprehensive error handling and reporting
- ✅ **Logging** - Structured logging system
- ✅ **Routing** - Auto-route with route guards and history tracking

### Technical Features
- ✅ **Clean Architecture** - Domain, Data, Presentation layers
- ✅ **Riverpod State Management** - Reactive state management
- ✅ **Dependency Injection** - Provider-based DI
- ✅ **Network Layer** - Dio-based HTTP client with interceptors
- ✅ **Code Generation** - Freezed, JSON serialization, Auto Route
- ✅ **Testing** - Unit, widget, and integration tests
- ✅ **CI/CD** - GitHub Actions pipeline
- ✅ **Code Quality** - Linting, formatting, and analysis
- ✅ **Documentation** - Comprehensive documentation

## 🏗️ Architecture

This project follows **Clean Architecture** principles with a feature-based folder structure:

```
lib/
├── app/                 # App-level configuration
│   ├── data/           # App data sources
│   ├── localization/   # Localization setup
│   └── router/         # Routing configuration
├── core/               # Core functionality
│   ├── config/         # Configuration
│   ├── constants/      # Constants
│   ├── di/             # Dependency injection
│   ├── errors/         # Error handling
│   ├── network/        # Network layer
│   ├── observers/      # App observers
│   ├── services/       # Core services
│   └── utils/          # Utilities
├── features/           # Feature modules
│   ├── auth/           # Authentication feature
│   ├── payment/        # Payment feature
│   └── user/           # User feature
└── shared/             # Shared resources
    ├── components/     # Shared components
    ├── connectivity/   # Connectivity monitoring
    ├── extensions/     # Extensions
    ├── localization/   # Localization
    ├── theme/          # Theme management
    └── widgets/        # Shared widgets
```

### Architecture Layers

1. **Presentation Layer** (`features/*/presentation/`)
   - UI components (screens, widgets)
   - State management (providers, notifiers)
   - View models

2. **Domain Layer** (`features/*/domain/`)
   - Business logic
   - Use cases
   - Entities
   - Repositories interfaces

3. **Data Layer** (`features/*/data/`)
   - Repository implementations
   - Data sources (API, local storage)
   - Models
   - Data mappers

4. **Core Layer** (`core/`)
   - Shared utilities
   - Network layer
   - Storage adapters
   - Error handling
   - Configuration

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK** 3.8.1 or higher
- **Dart SDK** 3.8.1 or higher
- **Node.js** 16+ (for server)
- **Android Studio** / **Xcode** (for mobile development)
- **Git** for version control

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/testable.git
   cd testable
   ```

2. **Run setup script**
   ```bash
   make setup
   # OR manually:
   cp .env.example .env
   flutter pub get
   flutter pub run build_runner build --delete-conflicting-outputs
   cd server && npm install
   ```

3. **Configure environment**
   - Edit `.env` file with your configuration
   - Update `BASE_URL` if needed

4. **Start the server**
   ```bash
   make server
   # OR:
   cd server && npm run dev
   ```

5. **Run the app**
   ```bash
   make run
   # OR:
   flutter run
   ```

### Quick Start with Makefile

```bash
# Install dependencies
make install

# Setup project
make setup

# Run tests
make test

# Run app
make run

# Build app
make build

# Format code
make format

# Analyze code
make analyze
```

## 📁 Project Structure

```
testable/
├── .github/              # GitHub Actions workflows
├── android/              # Android-specific files
├── ios/                  # iOS-specific files
├── lib/                  # Dart source code
│   ├── app/             # App configuration
│   ├── core/            # Core functionality
│   ├── features/        # Feature modules
│   └── shared/          # Shared resources
├── test/                 # Test files
├── server/               # Mock server
├── docs/                 # Documentation
├── assets/               # Assets (images, fonts, etc.)
├── .env.example          # Environment variables example
├── .gitignore            # Git ignore rules
├── analysis_options.yaml # Lint rules
├── pubspec.yaml          # Dart dependencies
├── Makefile              # Make commands
├── docker-compose.yml    # Docker configuration
└── README.md             # This file
```

## 💻 Development

### Code Generation

Generate code for models, routes, and serialization:

```bash
make generate
# OR:
flutter pub run build_runner build --delete-conflicting-outputs
```

Watch mode for automatic code generation:

```bash
make generate-watch
# OR:
flutter pub run build_runner watch --delete-conflicting-outputs
```

### Code Formatting

Format code:

```bash
make format
# OR:
dart format .
```

Check formatting:

```bash
make format-check
```

### Code Analysis

Analyze code:

```bash
make analyze
# OR:
flutter analyze
```

### Running the App

Development mode:

```bash
make run-dev
# OR:
flutter run --dart-define=ENV=dev
```

Production mode:

```bash
make run-prod
# OR:
flutter run --dart-define=ENV=prod --release
```

## 🧪 Testing

### Run Tests

```bash
make test
# OR:
flutter test
```

### Run Tests with Coverage

```bash
make test-coverage
# OR:
flutter test --coverage
```

View coverage report:

```bash
# Install lcov if not installed
brew install lcov  # macOS
# OR
sudo apt-get install lcov  # Linux

# Generate HTML report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Test Structure

- **Unit Tests** (`test/core/`, `test/features/`)
- **Widget Tests** (`test/shared/widgets/`)
- **Integration Tests** (`test/integration/`)

## 🏗️ Building

### Android

Build APK:

```bash
make build-android
# OR:
flutter build apk --release
```

Build App Bundle:

```bash
flutter build appbundle --release
```

### iOS

Build iOS app:

```bash
make build-ios
# OR:
flutter build ios --release --no-codesign
```

### Web

Build web app:

```bash
make build-web
# OR:
flutter build web
```

## 🚢 Deployment

### Android

1. Build release APK:
   ```bash
   flutter build apk --release
   ```

2. Sign the APK (if needed)
3. Upload to Google Play Console

### iOS

1. Build iOS app:
   ```bash
   flutter build ios --release
   ```

2. Archive in Xcode
3. Upload to App Store Connect

### Environment Variables

Set environment variables for production:

```bash
# Android
flutter build apk --release --dart-define=ENV=prod --dart-define=BASE_URL=https://api.production.com

# iOS
flutter build ios --release --dart-define=ENV=prod --dart-define=BASE_URL=https://api.production.com
```

## 📚 Documentation

### API Documentation

API documentation is available in the `docs/` directory:

- [Architecture Documentation](docs/ARCHITECTURE.md)
- [API Documentation](docs/API.md)
- [Testing Documentation](docs/TESTING.md)

### Code Documentation

Generate code documentation:

```bash
make docs
# OR:
dart doc
```

## 🤝 Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details.

### Contribution Workflow

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style

- Follow [Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- Run `make format` before committing
- Run `make analyze` to check for issues
- Write tests for new features

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Riverpod for state management
- Auto Route for routing
- All contributors and maintainers

## 📞 Support

For support, email support@example.com or open an issue in the repository.

## 🔗 Links

- [Flutter Documentation](https://flutter.dev/docs)
- [Riverpod Documentation](https://riverpod.dev/)
- [Auto Route Documentation](https://autoroute.vercel.app/)

---

**Made with ❤️ using Flutter**
