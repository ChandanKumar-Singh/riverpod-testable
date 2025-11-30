import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:auto_route/auto_route.dart';
import 'package:riverpod/src/framework.dart';
import 'package:testable/app/router/route_guard.dart';
import 'package:testable/features/auth/data/providers/auth_provider.dart';
import 'package:testable/app/router/app_router.dart';
import 'route_guard_test.mocks.dart';

// Test Ref implementation that wraps a ProviderContainer
// This is a minimal implementation for testing route guards
class TestRef implements Ref {
  TestRef(this._container);
  final ProviderContainer _container;

  @override
  T read<T>(ProviderListenable<T> provider) => _container.read(provider);

  @override
  T watch<T>(ProviderListenable<T> provider) => _container.read(provider);

  @override
  T refresh<T>(ProviderListenable<T> provider) {
    _container.invalidate(provider as ProviderOrFamily);
    return _container.read(provider);
  }

  @override
  void invalidate(ProviderOrFamily provider) => _container.invalidate(provider);

  @override
  void invalidateSelf() {
    // Not applicable for container-based ref
  }

  @override
  void onDispose(void Function() callback) {
    // Not applicable for container-based ref
  }

  @override
  void onResume(void Function() callback) {
    // Not applicable for container-based ref
  }

  @override
  void onCancel(void Function() callback) {
    // Not applicable for container-based ref
  }

  @override
  void onAddListener(void Function() callback) {
    // Not applicable for container-based ref
  }

  @override
  void onRemoveListener(void Function() callback) {
    // Not applicable for container-based ref
  }

  @override
  bool exists(ProviderOrFamily provider) => _container.exists(provider as ProviderBase<Object?>);

  @override
  KeepAliveLink keepAlive() {
    // Return a no-op KeepAliveLink
    return _NoOpKeepAliveLink();
  }

  @override
  ProviderSubscription<T> listen<T>(
    ProviderListenable<T> provider,
    void Function(T? previous, T next) listener, {
    bool fireImmediately = false,
    void Function(Object error, StackTrace stackTrace)? onError,
  }) {
    // Return a no-op subscription
    return _NoOpProviderSubscription<T>();
  }

  @override
  void listenSelf(
    void Function(Object? previous, Object? next) listener, {
    void Function(Object error, StackTrace stackTrace)? onError,
  }) {
    // Not applicable for container-based ref
  }

  @override
  void notifyListeners() {
    // Not applicable for container-based ref
  }

  @override
  ProviderContainer get container => _container;
}

// No-op implementations for testing
class _NoOpKeepAliveLink implements KeepAliveLink {
  @override
  void close() {}
}

class _NoOpProviderSubscription<T> implements ProviderSubscription<T> {
  @override
  void close() {}

  @override
  T read() => throw UnimplementedError('read not implemented in test subscription');

  @override
  bool get closed => false;

  @override
  Node get source => throw UnimplementedError();

  
  // Note: source getter type mismatch is acceptable for test purposes
  // The actual implementation won't be called in these tests
}

@GenerateMocks([NavigationResolver, StackRouter])
void main() {
  group('AuthGuard', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('allows navigation when authenticated', () {
      // Set authenticated state
      container.read(authProvider.notifier).state = const AuthState(
        status: AuthStatus.authenticated,
        user: null,
      );

      // Create a Ref wrapper for the container
      final ref = TestRef(container);
      final guard = AuthGuard(ref);
      final mockResolver = MockNavigationResolver();
      final mockRouter = MockStackRouter();

      guard.onNavigation(mockResolver, mockRouter);

      // Should call next() to allow navigation
      verify(mockResolver.next()).called(1);
      verifyNever(mockRouter.replace(any));
    });

    test('redirects to login when not authenticated', () {
      // Set unauthenticated state
      container.read(authProvider.notifier).state = const AuthState(
        status: AuthStatus.unauthenticated,
      );

      // Create a Ref wrapper for the container
      final ref = TestRef(container);
      final guard = AuthGuard(ref);
      final mockResolver = MockNavigationResolver();
      final mockRouter = MockStackRouter();

      guard.onNavigation(mockResolver, mockRouter);

      // Should redirect to login
      verify(mockRouter.replace(const LoginScreenRoute())).called(1);
      verifyNever(mockResolver.next());
    });
  });

  group('PublicRouteGuard', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('redirects to home when already authenticated', () {
      // Set authenticated state
      container.read(authProvider.notifier).state = const AuthState(
        status: AuthStatus.authenticated,
        user: null,
      );

      // Create a Ref wrapper for the container
      final ref = TestRef(container);
      final guard = PublicRouteGuard(ref);
      final mockResolver = MockNavigationResolver();
      final mockRouter = MockStackRouter();

      guard.onNavigation(mockResolver, mockRouter);

      // Should redirect to home
      verify(mockRouter.replace(const HomeScreenRoute())).called(1);
      verifyNever(mockResolver.next());
    });

    test('allows navigation when not authenticated', () {
      // Set unauthenticated state
      container.read(authProvider.notifier).state = const AuthState(
        status: AuthStatus.unauthenticated,
      );

      // Create a Ref wrapper for the container
      final ref = TestRef(container);
      final guard = PublicRouteGuard(ref);
      final mockResolver = MockNavigationResolver();
      final mockRouter = MockStackRouter();

      guard.onNavigation(mockResolver, mockRouter);

      // Should allow navigation
      verify(mockResolver.next()).called(1);
      verifyNever(mockRouter.replace(any));
    });
  });
}
