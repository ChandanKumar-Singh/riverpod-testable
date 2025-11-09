// data/repositories/app_repository.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable/core/network/dio/models/api_response.dart';

import '../../../core/di/providers.dart';
import '../../../core/services/api_service.dart';
import '../domain/models/app_settings_model.dart';

class AppSettingsRepository extends ApiService {
  final Ref ref;
  AppSettingsRepository(this.ref)
    : super(
        env: ref.read(envProvider),
        client: ref.read(httpClientProvider),
        logger: ref.read(loggerProvider),
      );

  /// Example of a global health check endpoint
  Future<bool> pingServer() async {
    final res = await request('/health');
    return res.isSuccess;
  }

  Future<AppSettingsData?> loadSettings() async {
    final res = await request<AppSettingsData>(
      '/settings',
      fromJson: (d) => AppSettingsData(),
    );
    if (res.isSuccess) return res.data;
    return null;
  }
}
