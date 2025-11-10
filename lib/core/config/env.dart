// FEATURE: ENV

// core/config/env.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Simple environment configuration.
/// In production you may load from --dart-define, separate files, or CI secrets.
class Env {
  final String baseUrl;
  final bool enableLogging;
  final bool isTest;
  final bool refreshTokenEnabled;

  const Env._({required this.baseUrl, required this.enableLogging, this.isTest = false,this.refreshTokenEnabled =false});

  static Env get current {
    const bool isProd =
        String.fromEnvironment('ENV', defaultValue: 'dev') == 'prod';
    return isProd ? Env.prod : Env.dev;
  }

  // default dev config
  static final dev = Env._(
    baseUrl: dotenv.env['BASE_URL'] ?? 'https://dev.example.com',
    enableLogging: true,
  );

  // production (override via --dart-define or CI)
  static final prod = Env._(
    baseUrl: dotenv.env['BASE_URL'] ?? 'https://api.example.com',
    enableLogging: false,
  );

  // production (override via --dart-define or CI)
  static final test = Env._(
    baseUrl: dotenv.env['BASE_URL'] ?? 'https://api.example.com',
    enableLogging: true,
    isTest: true,
  );
}
