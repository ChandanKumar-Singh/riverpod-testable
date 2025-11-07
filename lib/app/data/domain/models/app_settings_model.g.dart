// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppSettingsModel _$AppSettingsModelFromJson(Map<String, dynamic> json) =>
    _AppSettingsModel(
      locale: json['locale'] as String? ?? 'en',
      isDarkMode: json['isDarkMode'] as bool? ?? false,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      biometricEnabled: json['biometricEnabled'] as bool? ?? false,
      data: json['data'] == null
          ? const AppSettingsData()
          : AppSettingsData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AppSettingsModelToJson(_AppSettingsModel instance) =>
    <String, dynamic>{
      'locale': instance.locale,
      'isDarkMode': instance.isDarkMode,
      'notificationsEnabled': instance.notificationsEnabled,
      'biometricEnabled': instance.biometricEnabled,
      'data': instance.data,
    };

_AppSettingsData _$AppSettingsDataFromJson(Map<String, dynamic> json) =>
    _AppSettingsData(
      isDarkMode: json['isDarkMode'] as bool? ?? false,
      themeColor: json['themeColor'] as String? ?? '',
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 14.0,
    );

Map<String, dynamic> _$AppSettingsDataToJson(_AppSettingsData instance) =>
    <String, dynamic>{
      'isDarkMode': instance.isDarkMode,
      'themeColor': instance.themeColor,
      'fontSize': instance.fontSize,
    };
