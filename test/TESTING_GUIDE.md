# Comprehensive Testing Guide

This document provides a complete guide to testing in this Flutter application. The project is structured to be fully testable at all levels.

## Table of Contents

1. [Testing Philosophy](#testing-philosophy)
2. [Test Structure](#test-structure)
3. [Test Types](#test-types)
4. [Running Tests](#running-tests)
5. [Writing Tests](#writing-tests)
6. [Test Helpers](#test-helpers)
7. [Mocking](#mocking)
8. [Best Practices](#best-practices)

## Testing Philosophy

This project follows a **test-first approach** with comprehensive coverage at all levels:

- **Unit Tests**: Test individual functions, classes, and methods in isolation
- **Widget Tests**: Test UI components and their interactions
- **Integration Tests**: Test complete user flows and feature interactions
- **Repository Tests**: Test data layer with mocked dependencies
- **Provider Tests**: Test state management logic

## Test Structure

```
test/
├── helpers/              # Test utilities and helpers
│   └── test_helpers.dart
├── core/                 # Core functionality tests
│   ├── network/
│   ├── services/
│   ├── utils/
│   └── observers/
├── features/             # Feature-specific tests
│   ├── auth/
│   ├── user/
│   └── payment/
├── shared/               # Shared component tests
│   ├── widgets/
│   ├── theme/
│   └── localization/
├── app/                  # App-level tests
│   └── router/
└── integration/          # Integration tests
```

## Test Types

### 1. Unit Tests

Unit tests verify individual components in isolation.

**Example: Testing a utility function**
```dart
test('ErrorHandler returns correct message for 401', () {
  final dioException = DioException(
    requestOptions: RequestOptions(path: '/test'),
    response: Response(statusCode: 401),
    type: DioExceptionType.badResponse,
  );
  
  final message = ErrorHandler.getErrorMessage(dioException);
  expect(message, contains('Unauthorized'));
});
```

### 2. Widget Tests

Widget tests verify UI components render correctly and handle user interactions.

**Example: Testing a widget**
```dart
testWidgets('LoadingWidget displays message', (WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: LoadingWidget(message: 'Loading...'),
      ),
    ),
  );
  
  expect(find.text('Loading...'), findsOneWidget);
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
});
```

### 3. Provider/State Tests

Provider tests verify state management logic using Riverpod.

**Example: Testing a provider**
```dart
test('AuthNotifier login success', () async {
  final container = createTestContainer();
  final notifier = container.read(authProvider.notifier);
  
  await notifier.login('test@example.com', 'password');
  
  final state = container.read(authProvider);
  expect(state.status, AuthStatus.authenticated);
});
```

### 4. Repository Tests

Repository tests verify data layer operations with mocked dependencies.

**Example: Testing a repository**
```dart
test('AuthRepository saves session correctly', () async {
  final mockStorage = MockStorageAdapter();
  final repo = AuthRepository(container.read);
  
  final user = UserModel(id: '1', name: 'Test');
  await repo.saveSession(user);
  
  verify(mockStorage.save(StorageKeys.user, any)).called(1);
});
```

### 5. Integration Tests

Integration tests verify complete user flows.

**Example: Testing complete auth flow**
```dart
test('complete login flow', () async {
  // Setup
  when(mockRepo.loadSession()).thenAnswer((_) async => null);
  
  // Execute
  await notifier.login('test@example.com', 'password');
  
  // Verify
  expect(state.status, AuthStatus.authenticated);
  verify(mockRepo.saveSession(any)).called(1);
});
```

## Running Tests

### Run All Tests
```bash
flutter test
```

### Run Specific Test File
```bash
flutter test test/features/auth/data/providers/auth_notifier_test.dart
```

### Run Tests with Coverage
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

### Run Tests in Watch Mode
```bash
flutter test --watch
```

### Run Integration Tests
```bash
flutter test integration_test/
```

## Writing Tests

### Test Structure

Every test file should follow this structure:

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ClassName', () {
    late ClassName instance;
    
    setUp(() {
      // Initialize test dependencies
      instance = ClassName();
    });
    
    tearDown(() {
      // Clean up after each test
    });
    
    test('should do something', () {
      // Arrange
      // Act
      // Assert
    });
    
    group('subgroup', () {
      test('should do something else', () {
        // Test implementation
      });
    });
  });
}
```

### Using Test Helpers

The project includes test helpers in `test/helpers/test_helpers.dart`:

```dart
import '../../helpers/test_helpers.dart';

// Create test container with overrides
final container = createTestContainer(
  storage: mockStorage,
  overrides: [/* provider overrides */],
);

// Wait for async operations
await pump();

// Wait for specific duration
await waitFor(Duration(seconds: 1));
```

### Mocking with Mockito

Generate mocks using `@GenerateMocks`:

```dart
@GenerateMocks([AuthRepository, StorageAdapter])
import 'test_file.mocks.dart';

void main() {
  late MockAuthRepository mockRepo;
  
  setUp(() {
    mockRepo = MockAuthRepository();
  });
  
  test('test with mock', () {
    when(mockRepo.login(any, any))
        .thenAnswer((_) async => successResponse);
    
    // Test implementation
    verify(mockRepo.login('email', 'password')).called(1);
  });
}
```

## Test Helpers

### MockStorageAdapter

A mock storage adapter for testing:

```dart
final mockStorage = MockStorageAdapter();
mockStorage.setValue('key', 'value');
expect(await mockStorage.getString('key'), 'value');
```

### createTestContainer

Creates a ProviderContainer with test overrides:

```dart
final container = createTestContainer(
  storage: mockStorage,
  overrides: [
    authProvider.overrideWith((ref) => MockAuthNotifier()),
  ],
);
```

## Mocking

### Mocking Repositories

```dart
@GenerateMocks([AuthRepository])
void main() {
  late MockAuthRepository mockRepo;
  
  setUp(() {
    mockRepo = MockAuthRepository();
    when(mockRepo.login(any, any))
        .thenAnswer((_) async => ApiResponse.success(data: user));
  });
}
```

### Mocking Storage

```dart
final mockStorage = MockStorageAdapter();
when(mockStorage.getString(any))
    .thenAnswer((_) async => 'stored_value');
```

### Mocking HTTP Client

```dart
@GenerateMocks([AppHttpClient])
void main() {
  late MockAppHttpClient mockClient;
  
  setUp(() {
    mockClient = MockAppHttpClient();
    when(mockClient.request(any))
        .thenAnswer((_) async => Response(data: {'key': 'value'}));
  });
}
```

## Best Practices

### 1. Test Isolation

Each test should be independent and not rely on other tests:

```dart
setUp(() {
  // Fresh setup for each test
  mockRepo = MockAuthRepository();
});

tearDown(() {
  // Clean up after each test
  container.dispose();
});
```

### 2. Arrange-Act-Assert Pattern

Structure tests clearly:

```dart
test('should login successfully', () async {
  // Arrange
  when(mockRepo.login(any, any))
      .thenAnswer((_) async => successResponse);
  
  // Act
  await notifier.login('email', 'password');
  
  // Assert
  expect(state.status, AuthStatus.authenticated);
  verify(mockRepo.login('email', 'password')).called(1);
});
```

### 3. Test Edge Cases

Test both success and failure scenarios:

```dart
test('handles login success', () { /* ... */ });
test('handles login failure', () { /* ... */ });
test('handles network error', () { /* ... */ });
test('handles null response', () { /* ... */ });
```

### 4. Use Descriptive Test Names

Test names should clearly describe what they test:

```dart
// Good
test('login sets authenticated state when credentials are valid', () { });

// Bad
test('login test', () { });
```

### 5. Group Related Tests

Use `group` to organize related tests:

```dart
group('AuthNotifier', () {
  group('login', () {
    test('success case', () { });
    test('failure case', () { });
  });
  
  group('logout', () {
    test('clears session', () { });
  });
});
```

### 6. Mock External Dependencies

Always mock external dependencies (APIs, storage, etc.):

```dart
// Good - Mocked
when(mockRepo.login(any, any))
    .thenAnswer((_) async => successResponse);

// Bad - Real dependency
final repo = AuthRepository(container.read);
```

### 7. Test State Transitions

Verify state changes correctly:

```dart
test('login transitions through states correctly', () async {
  // Initial state
  expect(state.status, AuthStatus.initial);
  
  // Loading state
  final future = notifier.login('email', 'password');
  expect(state.status, AuthStatus.loading);
  
  // Success state
  await future;
  expect(state.status, AuthStatus.authenticated);
});
```

## Coverage Goals

Aim for:
- **Unit Tests**: 80%+ coverage
- **Widget Tests**: All reusable widgets tested
- **Integration Tests**: All critical user flows tested
- **Repository Tests**: All data operations tested

## Continuous Integration

Tests should run automatically on:
- Every pull request
- Every commit to main branch
- Before deployment

## Troubleshooting

### Tests Failing Due to Async Operations

Use `pump()` helper or `Future.delayed`:

```dart
await notifier.login('email', 'password');
await pump(); // Wait for async operations
expect(state.status, AuthStatus.authenticated);
```

### Provider Not Found Errors

Ensure you're using `createTestContainer` with proper overrides:

```dart
final container = createTestContainer(
  overrides: [
    storageProvider.overrideWithValue(mockStorage),
  ],
);
```

### Mock Not Working

Ensure you've:
1. Generated mocks: `flutter pub run build_runner build`
2. Imported mocks: `import 'test_file.mocks.dart';`
3. Set up mocks in `setUp()`: `when(mock.method()).thenAnswer(...)`

## Additional Resources

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Riverpod Testing Guide](https://riverpod.dev/docs/concepts/testing)
- [Mockito Documentation](https://pub.dev/packages/mockito)

---

**Remember**: Good tests are an investment in code quality and maintainability. Write tests that are clear, maintainable, and provide confidence in your code.

