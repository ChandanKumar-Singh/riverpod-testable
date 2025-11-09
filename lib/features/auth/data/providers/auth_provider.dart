import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio/models/api_response.dart';
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
    state = state.copyWith(status: AuthStatus.loading);
    final res = await _repo.sendOtp('2503');
    if (res.isSuccess && res.data == true) {
      final res0 = await _repo.verifyOTP('2503', '7777');
      if (res0.isSuccess) {
        await _repo.saveSession(res0.data!);
        // state = AuthState(status: AuthStatus.authenticated, user: res.data);
      } else {
        state = const AuthState(status: AuthStatus.unauthenticated);
      }
    }
  }

  Future<void> logout() async {
    await _repo.clearSession();
    await _repo.logout();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

enum AuthStatus { initial, authenticated, unauthenticated, loading }

class AuthState {
  final AuthStatus status;
  final UserModel? user;

  const AuthState({this.status = AuthStatus.initial, this.user});

  AuthState copyWith({AuthStatus? status, UserModel? user}) {
    return AuthState(status: status ?? this.status, user: user ?? this.user);
  }
}
