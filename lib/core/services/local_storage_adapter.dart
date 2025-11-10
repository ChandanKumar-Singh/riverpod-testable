// FEATURE: Storage Service

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'storage_adapter.dart';

Future<LocalStorage> loadStorage() async {
  final sp = SharedPreferencesStorageAdapter();
  final ss = SecureStorageAdapter();
  final storage = LocalStorage(
    secureStorageAdapter: ss,
    sharedPreferencesAdapter: sp,
  );
  await storage.init();
  return storage;
}

class LocalStorage implements StorageAdapter {
  final SharedPreferencesStorageAdapter sharedPreferencesAdapter;
  final SecureStorageAdapter secureStorageAdapter;

  LocalStorage({
    required this.sharedPreferencesAdapter,
    required this.secureStorageAdapter,
  });
  @override
  Future<void> init() async {
    await Future.wait([
      sharedPreferencesAdapter.init(),
      secureStorageAdapter.init(),
    ]);
  }

  @override
  Future<void> clear() async {
    sharedPreferencesAdapter.clear();
    await secureStorageAdapter.clear();
  }

  @override
  Future<void> delete(String key, {bool secure = false}) async {
    if (secure) {
      await secureStorageAdapter.delete(key, secure: secure);
    } else {
      await sharedPreferencesAdapter.delete(key, secure: secure);
    }
  }

  @override
  Future<bool?> getBool(String key, {bool secure = false}) {
    if (secure) {
      return secureStorageAdapter.getBool(key);
    } else {
      return sharedPreferencesAdapter.getBool(key);
    }
  }

  @override
  Future<double?> getDouble(String key, {bool secure = false}) {
    if (secure) {
      return secureStorageAdapter.getDouble(key);
    } else {
      return sharedPreferencesAdapter.getDouble(key);
    }
  }

  @override
  Future<int?> getInt(String key, {bool secure = false}) {
    if (secure) {
      return secureStorageAdapter.getInt(key);
    } else {
      return sharedPreferencesAdapter.getInt(key);
    }
  }

  @override
  Future<Map<String, dynamic>?> getMap(String key, {bool secure = false}) {
    if (secure) {
      return secureStorageAdapter.getMap(key);
    } else {
      return sharedPreferencesAdapter.getMap(key);
    }
  }

  @override
  Future<String?> getString(String key, {bool secure = false}) {
    if (secure) {
      return secureStorageAdapter.getString(key);
    } else {
      return sharedPreferencesAdapter.getString(key);
    }
  }

  @override
  Future<List<String>?> getStringList(String key, {bool secure = false}) {
    if (secure) {
      return secureStorageAdapter.getStringList(key);
    } else {
      return sharedPreferencesAdapter.getStringList(key);
    }
  }

  @override
  Future<void> save(String key, dynamic value, {bool secure = false}) {
    if (secure) {
      return secureStorageAdapter.save(key, value);
    } else {
      return sharedPreferencesAdapter.save(key, value);
    }
  }
}

/// Shared Preferences implementation for non-sensitive data
class SharedPreferencesStorageAdapter implements StorageAdapter {
  SharedPreferences? _prefs;
  bool _isInitialized = false;

  // Private method for logging
  void _print(String message, {Object? error, StackTrace? stackTrace}) {
    // In production, you might want to use a proper logger
    // For now, using print but you can replace with your logger
    if (error != null) {
      print('🔄 SharedPreferencesStorage: $message - Error: $error');
      if (stackTrace != null) {
        print('Stack Trace: $stackTrace');
      }
    } else {
      print('🔄 SharedPreferencesStorage: $message');
    }
  }

