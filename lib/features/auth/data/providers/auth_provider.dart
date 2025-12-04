// presentation/auth_notifier.dart (FIXED VERSION)
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable/features/auth/data/models/user_model.dart';
import 'package:testable/features/auth/data/repositories/auth_repository_impl.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref),
);

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this.ref, {AuthRepository? repo})
    : _repo = repo ?? ref.read(authRepositoryProvider),
      super(const AuthState());

  final Ref ref;
  final AuthRepository _repo;

  Future<void> initialize() async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final user = await _repo.loadSession();
      if (user != null && user.id.isNotEmpty) {
        state = AuthState(status: AuthStatus.authenticated, user: user);
      } else {
        state = const AuthState(status: AuthStatus.unauthenticated);
      }
    } catch (e) {
      state = AuthState(
        status: AuthStatus.unauthenticated,
        error: e.toString(),
      );
    }
  }

  Future<void> login(String email, String password) async {
    try {
      state = state.copyWith(
        status: AuthStatus.loading,
        error: null,
      ); // FIX: Clear previous error
      final res = await _repo.login(email, password);
      if (res.isSuccess && res.data != null) {
        final user = res.data!;
        final token = user.token;
        await _repo.saveSession(user, token: token);
        state = AuthState(status: AuthStatus.authenticated, user: user);
      } else {
        state = AuthState(
          status: AuthStatus.unauthenticated,
          error: res.message ?? 'Login failed',
        );
      }
    } catch (e) {
      state = AuthState(
        status: AuthStatus.unauthenticated,
        error: e.toString(), // FIX: Ensure error is set
      );
    }
  }

  Future<void> loginWithOtp(String contact, String otp) async {
    try {
      state = state.copyWith(
        status: AuthStatus.loading,
        error: null,
      ); // FIX: Clear previous error
      final res = await _repo.verifyOTP(contact, otp);
      if (res.isSuccess && res.data != null) {
        final user = res.data!;
        final token = user.token;
        await _repo.saveSession(user, token: token);
        state = AuthState(status: AuthStatus.authenticated, user: user);
      } else {
        state = AuthState(
          status: AuthStatus.unauthenticated,
          error: res.message ?? 'OTP verification failed',
        );
      }
    } catch (e) {
      state = AuthState(
        status: AuthStatus.unauthenticated,
        error: e.toString(), // FIX: Ensure error is set
      );
    }
  }

  Future<String?> sendOtp(String contact) async {
    try {
      state = state.copyWith(status: AuthStatus.loading, error: null);
      final res = await _repo.sendOtp(contact);
      if (res.isSuccess && res.data?.$1 == true && res.data!.$2.isNotEmpty) {
        state = state.copyWith(status: AuthStatus.initial);
        return res.data!.$2['contact'] as String;
      } else {
        state = AuthState(
          status: AuthStatus.unauthenticated,
          error: res.message ?? 'Failed to send OTP',
        );
      }
    } catch (e, stack) {
      state = AuthState(
        status: AuthStatus.unauthenticated,
        error: e.toString(),
      );
    }
    return null;
  }

  Future<void> logout() async {
    try {
      state = state.copyWith(status: AuthStatus.loading, error: null);
      await _repo.clearSession();
      state = const AuthState(status: AuthStatus.unauthenticated);
    } catch (e, st) {
      state = AuthState(
        status: AuthStatus.unauthenticated,
        error: e.toString(),
      );
    }
  }
}

enum AuthStatus { initial, authenticated, unauthenticated, loading }

class AuthState {
  const AuthState({this.status = AuthStatus.initial, this.user, this.error});
  final AuthStatus status;
  final UserModel? user;
  final String? error;

  AuthState copyWith({AuthStatus? status, UserModel? user, String? error}) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error, // FIX: Allow clearing error by passing null
    );
  }
}
