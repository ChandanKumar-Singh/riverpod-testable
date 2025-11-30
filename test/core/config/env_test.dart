import 'package:flutter_test/flutter_test.dart';
import 'package:testable/core/config/env.dart';

void main() {
  group('Env', () {
    test('current returns dev by default', () {
      final env = Env.current;
      expect(env, isNotNull);
    });

    test('dev environment has correct properties', () {
      final env = Env.dev;
      expect(env.baseUrl, isNotEmpty);
      expect(env.enableLogging, isTrue);
      expect(env.isTest, isFalse);
    });

    test('prod environment has correct properties', () {
      final env = Env.prod;
      expect(env.baseUrl, isNotEmpty);
      expect(env.enableLogging, isFalse);
      expect(env.isTest, isFalse);
    });

    test('test environment has correct properties', () {
      final env = Env.test;
      expect(env.baseUrl, isNotEmpty);
      expect(env.enableLogging, isTrue);
      expect(env.isTest, isTrue);
    });
  });
}

