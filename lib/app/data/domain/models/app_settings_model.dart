import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings_model.freezed.dart';
part 'app_settings_model.g.dart';

@freezed
abstract class AppSettingsModel with _$AppSettingsModel {
  const factory AppSettingsModel({
    @Default('en') String locale,
    @Default(false) bool isDarkMode,
    @Default(true) bool notificationsEnabled,
    @Default(false) bool biometricEnabled,
    @Default(AppSettingsData()) AppSettingsData data,
  }) = _AppSettingsModel;

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsModelFromJson(json);
}

@freezed
abstract class AppSettingsData with _$AppSettingsData {
  const factory AppSettingsData({
    @Default(false) bool isDarkMode,
    @Default('') String themeColor,
    @Default(14.0) double fontSize,
    // Add more fields as needed
  }) = _AppSettingsData;

  factory AppSettingsData.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsDataFromJson(json);
}
