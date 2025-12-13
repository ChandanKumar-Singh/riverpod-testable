import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable/core/constants/index.dart';
import 'package:testable/core/services/api_service.dart';
import 'package:testable/core/network/dio/models/api_response.dart';
import 'package:testable/core/di/providers.dart';
import 'package:testable/features/user/data/models/user_profile_model.dart';

final userRepoProvider = Provider<UserRepository>((ref) => UserRepository(ref));

class UserRepository extends ApiService {
  UserRepository(this.ref)
    : super(
        env: ref.read(envProvider),
        client: ref.read(httpClientProvider),
        logger: ref.read(loggerProvider),
      );
  final Ref ref;

  Future<ApiResponse<UserProfileModel?>> getProfile() async {
    final res = await request<UserProfileModel?>(
      ApiConstants.userProfile,
      requiresAuth: true,
      fromJson: (data) {
        if (data.containsKey('user')) {
          return UserProfileModel.fromJson(
            data['user'] as Map<String, dynamic>,
          );
        } else if (data.containsKey('data')) {
          final userData = data['data'];
          if (userData is Map<String, dynamic>) {
            return UserProfileModel.fromJson(userData);
          }
        }
        return UserProfileModel.fromJson(data);
      },
    );
    return res;
  }

  Future<ApiResponse<UserProfileModel?>> updateProfile(
    Map<String, dynamic> updates,
  ) async {
    final res = await request<UserProfileModel?>(
      ApiConstants.userUpdate,
      method: ApiMethod.put,
      body: updates,
      requiresAuth: true,
      fromJson: (data) {
        if (data.containsKey('user')) {
          return UserProfileModel.fromJson(
            data['user'] as Map<String, dynamic>,
          );
        } else if (data.containsKey('data')) {
          final userData = data['data'];
          if (userData is Map<String, dynamic>) {
            return UserProfileModel.fromJson(userData);
          }
        }
        return UserProfileModel.fromJson(data);
      },
    );
    return res;
  }
}
