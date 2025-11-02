import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_chat_demo/core/app_constants.dart';

abstract class AuthLocalSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
}

class AuthLocalSourceImpl implements AuthLocalSource {

  @override
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.AUTH_TOKEN_PREF_KEY, token);
  }

  @override
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.AUTH_TOKEN_PREF_KEY);
  }

  @override
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.AUTH_TOKEN_PREF_KEY);
  }

}
