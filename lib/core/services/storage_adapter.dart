// core/services/storage_adapter.dart

/// Abstract storage adapter for persistence (small key/value).
/// Implementations: SharedPreferences, Hive, SecureStorage, etc.
abstract class StorageAdapter {
  Future<void> init();
  Future<void> save(String key, dynamic value);
  Future<String?> getString(String key);
  Future<int?> getInt(String key);
  Future<bool?> getBool(String key);
  Future<double?> getDouble(String key);
  Future<List<String>?> getStringList(String key);
  Future<Map<String, dynamic>?> getMap(String key);
  Future<void> delete(String key);
  Future<void> clear();
}
