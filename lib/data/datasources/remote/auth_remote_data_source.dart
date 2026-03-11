import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/exceptions/failures.dart';
import '../../../core/constants/app_constants.dart';
import '../../models/login_response.dart';
import '../../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponse> login(String username, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  
  AuthRemoteDataSourceImpl({required this.client});
  
  @override
  Future<LoginResponse> login(String username, String password) async {
    final response = await client.post(
      Uri.parse('${AppConstants.baseUrl}${AppConstants.loginEndpoint}'),
      headers: {'Content-Type': AppConstants.contentTypeHeader},
      body: jsonEncode(LoginRequest(
        username: username,
        password: password,
        expiresInMins: AppConstants.defaultExpiresInMins,
      ).toJson()),
    );
    
    if (response.statusCode == 200) {
      return LoginResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw ServerFailure('Invalid credentials');
    } else {
      throw ServerFailure('Login failed: ${response.statusCode}');
    }
  }
}
