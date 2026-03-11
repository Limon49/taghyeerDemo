import 'package:flutter/foundation.dart';

class UserEntity {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String? image;
  final String? token;

  const UserEntity({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.image,
    this.token,
  });

  String get fullName => '$firstName $lastName';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserEntity &&
        listEquals(
          [id, username, email, firstName, lastName, image, token],
          [
            other.id,
            other.username,
            other.email,
            other.firstName,
            other.lastName,
            other.image,
            other.token,
          ],
        );
  }

  @override
  int get hashCode =>
      Object.hash(id, username, email, firstName, lastName, image, token);
}
