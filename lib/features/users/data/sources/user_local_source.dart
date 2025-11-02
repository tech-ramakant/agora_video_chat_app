import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_chat_demo/core/app_constants.dart';
import '../models/user_model.dart';

class UserLocalSource {

  Future<void> cacheUsers(List<UserModel> users) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = users.map((e) => e.toJson()).toList();
    prefs.setString(AppConstants.CATCHED_USERS_PREF_KEY, jsonEncode(jsonList));
  }

  Future<List<UserModel>> getCachedUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(AppConstants.CATCHED_USERS_PREF_KEY);
    if (data == null) return [];
    final jsonList = jsonDecode(data) as List;
    return jsonList.map((e) => UserModel.fromJson(e)).toList();
  }
}
