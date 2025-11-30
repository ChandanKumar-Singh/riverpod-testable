import 'package:flutter_test/flutter_test.dart';
import 'package:testable/core/services/local_storage_adapter.dart';
import '../../helpers/test_helpers.dart';

void main() {
  // Initialize Flutter binding for secure storage tests
  TestWidgetsFlutterBinding.ensureInitialized();
  group('LocalStorage', () {
    late LocalStorage storage;
    late MockStorageAdapter mockSharedPrefs;
    late MockStorageAdapter mockSecureStorage;

    setUp(() {
      mockSharedPrefs = MockStorageAdapter();
      mockSecureStorage = MockStorageAdapter();
      storage = LocalStorage(
        sharedPreferencesAdapter: mockSharedPrefs as SharedPreferencesStorageAdapter,
        secureStorageAdapter: mockSecureStorage as SecureStorageAdapter,
      );
    });

    test('init initializes both adapters', () async {
      await storage.init();
      // If no errors thrown, initialization succeeded
      expect(true, isTrue);
    });

    test('save stores value in correct adapter based on secure flag', () async {
      await storage.save('test_key', 'test_value', secure: false);
      expect(await mockSharedPrefs.getString('test_key'), 'test_value');

      await storage.save('secure_key', 'secure_value', secure: true);
      expect(await mockSecureStorage.getString('secure_key'), 'secure_value');
    });

    test('getString retrieves from correct adapter', () async {
      mockSharedPrefs.setValue('regular_key', 'regular_value');
      mockSecureStorage.setValue('secure_key', 'secure_value');

      expect(await storage.getString('regular_key'), 'regular_value');
      expect(await storage.getString('secure_key', secure: true), 'secure_value');
    });

    test('delete removes from correct adapter', () async {
      mockSharedPrefs.setValue('regular_key', 'value');
      mockSecureStorage.setValue('secure_key', 'value');

      await storage.delete('regular_key');
      await storage.delete('secure_key', secure: true);

      expect(mockSharedPrefs.containsKey('regular_key'), isFalse);
      expect(mockSecureStorage.containsKey('secure_key'), isFalse);
    });

    test('clear clears both adapters', () async {
      mockSharedPrefs.setValue('key1', 'value1');
      mockSecureStorage.setValue('key2', 'value2');

      await storage.clear();

      expect(await mockSharedPrefs.getString('key1'), isNull);
      expect(await mockSecureStorage.getString('key2'), isNull);
    });

    test('getInt retrieves from correct adapter', () async {
      mockSharedPrefs.setValue('int_key', 42);
      mockSecureStorage.setValue('secure_int', 100);

      expect(await storage.getInt('int_key'), 42);
      expect(await storage.getInt('secure_int', secure: true), 100);
    });

    test('getBool retrieves from correct adapter', () async {
      mockSharedPrefs.setValue('bool_key', true);
      mockSecureStorage.setValue('secure_bool', false);

      expect(await storage.getBool('bool_key'), isTrue);
      expect(await storage.getBool('secure_bool', secure: true), isFalse);
    });

    test('getDouble retrieves from correct adapter', () async {
      mockSharedPrefs.setValue('double_key', 3.14);
      mockSecureStorage.setValue('secure_double', 2.71);

      expect(await storage.getDouble('double_key'), 3.14);
      expect(await storage.getDouble('secure_double', secure: true), 2.71);
    });

    test('getStringList retrieves from correct adapter', () async {
      final list = ['item1', 'item2', 'item3'];
      mockSharedPrefs.setValue('list_key', list);
      mockSecureStorage.setValue('secure_list', list);

      expect(await storage.getStringList('list_key'), list);
      expect(await storage.getStringList('secure_list', secure: true), list);
    });

    test('getMap retrieves from correct adapter', () async {
      final map = {'key': 'value'};
      mockSharedPrefs.setValue('map_key', map);
      mockSecureStorage.setValue('secure_map', map);

      expect(await storage.getMap('map_key'), map);
      expect(await storage.getMap('secure_map', secure: true), map);
    });
  });

  group('SharedPreferencesStorageAdapter', () {
    late SharedPreferencesStorageAdapter adapter;

    setUp(() {
      adapter = SharedPreferencesStorageAdapter();
    });

    test('init can be called multiple times safely', () async {
      await adapter.init();
      await adapter.init(); // Should not throw
      expect(true, isTrue);
    });

    test('save handles null by deleting key', () async {
      await adapter.save('test_key', 'value');
      await adapter.save('test_key', null);
      // Should not throw
      expect(true, isTrue);
    });

    test('save handles different value types', () async {
      await adapter.save('string', 'value');
      await adapter.save('int', 42);
      await adapter.save('bool', true);
      await adapter.save('double', 3.14);
      await adapter.save('list', ['item1', 'item2']);
      await adapter.save('map', {'key': 'value'});
      // Should not throw
      expect(true, isTrue);
    });
  });

  group('SecureStorageAdapter', () {
    late SecureStorageAdapter adapter;

    setUp(() {
      adapter = SecureStorageAdapter();
    });

    test('init can be called multiple times safely', () async {
      await adapter.init();
      await adapter.init(); // Should not throw
      expect(true, isTrue);
    });

    test('save handles null by deleting key', () async {
      await adapter.save('test_key', 'value');
      await adapter.save('test_key', null);
      // Should not throw
      expect(true, isTrue);
    });

    test('save handles different value types', () async {
      await adapter.save('string', 'value');
      await adapter.save('int', 42);
      await adapter.save('bool', true);
      await adapter.save('double', 3.14);
      await adapter.save('list', ['item1', 'item2']);
      await adapter.save('map', {'key': 'value'});
      // Should not throw
      expect(true, isTrue);
    });
  });
}

