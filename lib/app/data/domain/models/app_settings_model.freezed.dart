// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppSettingsModel {

 String get locale; bool get isDarkMode; bool get notificationsEnabled; bool get biometricEnabled; AppSettingsData get data;
/// Create a copy of AppSettingsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppSettingsModelCopyWith<AppSettingsModel> get copyWith => _$AppSettingsModelCopyWithImpl<AppSettingsModel>(this as AppSettingsModel, _$identity);

  /// Serializes this AppSettingsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppSettingsModel&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.isDarkMode, isDarkMode) || other.isDarkMode == isDarkMode)&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled)&&(identical(other.biometricEnabled, biometricEnabled) || other.biometricEnabled == biometricEnabled)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,locale,isDarkMode,notificationsEnabled,biometricEnabled,data);

@override
String toString() {
  return 'AppSettingsModel(locale: $locale, isDarkMode: $isDarkMode, notificationsEnabled: $notificationsEnabled, biometricEnabled: $biometricEnabled, data: $data)';
}


}

/// @nodoc
abstract mixin class $AppSettingsModelCopyWith<$Res>  {
  factory $AppSettingsModelCopyWith(AppSettingsModel value, $Res Function(AppSettingsModel) _then) = _$AppSettingsModelCopyWithImpl;
@useResult
$Res call({
 String locale, bool isDarkMode, bool notificationsEnabled, bool biometricEnabled, AppSettingsData data
});


$AppSettingsDataCopyWith<$Res> get data;

}
/// @nodoc
class _$AppSettingsModelCopyWithImpl<$Res>
    implements $AppSettingsModelCopyWith<$Res> {
  _$AppSettingsModelCopyWithImpl(this._self, this._then);

  final AppSettingsModel _self;
  final $Res Function(AppSettingsModel) _then;

/// Create a copy of AppSettingsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? locale = null,Object? isDarkMode = null,Object? notificationsEnabled = null,Object? biometricEnabled = null,Object? data = null,}) {
  return _then(_self.copyWith(
locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,isDarkMode: null == isDarkMode ? _self.isDarkMode : isDarkMode // ignore: cast_nullable_to_non_nullable
as bool,notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,biometricEnabled: null == biometricEnabled ? _self.biometricEnabled : biometricEnabled // ignore: cast_nullable_to_non_nullable
as bool,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as AppSettingsData,
  ));
}
/// Create a copy of AppSettingsModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppSettingsDataCopyWith<$Res> get data {
  
  return $AppSettingsDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [AppSettingsModel].
