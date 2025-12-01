import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable/core/services/local_storage_adapter.dart';
import 'package:testable/features/auth/data/providers/auth_provider.dart';
import 'package:testable/features/auth/data/models/user_model.dart';
import 'package:testable/core/network/dio/models/api_response.dart';
import 'package:testable/core/di/providers.dart';
import '../helpers/test_helpers.dart';
import 'auth_flow_test.mocks.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:testable/features/auth/data/repositories/auth_repository_impl.dart';

@GenerateMocks([AuthRepository])
void main() {
  group('Auth Flow Integration Tests', () {
    late ProviderContainer container;
    late MockAuthRepository mockRepo;
    late LocalStorage mockStorage;

    setUp(() {
      mockRepo = MockAuthRepository();
      mockStorage = LocalStorage(
        sharedPreferencesAdapter: MockSharedPreferencesStorageAdapter(),
        secureStorageAdapter: MockSecureStorageAdapter(),
      );
      container = ProviderContainer(
        overrides: [
          storageProvider.overrideWithValue(mockStorage),
          envProvider.overrideWithValue(TestEnv()),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('complete login flow', () async {
      // Setup: No existing session
      when(mockRepo.loadSession()).thenAnswer((_) async => null);

      // Setup: Successful login
      final user = UserModel(
        id: 'user-1',
        name: 'Test User',
        email: 'test@example.com',
        token: 'test-token',
      );

      when(
        mockRepo.login('test@example.com', 'password'),
      ).thenAnswer((_) async => ApiResponse<UserModel?>.success(data: user));
      when(
        mockRepo.saveSession(user, token: 'test-token'),
      ).thenAnswer((_) async {});

      // Initialize auth provider
      container.read(authProvider);
      await Future.delayed(const Duration(milliseconds: 10));

      // Perform login
      final notifier = container.read(authProvider.notifier);
      await notifier.login('test@example.com', 'password');

      // Verify state
      final state = container.read(authProvider);
      expect(state.status, AuthStatus.authenticated);
      expect(state.user?.id, 'user-1');
      expect(state.user?.email, 'test@example.com');
      expect(state.error, isNull);

      // Verify repository calls
      verify(mockRepo.login('test@example.com', 'password')).called(1);
      verify(mockRepo.saveSession(user, token: 'test-token')).called(1);
    });

    test('login failure flow', () async {
      // Setup: No existing session
      when(mockRepo.loadSession()).thenAnswer((_) async => null);

      // Setup: Failed login
      when(mockRepo.login('test@example.com', 'wrong')).thenAnswer(
        (_) async =>
            const ApiResponse<UserModel?>.error(message: 'Invalid credentials'),
      );

      // Initialize auth provider
      container.read(authProvider);
      await Future.delayed(const Duration(milliseconds: 10));

      // Perform login
      final notifier = container.read(authProvider.notifier);
      await notifier.login('test@example.com', 'wrong');

      // Verify state
      final state = container.read(authProvider);
      expect(state.status, AuthStatus.unauthenticated);
      expect(state.user, isNull);
      expect(state.error, 'Invalid credentials');

      // Verify no session was saved
      verifyNever(mockRepo.saveSession(any, token: anyNamed('token')));
    });

    test('logout flow', () async {
      // Setup: Existing session
      final user = UserModel(
        id: 'user-1',
        name: 'Test User',
        email: 'test@example.com',
        token: 'test-token',
      );

      when(mockRepo.loadSession()).thenAnswer((_) async => user);
      when(mockRepo.clearSession()).thenAnswer((_) async {});

      // Initialize auth provider
      container.read(authProvider);
      await Future.delayed(const Duration(milliseconds: 10));

      // Verify authenticated state
      var state = container.read(authProvider);
      expect(state.status, AuthStatus.authenticated);

      // Perform logout
      final notifier = container.read(authProvider.notifier);
      await notifier.logout();

      // Verify state
      state = container.read(authProvider);
      expect(state.status, AuthStatus.unauthenticated);
      expect(state.user, isNull);

      // Verify session was cleared
      verify(mockRepo.clearSession()).called(1);
    });

    test('OTP login flow', () async {
      // Setup: No existing session
      when(mockRepo.loadSession()).thenAnswer((_) async => null);

      // Setup: Successful OTP send
      when(mockRepo.sendOtp('9999999999')).thenAnswer(
        (_) async => ApiResponse<(bool, Map<String, dynamic>)>.success(
          data: (true, {'contact': '9999999999'}),
        ),
      );

      // Setup: Successful OTP verification
      final user = UserModel(
        id: 'user-1',
        name: 'Test User',
        email: 'test@example.com',
        token: 'test-token',
      );

      when(
        mockRepo.verifyOTP('9999999999', '123456'),
      ).thenAnswer((_) async => ApiResponse<UserModel?>.success(data: user));
      when(
        mockRepo.saveSession(user, token: 'test-token'),
      ).thenAnswer((_) async {});

      // Initialize auth provider
      container.read(authProvider);
      await Future.delayed(const Duration(milliseconds: 10));

      // Send OTP
      final notifier = container.read(authProvider.notifier);
      final contact = await notifier.sendOtp('9999999999');

      expect(contact, '9999999999');
      verify(mockRepo.sendOtp('9999999999')).called(1);

      // Verify OTP
      await notifier.loginWithOtp('9999999999', '123456');

      // Verify state
      final state = container.read(authProvider);
      expect(state.status, AuthStatus.authenticated);
      expect(state.user?.id, 'user-1');

      // Verify repository calls
      verify(mockRepo.verifyOTP('9999999999', '123456')).called(1);
      verify(mockRepo.saveSession(user, token: 'test-token')).called(1);
    });

    test('session persistence flow', () async {
      // Setup: Existing session
      final user = UserModel(
        id: 'user-1',
        name: 'Test User',
        email: 'test@example.com',
        token: 'test-token',
      );

      when(mockRepo.loadSession()).thenAnswer((_) async => user);

      // Initialize auth provider
      container.read(authProvider);
      await Future.delayed(const Duration(milliseconds: 10));

      // Verify state is restored
      final state = container.read(authProvider);
      expect(state.status, AuthStatus.authenticated);
      expect(state.user?.id, 'user-1');
      expect(state.user?.name, 'Test User');
    });
  });
}
