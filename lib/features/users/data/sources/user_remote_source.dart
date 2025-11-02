import 'package:video_chat_demo/core/api_endpoints.dart';

import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';

class UserRemoteSource {
  final ApiClient api;

  UserRemoteSource(this.api);

  Future<List<UserModel>> getUsers(int page) async {
    final data = await api.get('${ApiEndpoints.USERS}?page=$page');
    final List list = data['data'];
    return list.map((e) => UserModel.fromJson(e)).toList();
  }
}