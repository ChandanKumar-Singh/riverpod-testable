// FEATURE: Repositories

// data/repositories/app_repository.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:testable/core/di/providers.dart';
import 'package:testable/core/services/api_service.dart';
import 'package:testable/app/data/domain/models/app_settings_model.dart';

class AppSettingsRepository extends ApiService {
  AppSettingsRepository(this.ref)
    : super(
        env: ref.read(envProvider),
        client: ref.read(httpClientProvider),
        logger: ref.read(loggerProvider),
      );
  final Ref ref;

  /// Example of a global health check endpoint
  Future<bool> pingServer() async {
    final res = await request('/health');
    return res.isSuccess;
  }

  Future<AppSettingsData?> loadSettings() async {
    final res = await request<AppSettingsData>(
      '/settings',
      fromJson: (d) => const AppSettingsData(),
    );
    if (res.isSuccess) return res.data;
    return null;
  }
}
