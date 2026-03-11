part of 'login_response.dart';


LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      token: (json['accessToken'] as String?) ?? '',
      refreshToken: json['refreshToken'] as String?,
      id: json['id'] as int?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      gender: json['gender'] as String?,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'accessToken': instance.token,
      if (instance.refreshToken != null) 'refreshToken': instance.refreshToken,
      if (instance.id != null) 'id': instance.id,
      if (instance.username != null) 'username': instance.username,
      if (instance.email != null) 'email': instance.email,
      if (instance.firstName != null) 'firstName': instance.firstName,
      if (instance.lastName != null) 'lastName': instance.lastName,
      if (instance.gender != null) 'gender': instance.gender,
      if (instance.image != null) 'image': instance.image,
    };

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) => LoginRequest(
      username: (json['username'] as String?) ?? '',
      password: (json['password'] as String?) ?? '',
      expiresInMins: (json['expiresInMins'] as int?) ?? 60,
    );

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
      'expiresInMins': instance.expiresInMins,
    };
