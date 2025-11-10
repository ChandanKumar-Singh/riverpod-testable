import 'package:flutter_test/flutter_test.dart';
import 'package:testable/features/user/data/providers/user_provider.dart';
import 'package:testable/features/user/data/models/user_profile_model.dart';

void main() {
  group('UserProfileState', () {
    test('initial state should have initial status', () {
      const state = UserProfileState();
      expect(state.status, UserProfileStatus.initial);
      expect(state.profile, isNull);
      expect(state.error, isNull);
    });

    test('copyWith should update only provided fields', () {
      const initialState = UserProfileState();
      final profile = UserProfileModel(
        id: '1',
        name: 'Test User',
        email: 'test@example.com',
        createdAt: DateTime.now(),
      );
      
      final updatedState = initialState.copyWith(
        status: UserProfileStatus.loaded,
        profile: profile,
      );
      
      expect(updatedState.status, UserProfileStatus.loaded);
      expect(updatedState.profile, profile);
      expect(updatedState.error, isNull);
    });

    test('copyWith should preserve existing fields when not provided', () {
      final profile = UserProfileModel(
        id: '1',
        name: 'Test User',
        createdAt: DateTime.now(),
      );
      final state = UserProfileState(
        status: UserProfileStatus.loaded,
        profile: profile,
        error: 'Previous error',
      );
      
      final updatedState = state.copyWith(status: UserProfileStatus.loading);
      
      expect(updatedState.status, UserProfileStatus.loading);
      expect(updatedState.profile, profile);
      expect(updatedState.error, 'Previous error');
    });
  });

  group('UserProfileStatus', () {
    test('should have all expected values', () {
      expect(UserProfileStatus.values.length, 4);
      expect(UserProfileStatus.values, contains(UserProfileStatus.initial));
      expect(UserProfileStatus.values, contains(UserProfileStatus.loading));
      expect(UserProfileStatus.values, contains(UserProfileStatus.loaded));
      expect(UserProfileStatus.values, contains(UserProfileStatus.error));
    });
  });
}


