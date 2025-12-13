// FEATURE: ENV

// core/config/env.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Simple environment configuration.
/// In production you may load from --dart-define, separate files, or CI secrets.
class Env {
  const Env({
    required this.baseUrl,
    required this.enableLogging,
    this.isTest = false,
    this.refreshTokenEnabled = false,
  });
  final String baseUrl;
  final bool enableLogging;
  final bool isTest;
  final bool refreshTokenEnabled;

  static Env get current {
    const env = String.fromEnvironment('ENV', defaultValue: 'dev');
    ;
    return env == 'prod'
        ? Env.prod
        : env == 'test'
        ? Env.test
        : Env.dev;
  }

  // default dev config
  static final dev = Env(
    baseUrl: dotenv.env['BASE_URL'] ?? 'https://dev.example.com',
    enableLogging: true,
  );

  // production (override via --dart-define or CI)
  static final prod = Env(
    baseUrl: dotenv.env['BASE_URL'] ?? 'https://api.example.com',
    enableLogging: false,
  );

  // production (override via --dart-define or CI)
  static final test = Env(
    baseUrl: dotenv.env['BASE_URL'] ?? 'https://api.example.com',
    enableLogging: true,
    isTest: true,
  );
}