  @override
  Future<void> init() async {
    try {
      if (!_isInitialized) {
        _print('Initializing SharedPreferences...');
        _prefs = await SharedPreferences.getInstance();
        _isInitialized = true;
        _print('SharedPreferences initialized successfully');
      }
    } catch (error, stackTrace) {
      _print(
        'Failed to initialize SharedPreferences',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> save(String key, dynamic value, {bool secure = false}) async {
    try {
      await init();
      if (value == null) {
        await delete(key, secure: secure);
        return;
      }

      if (value is String) {
        await _prefs!.setString(key, value);
      } else if (value is int) {
        await _prefs!.setInt(key, value);
      } else if (value is bool) {
        await _prefs!.setBool(key, value);
      } else if (value is double) {
        await _prefs!.setDouble(key, value);
      } else if (value is List<String>) {
        await _prefs!.setStringList(key, value);
      } else if (value is Map) {
        await _prefs!.setString(key, json.encode(value));
      } else {}
    } catch (error, stackTrace) {
      _print(
        'Failed to save value for key: $key',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<String?> getString(String key, {bool secure = false}) async {
    try {
      await init();
      final value = _prefs!.getString(key);
      return value;
    } catch (error, stackTrace) {
      _print(
        'Failed to read string for key: $key',
        error: error,
        stackTrace: stackTrace,
      );
    }
    return null;
  }

  @override
  Future<int?> getInt(String key, {bool secure = false}) async {
    try {
      await init();
      final value = _prefs!.getInt(key);
      return value;
    } catch (error, stackTrace) {
      _print(
        'Failed to read int for key: $key',
        error: error,
        stackTrace: stackTrace,
      );
    }
    return null;
  }

  @override
  Future<bool?> getBool(String key, {bool secure = false}) async {
    try {
      await init();
      final value = _prefs!.getBool(key);
      return value;
    } catch (error, stackTrace) {
      _print(
        'Failed to read bool for key: $key',
        error: error,
        stackTrace: stackTrace,
      );
    }
    return null;
  }

  @override
  Future<double?> getDouble(String key, {bool secure = false}) async {
    try {
      await init();
      final value = _prefs!.getDouble(key);
      return value;
    } catch (error, stackTrace) {
      _print(
        'Failed to read double for key: $key',
        error: error,
        stackTrace: stackTrace,
      );
    }
    return null;
  }

  @override
  Future<List<String>?> getStringList(String key, {bool secure = false}) async {
    try {
      await init();
      final value = _prefs!.getStringList(key);
      return value;
    } catch (error, stackTrace) {
      _print(
        'Failed to read string list for key: $key',
        error: error,
        stackTrace: stackTrace,
      );
    }
    return null;
  }

  @override
  Future<Map<String, dynamic>?> getMap(
    String key, {
    bool secure = false,
  }) async {
    try {
      await init();
      final jsonString = _prefs!.getString(key);
      if (jsonString == null) return null;
      return json.decode(jsonString) as Map<String, dynamic>;
    } catch (error, stackTrace) {
      _print(
        'Failed to read all data as map',
        error: error,
        stackTrace: stackTrace,
      );
    }
    return null;
  }

  @override
  Future<void> delete(String key, {bool secure = false}) async {
    try {
      await init();
      await _prefs!.remove(key);
    } catch (error, stackTrace) {
      _print(
        'Failed to delete key: $key',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> clear() async {
    try {
      await init();
      _print('Clearing all data');
      await _prefs!.clear();
    } catch (error, stackTrace) {
      _print('Failed to clear all data', error: error, stackTrace: stackTrace);
    }
  }

  /// Additional utility methods
  Future<bool> containsKey(String key) async {
    try {
      await init();
      return _prefs!.containsKey(key);
    } catch (error, stackTrace) {
      _print(
        'Failed to check if key exists: $key',
        error: error,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  Future<Set<String>> getKeys() async {
    try {
      await init();
      return _prefs!.getKeys();
    } catch (error, stackTrace) {
      _print('Failed to get all keys', error: error, stackTrace: stackTrace);
      return <String>{};
    }
  }
}

/// Secure Storage implementation for sensitive data using flutter_secure_storage
class SecureStorageAdapter implements StorageAdapter {
  static const _defaultOptions = AndroidOptions(
    encryptedSharedPreferences: true,
    resetOnError: true,
  );

  static const _iOSOptions = IOSOptions(
    accessibility: KeychainAccessibility.first_unlock,
  );

  static const _webOptions = WebOptions();

  static const _linuxOptions = LinuxOptions();

  static const _windowsOptions = WindowsOptions();

  static const _macOSOptions = MacOsOptions(
    accessibility: KeychainAccessibility.first_unlock,
  );

  late FlutterSecureStorage _secureStorage;
  bool _isInitialized = false;

  // Private method for logging
  void _print(String message, {Object? error, StackTrace? stackTrace}) {
    if (error != null) {
      print('🔒 SecureStorageAdapter: $message - Error: $error');
      if (stackTrace != null) {
        print('Stack Trace: $stackTrace');
      }
    } else {
      print('🔒 SecureStorageAdapter: $message');
    }
  }

  @override
  Future<void> init() async {
    try {
      if (!_isInitialized) {
        _print('Initializing Secure Storage...');
        _secureStorage = const FlutterSecureStorage(
          aOptions: _defaultOptions,
          iOptions: _iOSOptions,
          webOptions: _webOptions,
          lOptions: _linuxOptions,
          wOptions: _windowsOptions,
          mOptions: _macOSOptions,
        );
        _isInitialized = true;
        _print('Secure Storage initialized successfully');
      }
    } catch (error, stackTrace) {
      _print(
        'Failed to initialize Secure Storage',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> save(String key, dynamic value, {bool secure = false}) async {
    try {
      await init();
      _print('Saving secure value for key: $key');

      if (value == null) {
        await delete(key, secure: secure);
        return;
      }

      String? stringValue;
      if (value is String) {
        stringValue = value;
      } else if (value is int) {
        stringValue = value.toString();
      } else if (value is bool) {
        stringValue = value.toString();
      } else if (value is double) {
        stringValue = value.toString();
      } else if (value is List<String>) {
        stringValue = json.encode(value);
      } else if (value is Map) {
        stringValue = json.encode(value);
      } else {}
      await _secureStorage.write(key: key, value: stringValue);
    } catch (error, stackTrace) {
      _print(
        'Failed to save secure value for key: $key',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<String?> getString(String key, {bool secure = false}) async {
    try {
      await init();
      final value = await _secureStorage.read(key: key);
      return value;
    } catch (error, stackTrace) {
      _print(
        'Failed to read secure string for key: $key',
        error: error,
        stackTrace: stackTrace,
      );
    }
    return null;
  }

  @override
  Future<int?> getInt(String key, {bool secure = false}) async {
    try {
      await init();
      final stringValue = await _secureStorage.read(key: key);
      if (stringValue == null) {
        _print('No secure int value found for key: $key');
        return null;
      }

      final value = int.tryParse(stringValue);
      return value;
    } catch (error, stackTrace) {
      _print(
        'Failed to read secure int for key: $key',
        error: error,
        stackTrace: stackTrace,
      );
    }
    return null;
  }

  @override
  Future<bool?> getBool(String key, {bool secure = false}) async {
    try {
      await init();
      final stringValue = await _secureStorage.read(key: key);
      if (stringValue == null) {
        _print('No secure bool value found for key: $key');
        return null;
      }

      final value = stringValue.toLowerCase() == 'true';
      _print('Found secure bool value for key: $key');
      return value;
    } catch (error, stackTrace) {
      _print(
        'Failed to read secure bool for key: $key',
        error: error,
        stackTrace: stackTrace,
      );
    }
    return null;
  }

  @override
  Future<double?> getDouble(String key, {bool secure = false}) async {
    try {
      await init();
      final stringValue = await _secureStorage.read(key: key);
      if (stringValue == null) {
        _print('No secure double value found for key: $key');
        return null;
      }

      final value = double.tryParse(stringValue);
      return value;
    } catch (error, stackTrace) {
      _print(
        'Failed to read secure double for key: $key',
        error: error,
        stackTrace: stackTrace,
      );
    }
    return null;
  }

  @override
  Future<List<String>?> getStringList(String key, {bool secure = false}) async {
    try {
      await init();
      // Secure storage doesn't natively support lists, so we'll use JSON
      final stringValue = await _secureStorage.read(key: key);
      if (stringValue == null) {
        _print('No secure string list found for key: $key');
        return null;
      }

      try {
        final list = List<String>.from(json.decode(stringValue) as List);
        _print(
          'Found secure string list with ${list.length} items for key: $key',
        );
        return list;
      } catch (parseError) {
        _print(
          'Failed to parse secure string list for key: $key',
          error: parseError,
        );
        return null;
      }
    } catch (error, stackTrace) {
      _print(
        'Failed to read secure string list for key: $key',
        error: error,
        stackTrace: stackTrace,
      );
    }
    return null;
  }

  @override
  Future<Map<String, dynamic>?> getMap(
    String key, {
    bool secure = false,
  }) async {
    try {
      await init();
      final jsonString = await _secureStorage.read(key: key);
      if (jsonString == null) return null;
      return json.decode(jsonString) as Map<String, dynamic>;
    } catch (error, stackTrace) {
      _print(
        'Failed to read all secure data as map',
        error: error,
        stackTrace: stackTrace,
      );
    }
    return null;
  }

  @override
  Future<void> delete(String key, {bool secure = false}) async {
    try {
      await init();
      await _secureStorage.delete(key: key);
    } catch (error, stackTrace) {
      _print(
        'Failed to delete secure key: $key',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> clear() async {
    try {
      await init();
      _print('Clearing all secure data');
      await _secureStorage.deleteAll();
    } catch (error, stackTrace) {
      _print(
        'Failed to clear all secure data',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Secure storage specific methods
  Future<bool> containsKey(String key) async {
    try {
      await init();
      return await _secureStorage.containsKey(key: key);
    } catch (error, stackTrace) {
      _print(
        'Failed to check if secure key exists: $key',
        error: error,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Save string list as JSON
  Future<void> saveStringList(String key, List<String> value) async {
    try {
      await init();
      final jsonString = json.encode(value);
      await _secureStorage.write(key: key, value: jsonString);
    } catch (error, stackTrace) {
      _print(
        'Failed to save secure string list for key: $key',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}

/// Storage Exception class
class StorageException implements Exception {
  final String message;
  final Object? error;
  final StackTrace? stackTrace;

  const StorageException(this.message, {this.error, this.stackTrace});

  @override
  String toString() {
    return 'StorageException: $message${error != null ? ' - $error' : ''}';
  }
}
