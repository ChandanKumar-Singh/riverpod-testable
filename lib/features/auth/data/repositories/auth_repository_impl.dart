import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable/core/constants/index.dart';
import 'package:testable/core/services/storage_adapter.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/network/dio/models/api_response.dart';
import '../../../../core/di/providers.dart';
import '../models/user_model.dart';

class AuthRepository extends ApiService {
  final Ref ref;

  StorageAdapter get storage => ref.read(storageProvider);

  AuthRepository(this.ref)
    : super(
        env: ref.read(envProvider),
        client: ref.read(httpClientProvider),
        logger: ref.read(loggerProvider),
      );

  Future<ApiResponse<bool>> sendOtp(String code) async {
    final res = await request<bool>(
      ApiConstants.authLogin,
      body: {'code': code},
      fromJson: (data) => data['otp_sent'] == true,
    );
    return res;
  }

  Future<ApiResponse<UserModel?>> verifyOTP(String code, String otp) async {
    final res = await request<UserModel?>(
      ApiConstants.authVerifyOTP,
      body: {'contact': code, 'otp': otp},
      fromJson: (data) =>  UserModel.fromJson(data),
    );
    return res;
  }

  Future<ApiResponse<UserModel?>> login(String email, String password) async {
    final res = await request<UserModel?>(
      ApiConstants.authLogin,
      body: {'email': email, 'password': password},
      fromJson: (data) => UserModel.fromJson(data),
    );
    return res;
  }

  Future<ApiResponse<bool>> logout() async {
    final res = await request('/auth/logout');
    return ApiResponse.success(data: res.isSuccess);
  }

  Future<UserModel?> loadSession() async {
    final json = await storage.getMap(StorageKeys.user);
    final token = await storage.getString(StorageKeys.token);
    await Future.delayed(Duration(seconds: 2));
    if ((token ?? '').isNotEmpty && json != null && json.isNotEmpty) {
      return UserModel.fromJson(json);
    }
    clearSession();
    return null;
  }

  Future<void> saveSession(UserModel user, {String? token}) async {
    await storage.save(StorageKeys.user, user.toJson());
    if (token != null) await storage.save(StorageKeys.token, token);
  }

  Future<void> clearSession() async {
    await storage.delete(StorageKeys.user);
    await storage.delete(StorageKeys.token);
  }
}
