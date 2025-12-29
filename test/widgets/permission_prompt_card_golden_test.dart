// test/permission_prompt_card_golden_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:testable/core/utils/permission_manager/permission_manager.dart';

void main() {
  testWidgets('PermissionPromptCard golden', (tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 640));
    await tester.pumpWidget(
      MaterialApp(
        home: PermissionPromptCard(
          title: 'Camera Access',
          description: 'We need camera access',
          onAllow: () {},
          onDeny: () {},
        ),
      ),
    );

    await expectLater(
      find.byType(PermissionPromptCard),
      matchesGoldenFile('goldens/permission_prompt_card.png'),
    );
  });
}
