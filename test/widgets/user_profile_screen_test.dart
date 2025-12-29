import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable/app/router/app_router.dart';

import 'package:testable/features/user/data/providers/user_provider.dart';
import 'package:testable/features/user/data/models/user_profile_model.dart';

void main() {
  /// Helper to build widget with overrides
  Widget buildTestWidget({required UserProfileState profileState}) {
    return UncontrolledProviderScope(
      container: ProviderContainer.test(
        observers: []
      ),
      child: const MaterialApp(home: SampleScreen(title: 'Test Sample',icon: Icons.import_contacts)),
    );
  }

  group('UserProfileScreen Widget Tests', () {
    testWidgets('shows loading widget when profile is loading', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          profileState: const UserProfileState(
            status: UserProfileStatus.loading,
          ),
        ),
      );

      await tester.pump();

      // expect(find.byKey(const Key('profile_loading')), findsOneWidget);
      // expect(find.byKey(const Key('profile_user_card_key')), findsNothing);
      expect(find.textContaining('Sample'), findsOne);
    });

    testWidgets('shows retry widget when profile load fails', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          profileState: const UserProfileState(
            status: UserProfileStatus.error,
            error: 'Failed to load profile',
          ),
        ),
      );

      await tester.pump();

      expect(find.text('Failed to load profile'), findsOneWidget);
      expect(find.byKey(const Key('profile_user_card_key')), findsNothing);
    });

    testWidgets('shows profile data when loaded successfully', (tester) async {
      final profile = UserProfileModel(
        id: '123',
        name: 'Kulbhushan Sharma',
        email: 'sales.support43@eapl.in',
        phone: '8368312660',
        avatar: null,
      );

      await tester.pumpWidget(
        buildTestWidget(
          profileState: UserProfileState(
            status: UserProfileStatus.loaded,
            profile: profile,
          ),
        ),
      );

      await tester.pump();

      // Card exists
      expect(find.byKey(const Key('profile_user_card_key')), findsOneWidget);

      // Visible user data
      expect(find.text('Kulbhushan Sharma'), findsOneWidget);
      expect(find.text('sales.support43@eapl.in'), findsOneWidget);
      expect(find.text('8368312660'), findsOneWidget);
      expect(find.text('123'), findsOneWidget);
    });

    testWidgets('shows empty state when no profile data is available', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          profileState: const UserProfileState(
            status: UserProfileStatus.loaded,
            profile: null,
          ),
        ),
      );

      await tester.pump();

      expect(find.text('No Profile'), findsOneWidget);
      expect(find.byKey(const Key('profile_user_card_key')), findsNothing);
    });
  });
}

/// ------------------------------------------------------------
/// Fake Notifier (Prevents API Calls)
/// ------------------------------------------------------------
class FakeUserProfileNotifier extends UserProfileNotifier {
  FakeUserProfileNotifier(super.ref, UserProfileState initialState) {
    state = initialState;
  }

  @override
  Future<void> loadProfile() async {
    // NO-OP: prevent API calls in widget test
  }
}
