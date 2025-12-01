// test/features/auth/presentation/auth_notifier_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:testable/features/auth/data/models/user_model.dart';
import 'package:testable/features/auth/data/providers/auth_provider.dart';
import 'package:testable/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:testable/core/network/dio/models/api_response.dart';
import 'package:testable/core/di/providers.dart';
import '../../../../helpers/test_helpers.dart';

import 'auth_notifier_test.mocks.dart';

@GenerateMocks([AuthRepository])
class FakeUserModel extends Fake implements UserModel {}

class FakeApiResponseUserModel extends Fake
    implements ApiResponse<UserModel?> {}

class FakeApiResponseBoolMap extends Fake
    implements ApiResponse<(bool, Map<String, dynamic>)> {}

void main() {
  late ProviderContainer container;
  late MockAuthRepository mockRepo;

  setUpAll(() {
    provideDummy<ApiResponse<UserModel?>>(
      const ApiResponse<UserModel?>.error(message: 'dummy'),
    );
    provideDummy<ApiResponse<(bool, Map<String, dynamic>)>>(
      const ApiResponse<(bool, Map<String, dynamic>)>.error(message: 'dummy'),
    );
    provideDummy<UserModel>(UserModel(id: '', name: '', email: '', token: ''));
  });

  setUp(() {
    mockRepo = MockAuthRepository();
    container = ProviderContainer(
      overrides: [
        envProvider.overrideWithValue(TestEnv()),
        storageProvider.overrideWithValue(testLocaloStorage),
        authProvider.overrideWith((ref) {
          return AuthNotifier(ref, repo: mockRepo);
        }),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  UserModel dummyUser() {
    return UserModel(
      id: 'user-1',
      name: 'Test User',
      email: 'test@example.com',
      token: 'test-token',
    );
  }

  ApiResponse<UserModel?> successUserResponse(UserModel user) {
    return ApiResponse<UserModel?>.success(data: user);
  }

  ApiResponse<UserModel?> failureUserResponse(String message) {
    return ApiResponse<UserModel?>.error(message: message);
  }

  ApiResponse<UserModel?> successUserResponseWithNullData() {
    return const ApiResponse<UserModel?>.success(data: null);
  }

  ApiResponse<(bool, Map<String, dynamic>)> successOtpResponse(String contact) {
    return ApiResponse<(bool, Map<String, dynamic>)>.success(
      data: (true, <String, dynamic>{'contact': contact}),
    );
  }

  ApiResponse<(bool, Map<String, dynamic>)> failureOtpResponse(String message) {
    return ApiResponse<(bool, Map<String, dynamic>)>.error(message: message);
  }

  ApiResponse<(bool, Map<String, dynamic>)> successOtpResponseWithFalse() {
    return const ApiResponse<(bool, Map<String, dynamic>)>.success(
      data: (false, <String, dynamic>{}),
    );
  }

  Future<void> pump() async {
    await Future<void>.delayed(Duration.zero);
  }

  group('AuthNotifier (Mockito)', () {
    test('initializes authenticated when session exists', () async {
      final user = dummyUser();
      when(mockRepo.loadSession()).thenAnswer((_) async => user);

      final initial = container.read(authProvider);
      expect(initial.status, AuthStatus.loading);

      await pump();

      final state = container.read(authProvider);
      expect(state.status, AuthStatus.authenticated);
      expect(state.user?.id, user.id);
    });

    test('initializes unauthenticated when no session', () async {
      when(mockRepo.loadSession()).thenAnswer((_) async => null);

      container.read(authProvider);
      await pump();

      final state = container.read(authProvider);
      expect(state.status, AuthStatus.unauthenticated);
      expect(state.user, isNull);
    });

    test('login success persists session and authenticates', () async {
      when(mockRepo.loadSession()).thenAnswer((_) async => null);

      final notifier = container.read(authProvider.notifier);
      final user = dummyUser();

      when(
        mockRepo.login('test@example.com', 'password'),
      ).thenAnswer((_) async => successUserResponse(user));
      when(
        mockRepo.saveSession(user, token: user.token),
      ).thenAnswer((_) async {});

      await notifier.login('test@example.com', 'password');

      final state = container.read(authProvider);
      expect(state.status, AuthStatus.authenticated);
      expect(state.user?.email, user.email);

      verify(mockRepo.login('test@example.com', 'password')).called(1);
      verify(mockRepo.saveSession(user, token: user.token)).called(1);
    });

    test('login failure sets unauthenticated and stores error', () async {
      when(mockRepo.loadSession()).thenAnswer((_) async => null);

      final notifier = container.read(authProvider.notifier);
      when(
        mockRepo.login('test@example.com', 'wrong'),
      ).thenAnswer((_) async => failureUserResponse('Invalid credentials'));

      await notifier.login('test@example.com', 'wrong');

      final state = container.read(authProvider);
      expect(state.status, AuthStatus.unauthenticated);
      expect(state.user, isNull);
      expect(state.error, 'Invalid credentials');
    });

    test('login handles repository exceptions', () async {
      when(mockRepo.loadSession()).thenAnswer((_) async => null);
      final notifier = container.read(authProvider.notifier);

      when(
        mockRepo.login('test@example.com', 'password'),
      ).thenThrow(Exception('Network error'));

      await notifier.login('test@example.com', 'password');

      final state = container.read(authProvider);
      expect(state.status, AuthStatus.unauthenticated);
      expect(state.error, 'Exception: Network error');
    });

    test('login handles null data with success response', () async {
      when(mockRepo.loadSession()).thenAnswer((_) async => null);
      final notifier = container.read(authProvider.notifier);

      when(
        mockRepo.login('test@example.com', 'password'),
      ).thenAnswer((_) async => successUserResponseWithNullData());

      await notifier.login('test@example.com', 'password');

      final state = container.read(authProvider);
      expect(state.status, AuthStatus.unauthenticated);
      expect(state.error, 'Login failed');
    });

    test('loginWithOtp success', () async {
      when(mockRepo.loadSession()).thenAnswer((_) async => null);

      final notifier = container.read(authProvider.notifier);
      final user = dummyUser();

      when(
        mockRepo.verifyOTP('9999999999', '123456'),
      ).thenAnswer((_) async => successUserResponse(user));
      when(
        mockRepo.saveSession(user, token: user.token),
      ).thenAnswer((_) async {});

      await notifier.loginWithOtp('9999999999', '123456');

      final state = container.read(authProvider);
      expect(state.status, AuthStatus.authenticated);
      expect(state.user?.id, user.id);

      verify(mockRepo.verifyOTP('9999999999', '123456')).called(1);
      verify(mockRepo.saveSession(user, token: user.token)).called(1);
    });

    test('loginWithOtp handles repository exceptions', () async {
      when(mockRepo.loadSession()).thenAnswer((_) async => null);
      final notifier = container.read(authProvider.notifier);

      when(
        mockRepo.verifyOTP('9999999999', '123456'),
      ).thenThrow(Exception('Network error'));

      await notifier.loginWithOtp('9999999999', '123456');

      final state = container.read(authProvider);
      expect(state.status, AuthStatus.unauthenticated);
      expect(state.error, 'Exception: Network error');
    });

    test('loginWithOtp handles null data with success response', () async {
      when(mockRepo.loadSession()).thenAnswer((_) async => null);
      final notifier = container.read(authProvider.notifier);

      when(
        mockRepo.verifyOTP('9999999999', '123456'),
      ).thenAnswer((_) async => successUserResponseWithNullData());

      await notifier.loginWithOtp('9999999999', '123456');

      final state = container.read(authProvider);
      expect(state.status, AuthStatus.unauthenticated);
      expect(state.error, 'OTP verification failed');
    });

    test('sendOtp success returns contact and resets to initial', () async {
      when(mockRepo.loadSession()).thenAnswer((_) async => null);

      final notifier = container.read(authProvider.notifier);
      when(
        mockRepo.sendOtp('9999999999'),
      ).thenAnswer((_) async => successOtpResponse('9999999999'));

      final contact = await notifier.sendOtp('9999999999');

      final state = container.read(authProvider);
      expect(contact, '9999999999');
      expect(state.status, AuthStatus.initial);

      verify(mockRepo.sendOtp('9999999999')).called(1);
    });

    test('sendOtp returns null on API failure', () async {
      when(mockRepo.loadSession()).thenAnswer((_) async => null);
      final notifier = container.read(authProvider.notifier);

      when(
        mockRepo.sendOtp('9999999999'),
      ).thenAnswer((_) async => failureOtpResponse('Failed'));

      final result = await notifier.sendOtp('9999999999');

      expect(result, isNull);
      final state = container.read(authProvider);
      expect(state.status, AuthStatus.unauthenticated);
      expect(state.error, 'Failed'); // Use actual error message from response
    });

    test('sendOtp returns null when success but false data', () async {
      when(mockRepo.loadSession()).thenAnswer((_) async => null);
      final notifier = container.read(authProvider.notifier);

      when(
        mockRepo.sendOtp('9999999999'),
      ).thenAnswer((_) async => successOtpResponseWithFalse());

      final result = await notifier.sendOtp('9999999999');

      expect(result, isNull);
      final state = container.read(authProvider);
      expect(state.status, AuthStatus.unauthenticated);
      expect(state.error, 'Failed to send OTP');
    });

    test('sendOtp handles repository exceptions - DEBUG VERSION', () async {
      when(mockRepo.loadSession()).thenAnswer((_) async => null);
      final notifier = container.read(authProvider.notifier);

      when(
        mockRepo.sendOtp('9999999999'),
      ).thenAnswer((_) async => throw Exception('Network error'));
      final result = await notifier.sendOtp('9999999999');
      final state = container.read(authProvider);
      expect(result, isNull);
      expect(state.status, AuthStatus.unauthenticated);
      expect(state.error, 'Exception: Network error');
    });

    test('logout handles repository exceptions gracefully', () async {
      when(mockRepo.loadSession()).thenAnswer((_) async => dummyUser());
      final notifier = container.read(authProvider.notifier);

      when(
        mockRepo.clearSession(),
      ).thenAnswer((_) async => throw Exception('Storage error'));

      await notifier.logout();
      final state = container.read(authProvider);
      expect(state.status, AuthStatus.unauthenticated);
      expect(state.user, isNull);
      // Implementation sets error on logout failure
      expect(state.error, 'Exception: Storage error');
      // expect(state.error, 'Exception: Storage error');

      verify(mockRepo.clearSession()).called(1);
    });

    test('state copyWith works correctly', () {
      const initialState = AuthState();
      final user = dummyUser();

      final withStatus = initialState.copyWith(
        status: AuthStatus.authenticated,
      );
      expect(withStatus.status, AuthStatus.authenticated);
      expect(withStatus.user, isNull);
      expect(withStatus.error, isNull);

      final withUser = initialState.copyWith(user: user);
      expect(withUser.user, user);
      expect(withUser.status, AuthStatus.initial);

      final withError = initialState.copyWith(error: 'Test error');
      expect(withError.error, 'Test error');
      expect(withError.status, AuthStatus.initial);

      const errorState = AuthState(error: 'Old error');
      final clearedErrorState = errorState.copyWith(error: null);
      expect(clearedErrorState.error, isNull);
    });

    test('initialization handles repository exceptions', () async {
      when(mockRepo.loadSession()).thenThrow(Exception('Storage unavailable'));

      container.read(authProvider);
      await pump();

      final state = container.read(authProvider);
      expect(state.status, AuthStatus.unauthenticated);
      expect(state.error, 'Exception: Storage unavailable');
    });
  });
}
