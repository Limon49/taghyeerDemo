import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';

part 'login_response.g.dart';

@JsonSerializable(
  explicitToJson: true,
  includeIfNull: false,
)
class LoginResponse {
  @JsonKey(name: 'accessToken')
  final String token;
  final String? refreshToken;
  final int? id;
  final String? username;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final String? image;
  
  const LoginResponse({
    required this.token,
    this.refreshToken,
    this.id,
    this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.gender,
    this.image,
  });
  
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    print('LoginResponse JSON input: $json');
    
    try {
      final result = _$LoginResponseFromJson(json);
      print('LoginResponse parsed successfully: $result');
      return result;
    } catch (e) {
      print('LoginResponse parsing error: $e');
      print('JSON keys: ${json.keys}');
      print('JSON types: ${json.map((key, value) => MapEntry(key, value.runtimeType))}');
      rethrow;
    }
  }
  
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
  
  // Convert to UserModel for compatibility
  UserModel get user {
    return UserModel(
      id: id ?? 0,
      username: username ?? '',
      email: email ?? '',
      firstName: firstName ?? '',
      lastName: lastName ?? '',
      image: image,
      token: token,
    );
  }
}

@JsonSerializable(
  explicitToJson: true,
  includeIfNull: false,
)
class LoginRequest {
  final String username;
  final String password;
  @JsonKey(defaultValue: 60)
  final int expiresInMins;
  
  const LoginRequest({
    required this.username,
    required this.password,
    required this.expiresInMins,
  });
  
  factory LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
