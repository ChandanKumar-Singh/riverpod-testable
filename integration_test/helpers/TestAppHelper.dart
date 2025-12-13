// Create a simpler test helper for common scenarios
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:testable/features/auth/data/models/user_model.dart';

import '../data/auth/user.dart';
import 'auth_test_storage.dart';
import 'test_harness.dart';

class TestAppHelper {
  static Future<Widget> createAuthenticatedApp({
    UserModel? user,
    bool useRealProviders = true,
  }) async {
    final harness = TestAppHarness(
      startAuthenticated: true,
      preAuthenticatedUser: user,
    );
    await harness.setup();
    return harness.buildApp();
  }

  static Future<Widget> createUnauthenticatedApp({
    bool useRealProviders = true,
  }) async {
    final harness = TestAppHarness(startAuthenticated: false);
    await harness.setup();
    return harness.buildApp();
  }

  /// Save authenticated user state to file
  static Future<void> saveUserState(Map<String, dynamic> json) async {
    await AuthTestStorage.saveUserState(json);
  }

  /// Read user state file if exists
  static Future<UserModel?> loadUserState() async {
    // final file = File('integration_test/data/auth/user.json');
    // print(file);
    // print('File exists ${file.existsSync()}');
    // if (!file.existsSync()) return null;
    // final content = await file.readAsString();
    const content = userJsonData;
    if (content.isEmpty) return null;
    return UserModel.fromJson(content);
  }

  static ProviderContainer container(WidgetTester tester) =>
      ProviderScope.containerOf(tester.element(find.byType(Scaffold)));
}
