import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile_model.dart';
import '../repositories/user_repository_impl.dart';

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfileState>(
  (ref) => UserProfileNotifier(ref),
);

class UserProfileNotifier extends StateNotifier<UserProfileState> {
  final Ref ref;
  late final UserRepository _repo;

  UserProfileNotifier(this.ref) : super(const UserProfileState()) {
    _repo = UserRepository(ref);
  }

  Future<void> loadProfile() async {
    try {
      state = state.copyWith(status: UserProfileStatus.loading);
      final res = await _repo.getProfile();
      if (res.isSuccess && res.data != null) {
        state = UserProfileState(
          status: UserProfileStatus.loaded,
          profile: res.data,
        );
      } else {
        state = UserProfileState(
          status: UserProfileStatus.error,
          error: res.message ?? 'Failed to load profile',
        );
      }
    } catch (e) {
      state = UserProfileState(
        status: UserProfileStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> updateProfile(Map<String, dynamic> updates) async {
    try {
      state = state.copyWith(status: UserProfileStatus.loading);
      final res = await _repo.updateProfile(updates);
      if (res.isSuccess && res.data != null) {
        state = UserProfileState(
          status: UserProfileStatus.loaded,
          profile: res.data,
        );
      } else {
        state = state.copyWith(
          status: UserProfileStatus.error,
          error: res.message ?? 'Failed to update profile',
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: UserProfileStatus.error,
        error: e.toString(),
      );
    }
  }
}

enum UserProfileStatus { initial, loading, loaded, error }

class UserProfileState {
  final UserProfileStatus status;
  final UserProfileModel? profile;
  final String? error;

  const UserProfileState({
    this.status = UserProfileStatus.initial,
    this.profile,
    this.error,
  });

  UserProfileState copyWith({
    UserProfileStatus? status,
    UserProfileModel? profile,
    String? error,
  }) {
    return UserProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      error: error ?? this.error,
    );
  }
}

