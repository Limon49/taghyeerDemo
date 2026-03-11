import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/exceptions/failures.dart';
import '../../../core/constants/app_constants.dart';

abstract class ThemeLocalDataSource {
  Future<void> cacheThemeMode(String themeMode);
  Future<String?> getCachedThemeMode();
}

class ThemeLocalDataSourceImpl implements ThemeLocalDataSource {
  final SharedPreferences sharedPreferences;
  
  ThemeLocalDataSourceImpl({required this.sharedPreferences});
  
  @override
  Future<void> cacheThemeMode(String themeMode) async {
    try {
      await sharedPreferences.setString(AppConstants.themeKey, themeMode);
    } catch (e) {
      throw CacheFailure('Failed to cache theme mode: $e');
    }
  }
  
  @override
  Future<String?> getCachedThemeMode() async {
    try {
      return sharedPreferences.getString(AppConstants.themeKey);
    } catch (e) {
      throw CacheFailure('Failed to get cached theme mode: $e');
    }
  }
}
