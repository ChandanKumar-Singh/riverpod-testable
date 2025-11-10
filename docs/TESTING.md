# Testing Guide

This guide covers testing strategies, best practices, and examples for the Testable Flutter App.

## Testing Strategy

### Test Pyramid

```
        /\
       /  \
      / E2E \          Few, slow, expensive
     /--------\
    /          \
   / Integration \     Some, medium speed
  /----------------\
 /                  \
/   Unit & Widget    \  Many, fast, cheap
/----------------------\
```

### Test Types

1. **Unit Tests** - Test individual functions, classes, and methods
2. **Widget Tests** - Test UI components in isolation
3. **Integration Tests** - Test complete user flows
4. **E2E Tests** - Test entire application flows

## Unit Tests

### Location

Unit tests are located in `test/core/` and `test/features/`.

### Example

```dart
// test/features/auth/auth_repository_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:testable/features/auth/data/repositories/auth_repository_impl.dart';

void main() {
  group('AuthRepository', () {
    late AuthRepository repository;
    late MockHttpClient mockClient;
    late MockStorage mockStorage;

    setUp(() {
      mockClient = MockHttpClient();
      mockStorage = MockStorage();
      repository = AuthRepository(
        client: mockClient,
        storage: mockStorage,
      );
    });

    test('should return user when login is successful', () async {
      // Arrange
      when(mockClient.post(any, any))
          .thenAnswer((_) async => MockResponse(
                data: {'user': {'id': '1', 'name': 'Test User'}},
                statusCode: 200,
              ));

      // Act
      final result = await repository.login('email', 'password');

      // Assert
      expect(result.isSuccess, true);
      expect(result.data, isNotNull);
      expect(result.data?.name, 'Test User');
    });

    test('should return error when login fails', () async {
      // Arrange
      when(mockClient.post(any, any))
          .thenThrow(Exception('Network error'));

      // Act
      final result = await repository.login('email', 'password');

      // Assert
      expect(result.isSuccess, false);
      expect(result.error, isNotNull);
    });
  });
}
```

### Best Practices

- **Arrange-Act-Assert** pattern
- **Descriptive test names**
- **One assertion per test** (when possible)
- **Mock external dependencies**
- **Test edge cases**
- **Test error scenarios**

## Widget Tests

### Location

Widget tests are located in `test/shared/widgets/`.

### Example

```dart
// test/shared/widgets/error_display_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:testable/shared/widgets/error_display.dart';

void main() {
  testWidgets('ErrorDisplay shows error message', (WidgetTester tester) async {
    // Arrange
    const errorMessage = 'Test error message';

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ErrorDisplay(message: errorMessage),
        ),
      ),
    );

    // Assert
    expect(find.text(errorMessage), findsOneWidget);
    expect(find.byIcon(Icons.error), findsOneWidget);
  });

  testWidgets('ErrorDisplay shows retry button when onRetry provided', (WidgetTester tester) async {
    // Arrange
    var retryCalled = false;

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ErrorDisplay(
            message: 'Error',
            onRetry: () => retryCalled = true,
          ),
        ),
      ),
    );

    // Assert
    expect(find.text('Retry'), findsOneWidget);

    // Tap retry button
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(retryCalled, true);
  });
}
```

### Best Practices

- **Test widget behavior**, not implementation
- **Test user interactions**
- **Test different states**
- **Use `pumpAndSettle()`** for animations
- **Test accessibility**

## Integration Tests

### Location

Integration tests are located in `test/integration/`.

### Example

```dart
// test/integration/auth_flow_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:testable/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Flow', () {
    testWidgets('user can login successfully', (WidgetTester tester) async {
      // Arrange
      app.main();
      await tester.pumpAndSettle();

      // Act
      await tester.enterText(find.byKey(Key('email_field')), 'test@example.com');
      await tester.enterText(find.byKey(Key('password_field')), 'password123');
      await tester.tap(find.byKey(Key('login_button')));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Welcome'), findsOneWidget);
    });
  });
}
```

### Best Practices

- **Test complete user flows**
- **Test critical paths**
- **Test error scenarios**
- **Use realistic data**
- **Test on real devices**

## Test Utilities

### Mock Classes

```dart
// test/helpers/mocks.dart
import 'package:mockito/annotations.dart';
import 'package:testable/core/network/dio/http_client.dart';
import 'package:testable/core/services/storage_adapter.dart';

@GenerateMocks([AppHttpClient, StorageAdapter])
void main() {}
```

### Test Helpers

```dart
// test/helpers/test_helpers.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

ProviderContainer createContainer({
  List<Override> overrides = const [],
}) {
  return ProviderContainer(
    overrides: overrides,
  );
}
```

## Running Tests

### Run All Tests

```bash
make test
# OR
flutter test
```

### Run Tests with Coverage

```bash
make test-coverage
# OR
flutter test --coverage
```

### Run Specific Test File

```bash
flutter test test/features/auth/auth_test.dart
```

### Run Tests in Watch Mode

```bash
flutter test --watch
```

## Test Coverage

### Generate Coverage Report

```bash
flutter test --coverage
```

### View Coverage Report

```bash
# Install lcov
brew install lcov  # macOS
sudo apt-get install lcov  # Linux

# Generate HTML report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Coverage Goals

- **Unit Tests**: >80% coverage
- **Widget Tests**: >70% coverage
- **Integration Tests**: Critical paths covered

## Best Practices

### 1. Test Structure

- Use `group()` to organize related tests
- Use `setUp()` and `tearDown()` for common setup
- Use descriptive test names

### 2. Test Data

- Use factories for test data
- Use realistic data
- Test edge cases

### 3. Mocking

- Mock external dependencies
- Mock network requests
- Mock storage operations

### 4. Assertions

- Use specific assertions
- Test behavior, not implementation
- Test error scenarios

### 5. Performance

- Keep tests fast
- Use `setUp()` efficiently
- Avoid unnecessary `pumpAndSettle()`

## Continuous Integration

### GitHub Actions

Tests run automatically on:
- Push to main/develop
- Pull requests
- Scheduled runs

### Test Matrix

- Flutter stable
- Flutter beta (optional)
- Multiple platforms (Android, iOS, Web)

## Additional Resources

- [Flutter Testing Documentation](https://flutter.dev/docs/testing)
- [Mockito Documentation](https://pub.dev/packages/mockito)
- [Integration Testing](https://flutter.dev/docs/testing/integration-tests)

---

**Happy Testing! 🧪**

