import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/datasources/local/theme_local_data_source.dart';
import '../../../core/exceptions/failures.dart';

class ThemeController extends GetxController {
  final ThemeLocalDataSource _themeLocalDataSource;
  
  ThemeController(this._themeLocalDataSource);
  
  final RxString _themeMode = 'light'.obs;
  final RxBool _isLoading = false.obs;
  
  String get themeMode => _themeMode.value;
  bool get isDarkMode => _themeMode.value == 'dark';
  bool get isLoading => _isLoading.value;
  
  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }
  
  Future<void> _loadTheme() async {
    _isLoading.value = true;
    try {
      final cachedTheme = await _themeLocalDataSource.getCachedThemeMode();
      if (cachedTheme != null) {
        _themeMode.value = cachedTheme;
      }
    } catch (e) {
      _themeMode.value = 'light';
    } finally {
      _isLoading.value = false;
    }
  }
  
  Future<void> toggleTheme() async {
    final newTheme = _themeMode.value == 'light' ? 'dark' : 'light';
    await _changeTheme(newTheme);
  }
  
  Future<void> setTheme(String themeMode) async {
    await _changeTheme(themeMode);
  }
  
  Future<void> _changeTheme(String themeMode) async {
    try {
      await _themeLocalDataSource.cacheThemeMode(themeMode);
      _themeMode.value = themeMode;
      Get.changeThemeMode(themeMode == 'dark' ? ThemeMode.dark : ThemeMode.light);
    } catch (e) {
      Get.snackbar('Error', 'Failed to change theme', backgroundColor: Get.theme.colorScheme.error);
    }
  }
}