extension AppSettingsModelPatterns on AppSettingsModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppSettingsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppSettingsModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppSettingsModel value)  $default,){
final _that = this;
switch (_that) {
case _AppSettingsModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppSettingsModel value)?  $default,){
final _that = this;
switch (_that) {
case _AppSettingsModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String locale,  bool isDarkMode,  bool notificationsEnabled,  bool biometricEnabled,  AppSettingsData data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppSettingsModel() when $default != null:
return $default(_that.locale,_that.isDarkMode,_that.notificationsEnabled,_that.biometricEnabled,_that.data);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String locale,  bool isDarkMode,  bool notificationsEnabled,  bool biometricEnabled,  AppSettingsData data)  $default,) {final _that = this;
switch (_that) {
case _AppSettingsModel():
return $default(_that.locale,_that.isDarkMode,_that.notificationsEnabled,_that.biometricEnabled,_that.data);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String locale,  bool isDarkMode,  bool notificationsEnabled,  bool biometricEnabled,  AppSettingsData data)?  $default,) {final _that = this;
switch (_that) {
case _AppSettingsModel() when $default != null:
return $default(_that.locale,_that.isDarkMode,_that.notificationsEnabled,_that.biometricEnabled,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppSettingsModel implements AppSettingsModel {
  const _AppSettingsModel({this.locale = 'en', this.isDarkMode = false, this.notificationsEnabled = true, this.biometricEnabled = false, this.data = const AppSettingsData()});
  factory _AppSettingsModel.fromJson(Map<String, dynamic> json) => _$AppSettingsModelFromJson(json);

@override@JsonKey() final  String locale;
@override@JsonKey() final  bool isDarkMode;
@override@JsonKey() final  bool notificationsEnabled;
@override@JsonKey() final  bool biometricEnabled;
@override@JsonKey() final  AppSettingsData data;

/// Create a copy of AppSettingsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppSettingsModelCopyWith<_AppSettingsModel> get copyWith => __$AppSettingsModelCopyWithImpl<_AppSettingsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppSettingsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppSettingsModel&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.isDarkMode, isDarkMode) || other.isDarkMode == isDarkMode)&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled)&&(identical(other.biometricEnabled, biometricEnabled) || other.biometricEnabled == biometricEnabled)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,locale,isDarkMode,notificationsEnabled,biometricEnabled,data);

@override
String toString() {
  return 'AppSettingsModel(locale: $locale, isDarkMode: $isDarkMode, notificationsEnabled: $notificationsEnabled, biometricEnabled: $biometricEnabled, data: $data)';
}


}

/// @nodoc
abstract mixin class _$AppSettingsModelCopyWith<$Res> implements $AppSettingsModelCopyWith<$Res> {
  factory _$AppSettingsModelCopyWith(_AppSettingsModel value, $Res Function(_AppSettingsModel) _then) = __$AppSettingsModelCopyWithImpl;
@override @useResult
$Res call({
 String locale, bool isDarkMode, bool notificationsEnabled, bool biometricEnabled, AppSettingsData data
});


@override $AppSettingsDataCopyWith<$Res> get data;

}
/// @nodoc
class __$AppSettingsModelCopyWithImpl<$Res>
    implements _$AppSettingsModelCopyWith<$Res> {
  __$AppSettingsModelCopyWithImpl(this._self, this._then);

  final _AppSettingsModel _self;
  final $Res Function(_AppSettingsModel) _then;

/// Create a copy of AppSettingsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? locale = null,Object? isDarkMode = null,Object? notificationsEnabled = null,Object? biometricEnabled = null,Object? data = null,}) {
  return _then(_AppSettingsModel(
locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,isDarkMode: null == isDarkMode ? _self.isDarkMode : isDarkMode // ignore: cast_nullable_to_non_nullable
as bool,notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,biometricEnabled: null == biometricEnabled ? _self.biometricEnabled : biometricEnabled // ignore: cast_nullable_to_non_nullable
as bool,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as AppSettingsData,
  ));
}

/// Create a copy of AppSettingsModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppSettingsDataCopyWith<$Res> get data {
  
  return $AppSettingsDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$AppSettingsData {

 bool get isDarkMode; String get themeColor; double get fontSize;
/// Create a copy of AppSettingsData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppSettingsDataCopyWith<AppSettingsData> get copyWith => _$AppSettingsDataCopyWithImpl<AppSettingsData>(this as AppSettingsData, _$identity);

  /// Serializes this AppSettingsData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppSettingsData&&(identical(other.isDarkMode, isDarkMode) || other.isDarkMode == isDarkMode)&&(identical(other.themeColor, themeColor) || other.themeColor == themeColor)&&(identical(other.fontSize, fontSize) || other.fontSize == fontSize));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isDarkMode,themeColor,fontSize);

@override
String toString() {
  return 'AppSettingsData(isDarkMode: $isDarkMode, themeColor: $themeColor, fontSize: $fontSize)';
}


}

/// @nodoc
abstract mixin class $AppSettingsDataCopyWith<$Res>  {
  factory $AppSettingsDataCopyWith(AppSettingsData value, $Res Function(AppSettingsData) _then) = _$AppSettingsDataCopyWithImpl;
@useResult
$Res call({
 bool isDarkMode, String themeColor, double fontSize
});




}
/// @nodoc
class _$AppSettingsDataCopyWithImpl<$Res>
    implements $AppSettingsDataCopyWith<$Res> {
  _$AppSettingsDataCopyWithImpl(this._self, this._then);

  final AppSettingsData _self;
  final $Res Function(AppSettingsData) _then;

/// Create a copy of AppSettingsData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isDarkMode = null,Object? themeColor = null,Object? fontSize = null,}) {
  return _then(_self.copyWith(
isDarkMode: null == isDarkMode ? _self.isDarkMode : isDarkMode // ignore: cast_nullable_to_non_nullable
as bool,themeColor: null == themeColor ? _self.themeColor : themeColor // ignore: cast_nullable_to_non_nullable
as String,fontSize: null == fontSize ? _self.fontSize : fontSize // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [AppSettingsData].
extension AppSettingsDataPatterns on AppSettingsData {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppSettingsData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppSettingsData() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppSettingsData value)  $default,){
final _that = this;
switch (_that) {
case _AppSettingsData():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppSettingsData value)?  $default,){
final _that = this;
switch (_that) {
case _AppSettingsData() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isDarkMode,  String themeColor,  double fontSize)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppSettingsData() when $default != null:
return $default(_that.isDarkMode,_that.themeColor,_that.fontSize);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isDarkMode,  String themeColor,  double fontSize)  $default,) {final _that = this;
switch (_that) {
case _AppSettingsData():
return $default(_that.isDarkMode,_that.themeColor,_that.fontSize);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isDarkMode,  String themeColor,  double fontSize)?  $default,) {final _that = this;
switch (_that) {
case _AppSettingsData() when $default != null:
return $default(_that.isDarkMode,_that.themeColor,_that.fontSize);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppSettingsData implements AppSettingsData {
  const _AppSettingsData({this.isDarkMode = false, this.themeColor = '', this.fontSize = 14.0});
  factory _AppSettingsData.fromJson(Map<String, dynamic> json) => _$AppSettingsDataFromJson(json);

@override@JsonKey() final  bool isDarkMode;
@override@JsonKey() final  String themeColor;
@override@JsonKey() final  double fontSize;

/// Create a copy of AppSettingsData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppSettingsDataCopyWith<_AppSettingsData> get copyWith => __$AppSettingsDataCopyWithImpl<_AppSettingsData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppSettingsDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppSettingsData&&(identical(other.isDarkMode, isDarkMode) || other.isDarkMode == isDarkMode)&&(identical(other.themeColor, themeColor) || other.themeColor == themeColor)&&(identical(other.fontSize, fontSize) || other.fontSize == fontSize));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isDarkMode,themeColor,fontSize);

@override
String toString() {
  return 'AppSettingsData(isDarkMode: $isDarkMode, themeColor: $themeColor, fontSize: $fontSize)';
}


}

/// @nodoc
abstract mixin class _$AppSettingsDataCopyWith<$Res> implements $AppSettingsDataCopyWith<$Res> {
  factory _$AppSettingsDataCopyWith(_AppSettingsData value, $Res Function(_AppSettingsData) _then) = __$AppSettingsDataCopyWithImpl;
@override @useResult
$Res call({
 bool isDarkMode, String themeColor, double fontSize
});




}
/// @nodoc
class __$AppSettingsDataCopyWithImpl<$Res>
    implements _$AppSettingsDataCopyWith<$Res> {
  __$AppSettingsDataCopyWithImpl(this._self, this._then);

  final _AppSettingsData _self;
  final $Res Function(_AppSettingsData) _then;

/// Create a copy of AppSettingsData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isDarkMode = null,Object? themeColor = null,Object? fontSize = null,}) {
  return _then(_AppSettingsData(
isDarkMode: null == isDarkMode ? _self.isDarkMode : isDarkMode // ignore: cast_nullable_to_non_nullable
as bool,themeColor: null == themeColor ? _self.themeColor : themeColor // ignore: cast_nullable_to_non_nullable
as String,fontSize: null == fontSize ? _self.fontSize : fontSize // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
