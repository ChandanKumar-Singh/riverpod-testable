import 'package:flutter_test/flutter_test.dart';
import 'package:testable/features/auth/data/providers/auth_provider.dart';
import 'package:testable/features/auth/data/models/user_model.dart';

void main() {
  group('AuthState', () {
    test('initial state should have initial status', () {
      const state = AuthState();
      expect(state.status, AuthStatus.initial);
      expect(state.user, isNull);
      expect(state.error, isNull);
    });

    test('copyWith should update only provided fields', () {
      const initialState = AuthState();
      final user = UserModel(id: '1', name: 'Test User', email: 'test@example.com');
      
      final updatedState = initialState.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      );
      
      expect(updatedState.status, AuthStatus.authenticated);
      expect(updatedState.user, user);
      expect(updatedState.error, isNull);
    });

    test('copyWith should preserve existing fields when not provided', () {
      final user = UserModel(id: '1', name: 'Test User');
      final state = AuthState(
        status: AuthStatus.authenticated,
        user: user,
        error: 'Previous error',
      );
      
      final updatedState = state.copyWith(status: AuthStatus.loading);
      
      expect(updatedState.status, AuthStatus.loading);
      expect(updatedState.user, user);
      expect(updatedState.error, 'Previous error');
    });
  });

  group('AuthStatus', () {
    test('should have all expected values', () {
      expect(AuthStatus.values.length, 4);
      expect(AuthStatus.values, contains(AuthStatus.initial));
      expect(AuthStatus.values, contains(AuthStatus.authenticated));
      expect(AuthStatus.values, contains(AuthStatus.unauthenticated));
      expect(AuthStatus.values, contains(AuthStatus.loading));
    });
  });
}

