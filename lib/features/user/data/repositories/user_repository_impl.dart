import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/index.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/network/dio/models/api_response.dart';
import '../../../../core/di/providers.dart';
import '../models/user_profile_model.dart';

class UserRepository extends ApiService {
  final Ref ref;

  UserRepository(this.ref)
    : super(
        env: ref.read(envProvider),
        client: ref.read(httpClientProvider),
        logger: ref.read(loggerProvider),
      );

  Future<ApiResponse<UserProfileModel?>> getProfile() async {
    final res = await request<UserProfileModel?>(
      ApiConstants.userProfile,
      method: ApiMethod.get,
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
