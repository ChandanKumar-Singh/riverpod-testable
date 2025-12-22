import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:testable/app/data/repositories/app_settings_repository.dart';
import 'package:testable/app/data/domain/models/app_settings_model.dart';

final appSettingsProvider =
    StateNotifierProvider<AppSettingsNotifier, AppSettingsModel>((ref) {
      final repo = AppSettingsRepository(ref);
      return AppSettingsNotifier(repo);
    });

class AppSettingsNotifier extends StateNotifier<AppSettingsModel> {
  AppSettingsNotifier(this.repo) : super(const AppSettingsModel());
  final AppSettingsRepository repo;

  Future<void> load() async {
    await repo.loadSettings();
    // state = AppSettingsModel.fromJson(data);
  }

  void toggleTheme() {
    // final updated = state.copyWith(isDarkMode: !state.isDarkMode);
    // state = updated;
    // _repo.saveSettings(updated.toJson());
  }

  void setLocale(String locale) {
    // final updated = state.copyWith(locale: locale);
    // state = updated;
    // _repo.saveSettings(updated.toJson());
  }

  void toggleNotifications(bool value) {
    // final updated = state.copyWith(notificationsEnabled: value);
    // state = updated;
    // _repo.saveSettings(updated.toJson());
  }

  void toggleBiometric(bool value) {
    state = state.copyWith(biometricEnabled: value);
    // state = updated;
    // _repo.saveSettings(updated.toJson());
  }
}
