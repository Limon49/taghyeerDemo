import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../core/exceptions/failures.dart';
import '../../../core/constants/app_constants.dart';
import '../../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUserData(UserModel user);
  Future<UserModel?> getCachedUserData();
  Future<void> cacheUserToken(String token);
  Future<String?> getCachedUserToken();
  Future<void> clearCache();
  Future<bool> hasCachedData();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  
  AuthLocalDataSourceImpl({required this.sharedPreferences});
  
  @override
  Future<void> cacheUserData(UserModel user) async {
    try {
      final userJson = jsonEncode(user.toJson());
      await sharedPreferences.setString(AppConstants.userDataKey, userJson);
    } catch (e) {
      throw CacheFailure('Failed to cache user data: $e');
    }
  }
  
  @override
  Future<UserModel?> getCachedUserData() async {
    try {
      final userString = sharedPreferences.getString(AppConstants.userDataKey);
      if (userString != null) {
        return UserModel.fromJson(jsonDecode(userString));
      }
      return null;
    } catch (e) {
      throw CacheFailure('Failed to get cached user data: $e');
    }
  }
  
  @override
  Future<void> cacheUserToken(String token) async {
    try {
      await sharedPreferences.setString(AppConstants.userTokenKey, token);
    } catch (e) {
      throw CacheFailure('Failed to cache user token: $e');
    }
  }
  
  @override
  Future<String?> getCachedUserToken() async {
    try {
      return sharedPreferences.getString(AppConstants.userTokenKey);
    } catch (e) {
      throw CacheFailure('Failed to get cached user token: $e');
    }
  }
  
  @override
  Future<void> clearCache() async {
    try {
      await sharedPreferences.remove(AppConstants.userDataKey);
      await sharedPreferences.remove(AppConstants.userTokenKey);
    } catch (e) {
      throw CacheFailure('Failed to clear cache: $e');
    }
  }
  
  @override
  Future<bool> hasCachedData() async {
    try {
      final token = await getCachedUserToken();
      final user = await getCachedUserData();
      return token != null && user != null;
    } catch (e) {
      return false;
    }
  }
}
