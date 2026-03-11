import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/auth_remote_data_source.dart';
import '../datasources/local/auth_local_data_source.dart';
import '../models/user_model.dart';
import '../../core/exceptions/failures.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  
  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });
  
  @override
  Future<UserEntity> login(String username, String password) async {
    try {
      final loginResponse = await remoteDataSource.login(username, password);
      
      final user = loginResponse.user.copyWith(
        token: loginResponse.token,
      );
      
      await localDataSource.cacheUserData(user);
      await localDataSource.cacheUserToken(loginResponse.token);
      
      return UserEntity(
        id: user.id,
        username: user.username,
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
        image: user.image,
        token: user.token,
      );
    } catch (e) {
      if (e is Failure) {
        rethrow;
      }
      throw UnknownFailure('Login failed: $e');
    }
  }
  
  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      final user = await localDataSource.getCachedUserData();
      if (user != null) {
        return UserEntity(
          id: user.id,
          username: user.username,
          email: user.email,
          firstName: user.firstName,
          lastName: user.lastName,
          image: user.image,
          token: user.token,
        );
      }
      return null;
    } catch (e) {
      throw CacheFailure('Failed to get current user: $e');
    }
  }
  
  @override
  Future<void> logout() async {
    try {
      await localDataSource.clearCache();
    } catch (e) {
      throw CacheFailure('Failed to logout: $e');
    }
  }
  
  @override
  Future<bool> isLoggedIn() async {
    try {
      return await localDataSource.hasCachedData();
    } catch (e) {
      return false;
    }
  }
}
