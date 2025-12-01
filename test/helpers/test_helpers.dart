// Test helpers for common test utilities
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable/core/services/local_storage_adapter.dart';
import 'package:testable/core/services/storage_adapter.dart';
import 'package:testable/core/config/env.dart';

/// Mock storage adapter for testing
class MockSharedPreferencesStorageAdapter implements SharedPreferencesStorageAdapter {
  final Map<String, dynamic> _storage = {};

  @override
  Future<void> init() async {}

  @override
  Future<void> save(String key, dynamic value) async {
    _storage[key] = value;
  }

  @override
  Future<String?> getString(String key) async {
    return _storage[key]?.toString();
  }

  @override
  Future<int?> getInt(String key) async {
    final value = _storage[key];
    return value is int ? value : int.tryParse(value?.toString() ?? '');
  }

  @override
  Future<bool?> getBool(String key) async {
    final value = _storage[key];
    return value is bool ? value : value?.toString().toLowerCase() == 'true';
  }

  @override
  Future<double?> getDouble(String key) async {
    final value = _storage[key];
    return value is double ? value : double.tryParse(value?.toString() ?? '');
  }

  @override
  Future<List<String>?> getStringList(String key) async {
    final value = _storage[key];
    return value is List<String> ? value : null;
  }

  @override
  Future<Map<String, dynamic>?> getMap(
    String key, {
    bool secure = false,
  }) async {
    final value = _storage[key];
    return value is Map<String, dynamic> ? value : null;
  }

  @override
  Future<void> delete(String key) async {
    _storage.remove(key);
  }

  @override
  Future<void> clear() async {
    _storage.clear();
  }

  // Helper methods for testing
  void setValue(String key, dynamic value) {
    _storage[key] = value;
  }

  @override
  Future<bool> containsKey(String key) async {
    return _storage.containsKey(key);
  }

  @override
  Future<Set<String>> getKeys() {
    throw UnimplementedError();
  }
}

/// Mock storage adapter for testing
class MockSecureStorageAdapter implements SecureStorageAdapter {
  final Map<String, dynamic> _storage = {};

  @override
  Future<void> init() async {}

  @override
  Future<void> save(String key, dynamic value) async {
    _storage[key] = value;
  }

  @override
  Future<String?> getString(String key) async {
    return _storage[key]?.toString();
  }

  @override
  Future<int?> getInt(String key) async {
    final value = _storage[key];
    return value is int ? value : int.tryParse(value?.toString() ?? '');
  }

  @override
  Future<bool?> getBool(String key) async {
    final value = _storage[key];
    return value is bool ? value : value?.toString().toLowerCase() == 'true';
  }

  @override
  Future<double?> getDouble(String key) async {
    final value = _storage[key];
    return value is double ? value : double.tryParse(value?.toString() ?? '');
  }

  @override
  Future<List<String>?> getStringList(String key) async {
    final value = _storage[key];
    return value is List<String> ? value : null;
  }

  @override
  Future<Map<String, dynamic>?> getMap(
    String key, {
    bool secure = false,
  }) async {
    final value = _storage[key];
    return value is Map<String, dynamic> ? value : null;
  }

  @override
  Future<void> delete(String key) async {
    _storage.remove(key);
  }

  @override
  Future<void> clear() async {
    _storage.clear();
  }

  // Helper methods for testing
  void setValue(String key, dynamic value) {
    _storage[key] = value;
  }

  @override
  Future<bool> containsKey(String key) async {
    return _storage.containsKey(key);
  }

  @override
  Future<void> saveStringList(String key, List<String> value) {
    throw UnimplementedError();
  }
}

/// Helper to create a test container with overrides
ProviderContainer createTestContainer({
  List<Override>? overrides,
  StorageAdapter? storage,
}) {
  final List<Override> finalOverrides = [...?overrides];

  // Note: storageProvider override should be done at the test level
  // if needed, as it requires importing from core/di/providers.dart

  return ProviderContainer(overrides: finalOverrides);
}

/// Helper to wait for async operations
Future<void> pump() async {
  await Future<void>.delayed(Duration.zero);
}

/// Helper to wait for a specific duration
Future<void> waitFor(Duration duration) async {
  await Future<void>.delayed(duration);
}

/// Test environment configuration
class TestEnv extends Env {
  TestEnv()
    : super(
        baseUrl: 'http://localhost:3000',
        enableLogging: false,
        isTest: true,
      );
}
