import 'package:flutter_test/flutter_test.dart';
import 'package:testable/features/auth/data/models/user_model.dart';

void main() {
  group('AuthRepository', () {
    // Note: These are unit tests for the repository logic
    // For full integration tests, you would need to mock the API service

    test('UserModel should serialize and deserialize correctly', () {
      final user = UserModel(
        id: '1',
        name: 'Test User',
        email: 'test@example.com',
        token: 'test-token',
      );

      final json = user.toJson();
      final deserialized = UserModel.fromJson(json);

      expect(deserialized.id, user.id);
      expect(deserialized.name, user.name);
      expect(deserialized.email, user.email);
      expect(deserialized.token, user.token);
    });

    test('UserModel should handle null values', () {
      final user = UserModel(id: '1', name: 'Test User');

      final json = user.toJson();
      final deserialized = UserModel.fromJson(json);

      expect(deserialized.id, user.id);
      expect(deserialized.name, user.name);
      expect(deserialized.email, isNull);
      expect(deserialized.token, isNull);
    });
  });
}
