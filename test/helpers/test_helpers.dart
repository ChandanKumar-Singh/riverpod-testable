// Test helpers for common test utilities
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable/core/services/storage_adapter.dart';
import 'package:testable/core/config/env.dart';
import 'package:testable/core/utils/logger.dart';
import 'package:testable/core/network/dio/http_client.dart';
import 'package:dio/dio.dart';

/// Mock storage adapter for testing
class MockStorageAdapter implements StorageAdapter {
  final Map<String, dynamic> _storage = {};
  final Map<String, dynamic> _secureStorage = {};

  @override
  Future<void> init() async {}

  @override
  Future<void> save(String key, dynamic value, {bool secure = false}) async {
    if (secure) {
      _secureStorage[key] = value;
    } else {
      _storage[key] = value;
    }
  }

  @override
  Future<String?> getString(String key, {bool secure = false}) async {
    if (secure) {
      return _secureStorage[key]?.toString();
    }
    return _storage[key]?.toString();
  }

  @override
  Future<int?> getInt(String key, {bool secure = false}) async {
    if (secure) {
      final value = _secureStorage[key];
      return value is int ? value : int.tryParse(value?.toString() ?? '');
    }
    final value = _storage[key];
    return value is int ? value : int.tryParse(value?.toString() ?? '');
  }

  @override
  Future<bool?> getBool(String key, {bool secure = false}) async {
    if (secure) {
      final value = _secureStorage[key];
      return value is bool ? value : value?.toString().toLowerCase() == 'true';
    }
    final value = _storage[key];
    return value is bool ? value : value?.toString().toLowerCase() == 'true';
  }

  @override
  Future<double?> getDouble(String key, {bool secure = false}) async {
    if (secure) {
      final value = _secureStorage[key];
      return value is double ? value : double.tryParse(value?.toString() ?? '');
    }
    final value = _storage[key];
    return value is double ? value : double.tryParse(value?.toString() ?? '');
  }

  @override
  Future<List<String>?> getStringList(String key, {bool secure = false}) async {
    if (secure) {
      final value = _secureStorage[key];
      return value is List<String> ? value : null;
    }
    final value = _storage[key];
    return value is List<String> ? value : null;
  }

  @override
  Future<Map<String, dynamic>?> getMap(
    String key, {
    bool secure = false,
  }) async {
    if (secure) {
      final value = _secureStorage[key];
      return value is Map<String, dynamic> ? value : null;
    }
    final value = _storage[key];
    return value is Map<String, dynamic> ? value : null;
  }

  @override
  Future<void> delete(String key, {bool secure = false}) async {
    if (secure) {
      _secureStorage.remove(key);
    } else {
      _storage.remove(key);
    }
  }

  @override
  Future<void> clear() async {
    _storage.clear();
    _secureStorage.clear();
  }

  // Helper methods for testing
  void setValue(String key, dynamic value, {bool secure = false}) {
    if (secure) {
      _secureStorage[key] = value;
    } else {
      _storage[key] = value;
    }
  }

  bool containsKey(String key, {bool secure = false}) {
    if (secure) {
      return _secureStorage.containsKey(key);
    }
    return _storage.containsKey(key);
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
