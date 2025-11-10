# Test Suite Documentation

## Overview

This test suite includes comprehensive tests for the Flutter testable app, covering unit tests, widget tests, and integration tests.

## Test Structure

```
test/
├── core/                          # Core functionality tests
│   ├── network/                   # Network layer tests
│   ├── services/                  # Service tests
│   └── utils/                     # Utility tests
├── features/                      # Feature tests
│   ├── auth/                      # Authentication tests
│   ├── user/                      # User feature tests
│   └── payment/                   # Payment feature tests
├── shared/                        # Shared component tests
│   └── widgets/                   # Widget tests
├── integration/                   # Integration tests
└── app/                           # App-level tests
```

## Running Tests

### Run all tests:
```bash
flutter test
```

### Run specific test file:
```bash
flutter test test/features/auth/data/providers/auth_provider_test.dart
```

### Run tests with coverage:
```bash
flutter test --coverage
```

### Run tests in watch mode:
```bash
flutter test --watch
```

## Test Coverage

### Unit Tests
- ✅ Auth provider state management
- ✅ User profile state management
- ✅ Payment state management
- ✅ API response handling
- ✅ Error handling
- ✅ Storage adapter interface

### Widget Tests
- ✅ Loading widgets
- ✅ Empty state widgets
- ✅ Error widgets
- ✅ Retry widgets
- ✅ Error banners
- ✅ Login screen

### Integration Tests
- ✅ Auth flow (placeholder)
- ✅ User flow (placeholder)
- ✅ Payment flow (placeholder)

## Test Files

### Core Tests
1. **error_handler_test.dart** - Tests for error handling utility
2. **api_response_test.dart** - Tests for API response models
3. **storage_adapter_test.dart** - Tests for storage adapter

### Feature Tests
1. **auth_provider_test.dart** - Auth state and provider tests
2. **auth_repository_test.dart** - Auth repository tests
3. **user_provider_test.dart** - User profile provider tests
4. **payment_provider_test.dart** - Payment provider tests

### Widget Tests
1. **loading_widget_test.dart** - Loading widget tests
2. **empty_state_widget_test.dart** - Empty state widget tests
3. **retry_widget_test.dart** - Retry widget tests
4. **error_banner_test.dart** - Error banner tests
5. **login_screen_test.dart** - Login screen tests

### Integration Tests
1. **auth_flow_test.dart** - Auth flow integration tests

## Writing New Tests

### Unit Test Example:
```dart
test('should update state correctly', () {
  const state = MyState();
  final updated = state.copyWith(status: Status.loaded);
  expect(updated.status, Status.loaded);
});
```

### Widget Test Example:
```dart
testWidgets('should display widget', (tester) async {
  await tester.pumpWidget(MyWidget());
  expect(find.byType(MyWidget), findsOneWidget);
});
```

## Test Best Practices

1. **Isolation**: Each test should be independent
2. **Naming**: Use descriptive test names
3. **Arrange-Act-Assert**: Follow AAA pattern
4. **Mocking**: Use mocks for external dependencies
5. **Coverage**: Aim for high test coverage
6. **Speed**: Keep tests fast
7. **Clarity**: Write clear, readable tests

## Mocking

For mocking, use the `mockito` package:
```dart
@GenerateMocks([MyClass])
void main() {
  // Tests here
}
```

## Continuous Integration

Tests should be run in CI/CD pipeline:
```yaml
- run: flutter test
- run: flutter test --coverage
```

## Coverage Goals

- **Unit Tests**: 80%+ coverage
- **Widget Tests**: 70%+ coverage
- **Integration Tests**: 50%+ coverage

## Notes

- Some tests are placeholders and need implementation
- Mock setup required for full integration tests
- Test environment setup needed for some tests
- Update tests as features evolve


