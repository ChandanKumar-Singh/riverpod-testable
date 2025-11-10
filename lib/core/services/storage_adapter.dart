// core/services/storage_adapter.dart

/// Abstract storage adapter for persistence (small key/value).
/// Implementations: SharedPreferences, Hive, SecureStorage, etc.
abstract class StorageAdapter {
  Future<void> init();
  Future<void> save(String key, dynamic value, {bool secure = false});
  Future<String?> getString(String key, {bool secure = false});
  Future<int?> getInt(String key, {bool secure = false});
  Future<bool?> getBool(String key, {bool secure = false});
  Future<double?> getDouble(String key, {bool secure = false});
  Future<List<String>?> getStringList(String key, {bool secure = false});
  Future<Map<String, dynamic>?> getMap(String key, {bool secure = false});
  Future<void> delete(String key, {bool secure = false});
  Future<void> clear();
}
