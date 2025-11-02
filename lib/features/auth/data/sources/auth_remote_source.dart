import 'package:video_chat_demo/core/api_endpoints.dart';

import '../../../../core/network/api_client.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';

abstract class AuthRemoteSource {
  Future<LoginResponse> login(LoginRequest request);
}

class AuthRemoteSourceImpl implements AuthRemoteSource {
  final ApiClient client;
  AuthRemoteSourceImpl(this.client);

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    final response = await client.post(ApiEndpoints.LOGIN, request.toJson());
    return LoginResponse.fromJson(response);
  }
}
