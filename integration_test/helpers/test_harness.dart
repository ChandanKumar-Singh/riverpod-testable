import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable/app/app.dart';
import 'package:testable/core/config/env.dart';
import 'package:testable/core/constants/index.dart';
import 'package:testable/core/di/providers.dart';
import 'package:testable/core/observers/app_error_handler.dart';
import 'package:testable/core/services/local_storage_adapter.dart';
import 'package:testable/core/utils/logger.dart';
import 'package:testable/features/auth/data/models/user_model.dart';
import 'package:testable/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:testable/shared/connectivity/connectivity_watcher.dart';

import '../../test/helpers/test_helpers.dart';

class TestAppHarness {
  TestAppHarness({
     this.startAuthenticated = false,
    LocalStorage? storage,
    Env? env,
    UserModel? preAuthenticatedUser,
  }) : storage = storage ?? testLocaloStorage,
       env =
           env ??
           const Env(
             baseUrl: 'https://integration.test',
             enableLogging: false,
             isTest: true,
           ),
       _logger = AppLogger(enabled: false),
       _preAuthenticatedUser = preAuthenticatedUser ?? defaultUser {
    if (startAuthenticated) {
      // Pre-populate storage with authenticated user data
      _setupPreAuthentication();
    }
  }

  static final defaultUser = UserModel(
    id: 'test-user-id',
    name: 'Test User',
    email: 'test@example.com',
    token: 'test-auth-token',
  );

  final bool startAuthenticated;
  final LocalStorage storage;
  final Env env;
  final AppLogger _logger;
  final UserModel _preAuthenticatedUser;

  Widget buildApp() {
    final container = ProviderContainer(
      overrides: [
        envProvider.overrideWithValue(env),
        loggerProvider.overrideWithValue(_logger),
        storageProvider.overrideWithValue(storage),
        connectivityProvider.overrideWith(
          (ref) => ConnectivityNotifier(enableMonitoring: false),
        ),
        // Use real auth repository - it will read from pre-populated storage
        authRepositoryProvider.overrideWith((ref) {
          // Create real auth repository with test storage
          return AuthRepository(ref);
        }),
        // We don't need to override userRepoProvider unless we want fake data
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

    if (startAuthenticated) {
      // Ensure storage is properly set up for authenticated state
      await _setupPreAuthentication();
    } else {
      // Ensure storage is clean for unauthenticated state
      await _clearAuthentication();
    }
  }

  Future<void> _setupPreAuthentication() async {
    try {
      // Clear any existing session first
      await storage.delete(StorageKeys.user);
      await storage.delete(StorageKeys.token, secure: true);

      // Save user data to storage
      await storage.save(StorageKeys.user, _preAuthenticatedUser.toJson());

      // Save token securely
      if (_preAuthenticatedUser.token != null &&
          _preAuthenticatedUser.token!.isNotEmpty) {
        await storage.save(StorageKeys.token, _preAuthenticatedUser.token, secure: true);
      }

      // Verify the data was saved
      final savedUser = await storage.getMap(StorageKeys.user);
      final savedToken = await storage.getString(StorageKeys.token, secure: true);

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

  // Helper method to change authentication state during test
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
}

// Create a simpler test helper for common scenarios
class TestAppHelper {
  static Future<Widget> createAuthenticatedApp({
    UserModel? user,
    bool useRealProviders = true,
  }) async {
    final harness = TestAppHarness(
      startAuthenticated: true,
      preAuthenticatedUser: user,
    );
    await harness.setup();
    return harness.buildApp();
  }

  static Future<Widget> createUnauthenticatedApp({
    bool useRealProviders = true,
  }) async {
    final harness = TestAppHarness(startAuthenticated: false);
    await harness.setup();
    return harness.buildApp();
  }
}
