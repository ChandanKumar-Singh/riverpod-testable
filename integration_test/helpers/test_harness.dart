import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable/app/app.dart';
import 'package:testable/core/config/env.dart';
import 'package:testable/core/di/providers.dart';
import 'package:testable/core/network/dio/http_client.dart';
import 'package:testable/core/network/dio/models/api_response.dart';
import 'package:testable/core/observers/app_error_handler.dart';
import 'package:testable/core/services/local_storage_adapter.dart';
import 'package:testable/core/services/storage_adapter.dart';
import 'package:testable/core/utils/logger.dart';
import 'package:testable/features/auth/data/models/user_model.dart';
import 'package:testable/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:testable/features/user/data/models/user_profile_model.dart';
import 'package:testable/features/user/data/repositories/user_repository_impl.dart';
import 'package:testable/shared/connectivity/connectivity_watcher.dart';

import '../../test/helpers/test_helpers.dart';

class TestAppHarness {
  TestAppHarness({
    FakeAuthController? authController,
    FakeUserController? userController,
    LocalStorage? storage,
    Env? env,
    bool startAuthenticated = false,
  }) : authController = authController ?? FakeAuthController(),
       userController = userController ?? FakeUserController(),
       storage = storage ?? testLocaloStorage,
       env =
           env ??
           const Env(
             baseUrl: 'https://integration.test',
             enableLogging: false,
             isTest: true,
           ),
       _logger = AppLogger(enabled: false) {
    if (startAuthenticated && this.authController.sessionUser == null) {
      this.authController.sessionUser = FakeAuthController.defaultUser;
    }
  }

  final FakeAuthController authController;
  final FakeUserController userController;
  final LocalStorage storage;
  final Env env;
  final AppLogger _logger;

  Widget buildApp() {
    final container = ProviderContainer(
      overrides: [
        envProvider.overrideWithValue(env),
        loggerProvider.overrideWithValue(_logger),
        storageProvider.overrideWithValue(storage),
        connectivityProvider.overrideWith(
          (ref) => ConnectivityNotifier(enableMonitoring: false),
        ),
        httpClientProvider.overrideWith((ref) {
          final selectedEnv = ref.watch(envProvider);
          final logger = ref.watch(loggerProvider);
          return AppHttpClient(
            env: selectedEnv,
            logger: logger,
            dio: Dio(BaseOptions(baseUrl: selectedEnv.baseUrl)),
          );
        }),
        authRepositoryProvider.overrideWith(
          (ref) => FakeAuthRepository(ref, controller: authController),
        ),
        userRepoProvider.overrideWith(
          (ref) => FakeUserRepository(ref, controller: userController),
        ),
      ],
      observers: [RiverpodErrorObserver(_logger)],
    );
    return UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    );
  }

  List<Override> get _overrides => [
    envProvider.overrideWithValue(env),
    loggerProvider.overrideWithValue(_logger),
    storageProvider.overrideWithValue(storage),
    httpClientProvider.overrideWith((ref) {
      final selectedEnv = ref.watch(envProvider);
      final logger = ref.watch(loggerProvider);
      return AppHttpClient(
        env: selectedEnv,
        logger: logger,
        dio: Dio(BaseOptions(baseUrl: selectedEnv.baseUrl)),
      );
    }),
    connectivityProvider.overrideWith(
      (ref) => ConnectivityNotifier(enableMonitoring: false),
    ),
    authRepositoryProvider.overrideWith(
      (ref) => FakeAuthRepository(ref, controller: authController),
    ),
    userRepoProvider.overrideWith(
      (ref) => FakeUserRepository(ref, controller: userController),
    ),
  ];

  Future<void> setup() async {
    await dotenv.load(fileName: '.env.test');
  }
}

class FakeAuthController {
  FakeAuthController({
    this.sessionUser,
    UserModel? otpUser,
    this.failSendOtp = false,
    this.failVerifyOtp = false,
    this.failLogin = false,
    this.errorMessage = 'Authentication failed',
    this.otpContact = '9999999999',
    this.expectedOtp = '777777',
  }) : otpUser = otpUser ?? defaultUser;

