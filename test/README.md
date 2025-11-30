# Test Suite

This directory contains comprehensive tests for the entire application.

## Test Coverage

### Core Services ✅
- ✅ ApiService - API request handling, error handling, retry logic
- ✅ StorageAdapter - Local and secure storage operations
- ✅ NetworkInfo - Connectivity checking
- ✅ Logger - Logging functionality
- ✅ ErrorHandler - Error message extraction and classification

### Repositories ✅
- ✅ AuthRepository - Authentication operations
- ✅ UserRepository - User profile operations
- ✅ AppSettingsRepository - App settings operations

### Providers/Notifiers ✅
- ✅ AuthNotifier - Authentication state management
- ✅ UserProfileNotifier - User profile state management
- ✅ PaymentNotifier - Payment state management
- ✅ ThemeNotifier - Theme management
- ✅ LangNotifier - Language management

### Widgets ✅
- ✅ EmptyStateWidget - Empty state display
- ✅ LoadingWidget - Loading indicators
- ✅ ErrorWidget - Error display
- ✅ RetryWidget - Retry functionality
- ✅ ErrorBanner - Error banners

### Integration Tests ✅
- ✅ Auth Flow - Complete authentication flow
- ✅ User Flow - User profile operations

## Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/features/auth/data/providers/auth_notifier_test.dart

# Run tests in watch mode
flutter test --watch
```

## Test Structure

```
test/
├── helpers/              # Test utilities
├── core/                 # Core functionality tests
├── features/             # Feature tests
├── shared/               # Shared component tests
├── app/                  # App-level tests
└── integration/          # Integration tests
```

## Test Helpers

See `test/helpers/test_helpers.dart` for:
- MockStorageAdapter
- createTestContainer
- pump() helper
- waitFor() helper

## Documentation

See `test/TESTING_GUIDE.md` for comprehensive testing documentation.
