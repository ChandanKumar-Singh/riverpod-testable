part of 'index.dart';

/// Base URLs and endpoints
class ApiConstants {
  static String baseUrl = Env.current.baseUrl;
  static String authLogin = 'auth/send/otp';
  static String authVerifyOTP = 'auth/verify/otp';
  static String authLogout = '/auth/logout';
  static String userProfile = '/user/profile';
  static String health = '/health';
}
