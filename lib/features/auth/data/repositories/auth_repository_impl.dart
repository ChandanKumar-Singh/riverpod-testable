import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable/core/constants/index.dart';
import 'package:testable/core/services/storage_adapter.dart';
import 'package:testable/core/services/api_service.dart';
import 'package:testable/core/network/dio/models/api_response.dart';
import 'package:testable/core/di/providers.dart';
import 'package:testable/features/auth/data/models/user_model.dart';

class AuthRepository extends ApiService {
  AuthRepository(this.ref)
    : super(
        env: ref.read(envProvider),
        client: ref.read(httpClientProvider),
        logger: ref.read(loggerProvider),
      );
  final Ref ref;

  StorageAdapter get storage => ref.read(storageProvider);

  Future<ApiResponse<(bool, Map<String, dynamic>)>> sendOtp(
    String contact,
  ) async {
    final res = await request<(bool, Map<String, dynamic>)>(
      ApiConstants.authSendOtp,
      body: {'code': contact},
      requiresAuth: false,
      fromJson: (data) =>
          (data['otp_sent'] == true || data['success'] == true, data),
    );
    return res;
  }

  Future<ApiResponse<UserModel?>> verifyOTP(String contact, String otp) async {
    final res = await request<UserModel?>(
      ApiConstants.authVerifyOTP,
      body: {'contact': contact, 'otp': otp},
      requiresAuth: false,
      fromJson: (data) {
        // Handle response structure - might have user in data.user or data.data
        if (data.containsKey('user')) {
          return UserModel.fromJson(data['user'] as Map<String, dynamic>);
        } else if (data.containsKey('data')) {
          final userData = data['data'];
          if (userData is Map<String, dynamic>) {
            return UserModel.fromJson(userData);
          }
        }
        return UserModel.fromJson(data);
      },
    );
    return res;
  }

  Future<ApiResponse<UserModel?>> login(String email, String password) async {
    final res0 = await sendOtp(email);
    if (res0.isSuccess) {
      final user = verifyOTP(email, password);
      return user;
    }
    return ApiResponse.error(message: res0.message);
    // return;

    final res = await request<UserModel?>(
      ApiConstants.authLogin,
      method: ApiMethod.post,
      body: {'email': email, 'password': password},
      requiresAuth: false,
      fromJson: (data) {
        // Handle response structure - might have user in data.user or data.data
        if (data.containsKey('user')) {
          final userData = data['user'] as Map<String, dynamic>;
          // Extract token if present in response
          final token = data['token'] as String?;
          if (token != null) {
            userData['token'] = token;
          }
          return UserModel.fromJson(userData);
        } else if (data.containsKey('data')) {
          final userData = data['data'];
          if (userData is Map<String, dynamic>) {
            final token = data['token'] as String?;
            if (token != null) {
              userData['token'] = token;
            }
            return UserModel.fromJson(userData);
          }
        }
        // Try to extract token from root level
        final token = data['token'] as String?;
        final userData = Map<String, dynamic>.from(data);
        if (token != null) {
          userData['token'] = token;
        }
        return UserModel.fromJson(userData);
      },
    );
    return res;
  }

  Future<ApiResponse<bool>> logout() async {
    final res = await request<bool>(
      ApiConstants.authLogout,
      method: ApiMethod.post,
      requiresAuth: true,
      fromJson: (data) => data['success'] == true || data['logged_out'] == true,
    );
    return res;
  }

  Future<UserModel?> loadSession() async {
    try {
      final json = await storage.getMap(StorageKeys.user);
      final token = await storage.getString(StorageKeys.token, secure: true);
      if (json != null && json.isNotEmpty) {
        try {
          final user = UserModel.fromJson(json);
          // If token is stored separately, use it
          if (token != null && token.isNotEmpty) {
            return UserModel(
              id: user.id,
              name: user.name,
              email: user.email,
              token: token,
            );
          }
          return user;
        } catch (e) {
          logger.e(
            'Failed to parse user from session',
            e: e,
            tag: 'AuthRepository',
          );
          await clearSession();
          return null;
        }
      }
      // If no user data but token exists, clear it
      if (token != null && token.isNotEmpty) {
        await clearSession();
      }
      return null;
    } catch (e) {
      logger.e('Failed to load session', e: e, tag: 'AuthRepository');
      return null;
    }
  }

  Future<void> saveSession(UserModel user, {String? token}) async {
    try {
      await storage.save(StorageKeys.user, user.toJson());
      // Store token securely
      final tokenToSave = token ?? user.token;
      if (tokenToSave != null && tokenToSave.isNotEmpty) {
        await storage.save(StorageKeys.token, tokenToSave, secure: true);
      }
    } catch (e) {
      logger.e('Failed to save session', e: e, tag: 'AuthRepository');
      rethrow;
    }
  }

  Future<void> clearSession() async {
    try {
      await storage.delete(StorageKeys.user);
      await storage.delete(StorageKeys.token, secure: true);
    } catch (e) {
      logger.e('Failed to clear session', e: e, tag: 'AuthRepository');
    }
  }

  Future<String?> getToken() async {
    try {
      return await storage.getString(StorageKeys.token, secure: true);
    } catch (e) {
      logger.e('Failed to get token', e: e, tag: 'AuthRepository');
      return null;
    }
  }
}
