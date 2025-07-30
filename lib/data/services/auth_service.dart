import 'package:task_manager_project/data/models/user_model.dart';
import 'package:task_manager_project/data/network/network_service.dart';
import 'package:task_manager_project/data/utils/api_config.dart';

class AuthService {
  static Future<Map<String, dynamic>> register(User user) async {
    return await NetworkService.post(
      url: '${ApiConfig.baseUrl}${ApiConfig.registration}',
      body: user.toJson(),
    );
  }

  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await NetworkService.post(
      url: '${ApiConfig.baseUrl}${ApiConfig.login}',
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response['status'] == 'success' && response['token'] != null) {
      await NetworkService.saveToken(response['token']);
    }

    return response;
  }

  static Future<Map<String, dynamic>> getProfile() async {
    return await NetworkService.get(
      url: '${ApiConfig.baseUrl}${ApiConfig.profileDetails}',
      requiresAuth: true,
    );
  }

  static Future<Map<String, dynamic>> updateProfile(User user) async {
    return await NetworkService.post(
      url: '${ApiConfig.baseUrl}${ApiConfig.profileUpdate}',
      body: user.toJson(),
      requiresAuth: true,
    );
  }

  static Future<Map<String, dynamic>> verifyEmailForReset(String email) async {
    return await NetworkService.get(
      url: '${ApiConfig.baseUrl}${ApiConfig.recoverVerifyEmail}/$email',
    );
  }

  static Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
    return await NetworkService.get(
      url: '${ApiConfig.baseUrl}${ApiConfig.recoverVerifyOtp}/$email/$otp',
    );
  }

  static Future<Map<String, dynamic>> resetPassword(String email, String otp, String password) async {
    return await NetworkService.post(
      url: '${ApiConfig.baseUrl}${ApiConfig.recoverResetPassword}',
      body: {
        'email': email,
        'OTP': otp,
        'password': password,
      },
    );
  }

  static Future<void> logout() async {
    await NetworkService.clearToken();
  }
}
