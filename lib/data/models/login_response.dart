import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  final UserModel user;
  final String token;
  final int expiresInMins;
  
  const LoginResponse({
    required this.user,
    required this.token,
    required this.expiresInMins,
  });
  
  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable()
class LoginRequest {
  final String username;
  final String password;
  final int expiresInMins;
  
  const LoginRequest({
    required this.username,
    required this.password,
    required this.expiresInMins,
  });
  
  factory LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
