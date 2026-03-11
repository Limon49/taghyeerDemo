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
    try {
      print('Attempting login with username: $username');
      
      final response = await client.post(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.loginEndpoint}'),
        headers: {'Content-Type': AppConstants.contentTypeHeader},
        body: jsonEncode(LoginRequest(
          username: username,
          password: password,
          expiresInMins: AppConstants.defaultExpiresInMins,
        ).toJson()),
      );
      
      print('Login Response Status: ${response.statusCode}');
      print('Login Response Body type: ${response.body.runtimeType}');
      print('Login Response Body: ${response.body}');
      
      if (response.statusCode != 200) {
        if (response.statusCode == 401) {
          throw ServerFailure('Invalid credentials');
        } else {
          throw ServerFailure('Login failed: ${response.statusCode} - ${response.body}');
        }
      }
      
      // At this point, status code is 200
      final responseBody = response.body;
      
      if (responseBody.isEmpty) {
        throw ServerFailure('Empty response from server');
      }
      
      if (responseBody is ServerFailure) {
        throw responseBody;
      }
      
      final jsonString = responseBody.toString();
      print('decode JSON: $jsonString');
      
      final decodedJson = jsonDecode(jsonString);
      print('Decoded JSON: $decodedJson');
      print('Decoded JSON type: ${decodedJson.runtimeType}');
      
      if (decodedJson == null) {
        throw ServerFailure('Invalid response from server');
      }
      
      if (decodedJson is! Map<String, dynamic>) {
        throw ServerFailure('Invalid response format: expected object, got ${decodedJson.runtimeType}');
      }
      
      if (!decodedJson.containsKey('accessToken')) {
        throw ServerFailure('Missing accessToken in response');
      }
      
      if (!decodedJson.containsKey('id')) {
        throw ServerFailure('Missing user id in response');
      }
      
      return LoginResponse.fromJson(decodedJson);
      
    } on FormatException catch (e) {
      print('JSON Format Error: $e');
      throw ServerFailure('Invalid JSON format: ${e.message}');
    } catch (e) {
      print('Login Error: $e');
      print('Error type: ${e.runtimeType}');
      
      if (e is ServerFailure) {
        rethrow;
      } else if (e.toString().contains('SocketException')) {
        throw NetworkFailure('No internet connection');
      } else if (e.toString().contains('TimeoutException')) {
        throw NetworkFailure('Request timeout');
      } else {
        throw UnknownFailure('Login failed: ${e.toString()}');
      }
    }
  }
}
