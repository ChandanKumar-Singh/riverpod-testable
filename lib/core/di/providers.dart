// FEATURE: Providers

// core/di/providers.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:testable/app/router/app_router.dart';
import 'package:testable/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:testable/shared/localization/lang_provider.dart';
import 'package:testable/shared/localization/lang_storage.dart';
import 'package:testable/shared/theme/theme_provider.dart';
import 'package:testable/shared/theme/theme_storage.dart';
import 'package:testable/core/config/env.dart';
import 'package:testable/core/utils/logger.dart';
import 'package:testable/core/network/dio/http_client.dart';
import 'package:testable/core/services/api_service.dart';
import 'package:testable/core/services/storage_adapter.dart';
import 'package:testable/core/network/network_info.dart';
import 'package:testable/core/constants/index.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

////////// APP PROVIDERS ////////////
final appRouterProvider = Provider<AppRouter>((ref) {
  return AppRouter(ref: ref);
});

//////////// SHARED PROVIDERS ////////////

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  final storage = ref.read(themeStorageProvider);
  return ThemeNotifier(storage);
});

final langProvider = StateNotifierProvider<LangNotifier, Locale>((ref) {
  final storage = ref.read(langStorageProvider);
  return LangNotifier(storage);
});

//////////// CORE PROVIDERS ////////////

/// Environment provider (swap during tests)
final envProvider = Provider<Env>((ref) => Env.current);

final _dioProvider = Provider<Dio>((ref) {
  final env = ref.watch(envProvider);
  return Dio(BaseOptions(baseUrl: env.baseUrl));
});

final httpClientProvider = Provider<AppHttpClient>((ref) {
  final logger = ref.watch(loggerProvider);
  final env = ref.watch(envProvider);
  final dio = ref.watch(_dioProvider);
  // Token getter for authenticated requests
  final tokenGetter = () async {
    try {
      final storage = ref.read(storageProvider);
      return await storage.getString(StorageKeys.token, secure: true);
    } catch (e) {
      return null;
    }
  };
  return AppHttpClient(
    dio: dio,
    logger: logger,
    env: env,
    tokenGetter: tokenGetter,
  );
});

final _connectivityProvider = Provider((ref) => Connectivity());

final networkInfoProvider = Provider<NetworkInfo>((ref) {
  final conn = ref.watch(_connectivityProvider);
  return NetworkInfoImpl(conn);
});

//////////// SERVICES PROVIDERS ////////////

final apiServiceProvider = Provider<ApiService>((ref) {
  return AuthRepository(ref);
});

// Storage provider - must be overridden in bootstrap with actual storage instance
final storageProvider = Provider<StorageAdapter>(
  (ref) => throw StateError(
    'StorageProvider must be overridden in bootstrap. Call storageProvider.overrideWithValue(storage) in bootstrap().',
  ),
);

//////////// HELPERS / UTILITIES PROVIDERS //////////

final loggerProvider = Provider<AppLogger>((ref) {
  final env = ref.watch(envProvider);
  return AppLogger(enabled: env.enableLogging);
});
