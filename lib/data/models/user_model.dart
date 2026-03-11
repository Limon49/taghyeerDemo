import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable(
  explicitToJson: true,
  includeIfNull: false,
)
class UserModel {
  @JsonKey(defaultValue: 0)
  final int id;
  @JsonKey(defaultValue: '')
  final String username;
  @JsonKey(defaultValue: '')
  final String email;
  @JsonKey(defaultValue: '')
  final String firstName;
  @JsonKey(defaultValue: '')
  final String lastName;
  final String? image;
  final String? token;
  
  const UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.image,
    this.token,
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    print('UserModel JSON input: $json');
    
    try {
      final result = _$UserModelFromJson(json);
      print('UserModel parsed successfully: $result');
      return result;
    } catch (e) {
      print('UserModel parsing error: $e');
      print('JSON keys: ${json.keys}');
      print('JSON types: ${json.map((key, value) => MapEntry(key, value.runtimeType))}');
      rethrow;
    }
  }
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
  
  UserModel copyWith({
    int? id,
    String? username,
    String? email,
    String? firstName,
    String? lastName,
    String? image,
    String? token,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      image: image ?? this.image,
      token: token ?? this.token,
    );
  }
}
