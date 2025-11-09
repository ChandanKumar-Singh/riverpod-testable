import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable/core/network/dio/models/api_response.dart';

import '../../di/providers.dart';
import '../api_service.dart';

class AuthRepository extends ApiService {
  final Ref ref;
  AuthRepository(this.ref)
    : super(
        env: ref.read(envProvider),
        client: ref.read(httpClientProvider),
        logger: ref.read(loggerProvider),
      );

  Future<bool> login(String username, String password) async {
    final res = await request(
      '/login',
      body: {'username': username, 'password': password},
      fromJson: (response) => true,
    );
    return res.isSuccess;
  }
}
