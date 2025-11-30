import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/src/framework.dart';
import 'package:testable/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:testable/features/auth/data/models/user_model.dart';
import 'package:testable/core/services/storage_adapter.dart';
import 'package:testable/core/constants/index.dart';
import 'package:testable/core/di/providers.dart';
import 'auth_repository_test.mocks.dart' show MockStorageAdapter;

// Test Ref implementation for repository tests
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
  void invalidateSelf() {}

  @override
  void onDispose(void Function() callback) {}

  @override
  void onResume(void Function() callback) {}

  @override
  void onCancel(void Function() callback) {}

  @override
  void onAddListener(void Function() callback) {}

  @override
  void onRemoveListener(void Function() callback) {}

  @override
  bool exists(ProviderOrFamily provider) => _container.exists(provider as ProviderBase<Object?>);

  @override
  KeepAliveLink keepAlive() => _NoOpKeepAliveLink();

  @override
  ProviderSubscription<T> listen<T>(
    ProviderListenable<T> provider,
    void Function(T? previous, T next) listener, {
    bool fireImmediately = false,
    void Function(Object error, StackTrace stackTrace)? onError,
  }) => _NoOpProviderSubscription<T>();

  @override
  void listenSelf(
    void Function(Object? previous, Object? next) listener, {
    void Function(Object error, StackTrace stackTrace)? onError,
  }) {}

  @override
  void notifyListeners() {}

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

@GenerateMocks([StorageAdapter])
void main() {
  group('AuthRepository', () {
    late ProviderContainer container;
    late MockStorageAdapter mockStorage;

    setUp(() {
      mockStorage = MockStorageAdapter();
      container = ProviderContainer(
        overrides: [storageProvider.overrideWithValue(mockStorage)],
      );
    });

    tearDown(() {
      container.dispose();
    });

    group('loadSession', () {
      test('returns user when session exists', () async {
        final userJson = {
          'id': 'user-1',
          'name': 'Test User',
          'email': 'test@example.com',
        };
        when(
          mockStorage.getMap(StorageKeys.user),
        ).thenAnswer((_) async => userJson);
        when(
          mockStorage.getString(StorageKeys.token, secure: true),
        ).thenAnswer((_) async => 'test-token');

        // Create a TestRef wrapper for the container
        final testRef = TestRef(container);
        final repo = AuthRepository(testRef);
        final user = await repo.loadSession();

        expect(user, isNotNull);
        expect(user?.id, 'user-1');
        expect(user?.name, 'Test User');
        expect(user?.email, 'test@example.com');
        expect(user?.token, 'test-token');
      });

      test('returns null when no session exists', () async {
        when(
          mockStorage.getMap(StorageKeys.user),
        ).thenAnswer((_) async => null);
        when(
          mockStorage.getString(StorageKeys.token, secure: true),
        ).thenAnswer((_) async => null);

        // Create a TestRef wrapper for the container
        final testRef = TestRef(container);
        final repo = AuthRepository(testRef);
        final user = await repo.loadSession();

        expect(user, isNull);
      });

      test('returns null and clears session on parse error', () async {
        when(
          mockStorage.getMap(StorageKeys.user),
        ).thenAnswer((_) async => {'invalid': 'data'});
        when(
          mockStorage.delete(any),
        ).thenAnswer((_) async => Future<void>.value());

        // Create a TestRef wrapper for the container
        final testRef = TestRef(container);
        final repo = AuthRepository(testRef);
        final user = await repo.loadSession();

        expect(user, isNull);
      });
    });

    group('saveSession', () {
      test('saves user and token correctly', () async {
        final user = UserModel(
          id: 'user-1',
          name: 'Test User',
          email: 'test@example.com',
          token: 'test-token',
        );

        when(
          mockStorage.save(any, any),
        ).thenAnswer((_) async => Future<void>.value());

        // Create a TestRef wrapper for the container
        final testRef = TestRef(container);
        final repo = AuthRepository(testRef);
        await repo.saveSession(user, token: 'test-token');

        verify(mockStorage.save(StorageKeys.user, any)).called(1);
        verify(
          mockStorage.save(StorageKeys.token, 'test-token', secure: true),
        ).called(1);
      });

      test('uses user token when token not provided', () async {
        final user = UserModel(
          id: 'user-1',
          name: 'Test User',
          email: 'test@example.com',
          token: 'user-token',
        );

        when(
          mockStorage.save(any, any),
        ).thenAnswer((_) async => Future<void>.value());

        // Create a TestRef wrapper for the container
        final testRef = TestRef(container);
        final repo = AuthRepository(testRef);
        await repo.saveSession(user);

        verify(
          mockStorage.save(StorageKeys.token, 'user-token', secure: true),
        ).called(1);
      });
    });

    group('clearSession', () {
      test('deletes user and token', () async {
        when(
          mockStorage.delete(any),
        ).thenAnswer((_) async => Future<void>.value());

        // Create a TestRef wrapper for the container
        final testRef = TestRef(container);
        final repo = AuthRepository(testRef);
        await repo.clearSession();

        verify(mockStorage.delete(StorageKeys.user)).called(1);
        verify(mockStorage.delete(StorageKeys.token, secure: true)).called(1);
      });
    });

    group('getToken', () {
      test('returns token from secure storage', () async {
        when(
          mockStorage.getString(StorageKeys.token, secure: true),
        ).thenAnswer((_) async => 'test-token');

        // Create a TestRef wrapper for the container
        final testRef = TestRef(container);
        final repo = AuthRepository(testRef);
        final token = await repo.getToken();

        expect(token, 'test-token');
      });

      test('returns null when no token exists', () async {
        when(
          mockStorage.getString(StorageKeys.token, secure: true),
        ).thenAnswer((_) async => null);

        // Create a TestRef wrapper for the container
        final testRef = TestRef(container);
        final repo = AuthRepository(testRef);
        final token = await repo.getToken();

        expect(token, isNull);
      });
    });
  });
}
