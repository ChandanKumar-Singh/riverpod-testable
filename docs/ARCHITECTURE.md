# Architecture Documentation

## Overview

This project follows **Clean Architecture** principles with a feature-based folder structure. The architecture is designed to be scalable, testable, and maintainable.

## Architecture Layers

### 1. Presentation Layer

**Location**: `lib/features/*/presentation/`

**Responsibility**: UI components, state management, user interactions

**Components**:
- **Screens**: Full-page UI components
- **Widgets**: Reusable UI components
- **Providers**: Riverpod providers for state management
- **Notifiers**: StateNotifier implementations

**Example**:
```dart
// lib/features/auth/presentation/screens/login_screen.dart
class LoginScreen extends ConsumerStatefulWidget {
  // UI implementation
}
```

### 2. Domain Layer

**Location**: `lib/features/*/domain/`

**Responsibility**: Business logic, use cases, entities

**Components**:
- **Entities**: Business objects
- **Use Cases**: Business logic operations
- **Repository Interfaces**: Abstract repository definitions

**Example**:
```dart
// lib/features/auth/domain/entities/user.dart
class User {
  final String id;
  final String name;
  final String email;
}
```

### 3. Data Layer

**Location**: `lib/features/*/data/`

**Responsibility**: Data sources, repository implementations, data models

**Components**:
- **Repositories**: Repository implementations
- **Data Sources**: API and local data sources
- **Models**: Data transfer objects (DTOs)
- **Mappers**: Data transformation logic

**Example**:
```dart
// lib/features/auth/data/repositories/auth_repository_impl.dart
class AuthRepository extends ApiService {
  Future<ApiResponse<UserModel?>> login(String email, String password) {
    // Implementation
  }
}
```

### 4. Core Layer

**Location**: `lib/core/`

**Responsibility**: Shared utilities, infrastructure, common functionality

**Components**:
- **Network**: HTTP client, API service
- **Storage**: Local storage adapters
- **Services**: Core services (logging, error handling)
- **Utils**: Utility functions
- **Constants**: App-wide constants
- **Configuration**: Environment configuration

## State Management

### Riverpod

We use **Riverpod** for state management:

- **StateNotifierProvider**: For complex state management
- **Provider**: For simple values and dependencies
- **FutureProvider**: For async data
- **StreamProvider**: For streams

### Example

```dart
// Provider definition
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref),
);

// Usage in UI
final authState = ref.watch(authProvider);
```

## Dependency Injection

### Provider-Based DI

We use Riverpod providers for dependency injection:

```dart
// Provider definition
final httpClientProvider = Provider<AppHttpClient>((ref) {
  final logger = ref.watch(loggerProvider);
  final env = ref.watch(envProvider);
  return AppHttpClient(logger: logger, env: env);
});

// Usage
final client = ref.read(httpClientProvider);
```

## Network Layer

### HTTP Client

**Location**: `lib/core/network/dio/http_client.dart`

**Features**:
- Token injection
- Request/response logging
- Error handling
- Retry logic
- Timeout handling

### API Service

**Location**: `lib/core/services/api_service.dart`

**Features**:
- Unified request method
- Response mapping
- Error handling
- Retry logic
- Token refresh

## Storage Layer

### Storage Adapter

**Location**: `lib/core/services/storage_adapter.dart`

**Features**:
- Secure storage for sensitive data
- SharedPreferences for general data
- Abstract interface for easy testing
- Encryption support

## Routing

### Auto Route

**Location**: `lib/app/router/app_router.dart`

**Features**:
- Code generation
- Type-safe routing
- Route guards
- Route history tracking
- Deep linking support

### Route Guards

**Location**: `lib/app/router/route_guard.dart`

**Features**:
- Authentication guards
- Public route guards
- Permission guards

## Error Handling

### Error Hierarchy

```
AppError
├── NetworkError
│   ├── ConnectionError
│   ├── TimeoutError
│   └── HttpError
├── StorageError
├── ValidationError
└── UnknownError
```

### Error Handler

**Location**: `lib/core/observers/app_error_handler.dart`

**Features**:
- Global error handling
- Error logging
- Error reporting
- User-friendly error messages

## Testing Strategy

### Unit Tests

**Location**: `test/core/`, `test/features/`

**Coverage**:
- Business logic
- Repository implementations
- Utility functions
- State management

### Widget Tests

**Location**: `test/shared/widgets/`

**Coverage**:
- UI components
- Widget behavior
- User interactions

### Integration Tests

**Location**: `test/integration/`

**Coverage**:
- Feature flows
- User journeys
- End-to-end scenarios

## Code Generation

### Build Runner

We use `build_runner` for code generation:

- **Freezed**: Immutable classes, unions, code generation
- **JSON Serializable**: JSON serialization
- **Auto Route**: Route generation
- **Retrofit**: API client generation

### Generating Code

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Best Practices

### 1. Separation of Concerns

- Keep layers independent
- Use interfaces for abstraction
- Avoid direct dependencies between layers

### 2. Single Responsibility

- Each class should have one responsibility
- Keep functions focused and small
- Avoid god classes

### 3. Dependency Inversion

- Depend on abstractions, not implementations
- Use interfaces for dependencies
- Inject dependencies through constructors

### 4. Testability

- Write testable code
- Use dependency injection
- Mock external dependencies
- Write comprehensive tests

### 5. Code Organization

- Follow feature-based structure
- Keep related code together
- Use meaningful names
- Document complex logic

## Diagram

```
┌─────────────────────────────────────────────────────────┐
│                     Presentation Layer                   │
│  (Screens, Widgets, Providers, State Management)        │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│                      Domain Layer                        │
│        (Entities, Use Cases, Repository Interfaces)      │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│                       Data Layer                         │
│   (Repositories, Data Sources, Models, Mappers)         │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│                       Core Layer                         │
│  (Network, Storage, Services, Utils, Configuration)     │
└─────────────────────────────────────────────────────────┘
```

## Further Reading

- [Clean Architecture by Robert C. Martin](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Riverpod Documentation](https://riverpod.dev/)
- [Flutter Best Practices](https://flutter.dev/docs/development/data-and-backend/state-mgmt/options)
- [Testing in Flutter](https://flutter.dev/docs/testing)

---

**Last Updated**: 2024-01-01

