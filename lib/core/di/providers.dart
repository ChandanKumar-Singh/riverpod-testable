// core/di/providers.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../app/router/app_router.dart';
import '../../shared/localization/lang_provider.dart';
import '../../shared/localization/lang_storage.dart';
import '../../shared/theme/theme_provider.dart';
import '../../shared/theme/theme_storage.dart';
import '../config/env.dart';
import '../utils/logger.dart';
import '../network/dio/http_client.dart';
import '../services/api_service.dart';
import '../services/api/api_service_impl.dart';
import '../services/local_storage_adapter.dart';
import '../network/network_info.dart';
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
  return AppHttpClient(dio: dio, logger: logger, env: env);
});

final _connectivityProvider = Provider((ref) => Connectivity());

final networkInfoProvider = Provider<NetworkInfo>((ref) {
  final conn = ref.watch(_connectivityProvider);
  return NetworkInfoImpl(conn);
});

//////////// SERVICES PROVIDERS ////////////

final apiServiceProvider = Provider<ApiService>((ref) {
  final http = ref.watch(httpClientProvider);
  return AuthRepository(http);
});

final _sharedPreferencesProvider = Provider<SharedPreferencesStorageAdapter>((
  ref,
) {
  // Default local adapter. In prod you could provide secure storage.
  return SharedPreferencesStorageAdapter();
});

final _secureStorageProvider = Provider<SecureStorageAdapter>((ref) {
  // Default local adapter. In prod you could provide secure storage.
  return SecureStorageAdapter();
});

final storageProvider = Provider<LocalStorage>((ref) {
  // Default local adapter. In prod you could provide secure storage.
  final sp = ref.watch(_sharedPreferencesProvider);
  final ss = ref.watch(_secureStorageProvider);
  final adaptor = LocalStorage(
    secureStorageAdapter: ss,
    sharedPreferencesAdapter: sp,
  );
  adaptor.init();
  return adaptor;
});

//////////// HELPERS / UTILITIES PROVIDERS //////////

final loggerProvider = Provider<AppLogger>((ref) {
  final env = ref.watch(envProvider);
  return AppLogger(enabled: env.enableLogging);
});
