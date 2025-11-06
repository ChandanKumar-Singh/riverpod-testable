import 'api_service.dart';

class AuthRepository extends ApiService {
  AuthRepository(super.client);

  Future<bool> login(String username, String password) async {
    final res = await request(
      '/login',
      data: {'username': username, 'password': password},
      onSuccess: (response) => response,
    );
    return res.isSuccess;
  }
}