  static final defaultUser = UserModel(
    id: 'user-1',
    name: 'Test User',
    email: 'test@example.com',
    token: 'test-token',
  );

  UserModel? sessionUser;
  UserModel otpUser;
  bool failSendOtp;
  bool failVerifyOtp;
  bool failLogin;
  String errorMessage;
  String otpContact;
  String expectedOtp;
}

class FakeAuthRepository extends AuthRepository {
  FakeAuthRepository(Ref ref, {required this.controller}) : super(ref);

  final FakeAuthController controller;

  @override
  Future<ApiResponse<(bool, Map<String, dynamic>)>> sendOtp(
    String contact,
  ) async {
    if (controller.failSendOtp) {
      return ApiResponse<(bool, Map<String, dynamic>)>.error(
        message: controller.errorMessage,
      );
    }
    return ApiResponse<(bool, Map<String, dynamic>)>.success(
      data: (true, {'contact': controller.otpContact}),
    );
  }

  @override
  Future<ApiResponse<UserModel?>> verifyOTP(String contact, String otp) async {
    if (controller.failVerifyOtp ||
        contact != controller.otpContact ||
        otp != controller.expectedOtp) {
      return const ApiResponse<UserModel?>.error(
        message: 'Invalid OTP provided',
      );
    }
    await saveSession(controller.otpUser, token: controller.otpUser.token);
    return ApiResponse<UserModel?>.success(data: controller.otpUser);
  }

  @override
  Future<ApiResponse<UserModel?>> login(String email, String password) async {
    if (controller.failLogin) {
      return ApiResponse<UserModel?>.error(message: controller.errorMessage);
    }
    await saveSession(controller.otpUser, token: controller.otpUser.token);
    return ApiResponse<UserModel?>.success(data: controller.otpUser);
  }

  @override
  Future<ApiResponse<bool>> logout() async {
    await clearSession();
    return const ApiResponse<bool>.success(data: true);
  }

  @override
  Future<UserModel?> loadSession() async {
    return controller.sessionUser;
  }

  @override
  Future<void> saveSession(UserModel user, {String? token}) async {
    controller.sessionUser = UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      token: token ?? user.token ?? controller.sessionUser?.token,
    );
  }

  @override
  Future<void> clearSession() async {
    controller.sessionUser = null;
  }

  @override
  Future<String?> getToken() async {
    return controller.sessionUser?.token;
  }
}

class FakeUserController {
  FakeUserController({UserProfileModel? profile, this.failLoad = false})
    : profile = profile ?? defaultProfile;

  static final defaultProfile = UserProfileModel(
    id: 'user-1',
    name: 'Test User',
    email: 'test@example.com',
    phone: '+1 555-0100',
  );

  UserProfileModel profile;
  bool failLoad;
}

class FakeUserRepository extends UserRepository {
  FakeUserRepository(Ref ref, {required this.controller}) : super(ref);

  final FakeUserController controller;

  @override
  Future<ApiResponse<UserProfileModel?>> getProfile() async {
    if (controller.failLoad) {
      return const ApiResponse<UserProfileModel?>.error(
        message: 'Failed to load profile',
      );
    }
    return ApiResponse<UserProfileModel?>.success(data: controller.profile);
  }

  @override
  Future<ApiResponse<UserProfileModel?>> updateProfile(
    Map<String, dynamic> updates,
  ) async {
    controller.profile = UserProfileModel(
      id: controller.profile.id,
      name: updates['name'] as String? ?? controller.profile.name,
      email: updates['email'] as String? ?? controller.profile.email,
      phone: updates['phone'] as String? ?? controller.profile.phone,
      avatar: updates['avatar'] as String? ?? controller.profile.avatar,
      createdAt: controller.profile.createdAt,
      updatedAt: DateTime.now(),
    );
    return ApiResponse<UserProfileModel?>.success(data: controller.profile);
  }
}
