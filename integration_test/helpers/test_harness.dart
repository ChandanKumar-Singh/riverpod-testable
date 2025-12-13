import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable/app/app.dart';
import 'package:testable/core/config/env.dart';
import 'package:testable/core/constants/index.dart';
import 'package:testable/core/di/providers.dart';
import 'package:testable/core/network/dio/http_client.dart';
import 'package:testable/core/observers/app_error_handler.dart';
import 'package:testable/core/services/local_storage_adapter.dart';
import 'package:testable/core/utils/logger.dart';
import 'package:testable/features/auth/data/models/user_model.dart';
import 'package:testable/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:testable/shared/connectivity/connectivity_watcher.dart';

import '../../test/helpers/test_helpers.dart';
import 'TestAppHelper.dart';

class TestAppHarness {
  TestAppHarness({
    this.startAuthenticated = true,
    LocalStorage? storage,
    this.env,
    UserModel? preAuthenticatedUser,
  }) : storage = storage ?? testLocaloStorage,
       _logger = AppLogger(enabled: false),
       _preAuthenticatedUser = preAuthenticatedUser;

  static final defaultUser = UserModel(
    id: 'test-user-id',
    name: 'Test User',
    email: 'test@example.com',
    token: 'test-auth-token',
  );

  final bool startAuthenticated;
  final LocalStorage storage;
  Env? env;
  final AppLogger _logger;
  UserModel? _preAuthenticatedUser;

  Widget buildApp() {
    final connectivityNotifier = ConnectivityNotifier(enableMonitoring: false);
    final container = ProviderContainer(
      overrides: [
        envProvider.overrideWithValue(env ?? Env.current),
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
        connectivityProvider.overrideWith((ref) => connectivityNotifier),
        authRepositoryProvider.overrideWith((ref) => AuthRepository(ref)),
      ],
      observers: [RiverpodErrorObserver(_logger)],
    );

    return UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    );
  }

  Future<void> setup() async {
    await dotenv.load(fileName: '.env.test');
    env ??= Env.current;
    // 🔥 No previous session → normal behavior
    if (startAuthenticated) {
      await _setupPreAuthentication();
    } else {
      await _clearAuthentication();
    }
  }

  Future<void> _setupPreAuthentication() async {
    try {
      // 🔥 NEW: Attempt to restore previous session
      final restoredUser = await TestAppHelper.loadUserState();
      if (restoredUser != null) {
        print('🔄 Restoring test-authenticated user from temp session file');
        startAuthenticated ? _preAuthenticatedUser = restoredUser : null;
      }
      _preAuthenticatedUser ??= defaultUser;

      // Clear any existing session first
      await storage.delete(StorageKeys.user);
      await storage.delete(StorageKeys.token, secure: true);
      print('testing user is now ${_preAuthenticatedUser!.token}');

      // Save user data to storage
      await storage.save(StorageKeys.user, _preAuthenticatedUser!.toJson());

      // Save token securely
      if (_preAuthenticatedUser!.token != null &&
          _preAuthenticatedUser!.token!.isNotEmpty) {
        await storage.save(
          StorageKeys.token,
          _preAuthenticatedUser!.token,
          secure: true,
        );
      }

      // Verify the data was saved
      final savedUser = await storage.getMap(StorageKeys.user);
      final savedToken = await storage.getString(
        StorageKeys.token,
        secure: true,
      );

      _logger.i('Pre-authentication setup complete:');
      _logger.i('  User saved: ${savedUser != null}');
      _logger.i(
        '  Token saved: ${savedToken != null && savedToken.isNotEmpty}',
      );
    } catch (e) {
      _logger.e('Failed to setup pre-authentication', e: e);
      rethrow;
    }
  }

  Future<void> _clearAuthentication() async {
    try {
      await storage.delete(StorageKeys.user);
      await storage.delete(StorageKeys.token, secure: true);
      _logger.i('Authentication cleared for unauthenticated test');
    } catch (e) {
      _logger.e('Failed to clear authentication', e: e);
    }
  }

  /*   // Helper method to change authentication state during test
  Future<void> authenticateUser(UserModel? user) async {
    if (user != null) {
      await storage.save(StorageKeys.user, user.toJson());
      if (user.token != null && user.token!.isNotEmpty) {
        await storage.save(StorageKeys.token, user.token!, secure: true);
      }
    } else {
      await _clearAuthentication();
    }

    // Rebuild the app to reflect new auth state
    // In tests, you might need to pump the widget again
  }

  // Helper to get current auth state
  Future<bool> isAuthenticated() async {
    final user = await storage.getMap(StorageKeys.user);
    final token = await storage.getString(StorageKeys.token, secure: true);
    return user != null && user.isNotEmpty && token != null && token.isNotEmpty;
  }
 */
}
