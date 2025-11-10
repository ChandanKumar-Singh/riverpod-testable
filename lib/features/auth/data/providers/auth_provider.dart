import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_model.dart';
import '../repositories/auth_repository_impl.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref),
);

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref ref;
  late final AuthRepository _repo;

  AuthNotifier(this.ref) : super(const AuthState()) {
    _repo = AuthRepository(ref);
    _initialize();
  }

  Future<void> _initialize() async {
    state = state.copyWith(status: AuthStatus.loading);
    final user = await _repo.loadSession();
    if (user != null && user.id.isNotEmpty) {
      state = AuthState(status: AuthStatus.authenticated, user: user);
    } else {
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> login(String email, String password) async {
    try {
      state = state.copyWith(status: AuthStatus.loading);
      final res = await _repo.login(email, password);
      if (res.isSuccess && res.data != null) {
        final user = res.data!;
        // Extract token from response or user model
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
        error: e.toString(),
      );
    }
  }
  
  Future<void> loginWithOtp(String contact, String otp) async {
    try {
      state = state.copyWith(status: AuthStatus.loading);
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
        error: e.toString(),
      );
    }
  }
  
  Future<void> sendOtp(String contact) async {
    try {
      state = state.copyWith(status: AuthStatus.loading);
      final res = await _repo.sendOtp(contact);
      if (res.isSuccess && res.data == true) {
        // OTP sent successfully
        state = state.copyWith(status: AuthStatus.initial);
      } else {
        state = AuthState(
          status: AuthStatus.unauthenticated,
          error: res.message ?? 'Failed to send OTP',
        );
      }
    } catch (e) {
      state = AuthState(
        status: AuthStatus.unauthenticated,
        error: e.toString(),
      );
    }
  }

  Future<void> logout() async {
    try {
      state = state.copyWith(status: AuthStatus.loading);
      await _repo.logout();
      await _repo.clearSession();
      state = const AuthState(status: AuthStatus.unauthenticated);
    } catch (e) {
      // Even if logout fails, clear local session
      await _repo.clearSession();
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }
}

enum AuthStatus { initial, authenticated, unauthenticated, loading }

class AuthState {
  final AuthStatus status;
  final UserModel? user;
  final String? error;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.error,
  });

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }
}
