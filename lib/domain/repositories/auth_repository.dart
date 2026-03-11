import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String username, String password);
  Future<UserEntity?> getCurrentUser();
  Future<void> logout();
  Future<bool> isLoggedIn();
}
