import 'dart:convert';
import 'dart:io';

import 'package:testable/features/auth/data/models/user_model.dart';

class AuthTestStorage {
  static const String _fileName = 'user.json';

  /// Returns a safe writable directory for tests
  static Future<String> _getTestDir() async {
    final dir = Directory.systemTemp.createTempSync('flutter_test_auth_');
    return dir.path;
  }

  static Future<File> _getUserFile() async {
    final path = await _getTestDir();
    final file = File('$path/$_fileName');
    return file;
  }

  static Future<void> saveUserState(Map<String, dynamic> json) async {
    final file = await _getUserFile();
    await file.writeAsString(jsonEncode(json), flush: true);
    print('💾 Saved user data at: ${file.path}');
  }

  static Future<UserModel?> loadUserState() async {
    final file = await _getUserFile();
    if (!file.existsSync()) return null;
    final content = await file.readAsString();
    print(content);
    if (content.isEmpty) return null;
    return UserModel.fromJson(jsonDecode(content) as Map<String, dynamic>);
  }
}
