import 'package:get/get.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../core/exceptions/failures.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository;
  
  AuthController(this._authRepository);
  
  final Rx<UserEntity?> _user = Rx<UserEntity?>(null);
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;
  
  UserEntity? get user => _user.value;
  bool get isLoading => _isLoading.value;
  bool get isLoggedIn => _user.value != null;
  String get errorMessage => _errorMessage.value;
  
  @override
  void onInit() {
    super.onInit();
    _checkAuthStatus();
  }
  
  Future<void> _checkAuthStatus() async {
    _isLoading.value = true;
    try {
      final isLoggedIn = await _authRepository.isLoggedIn();
      if (isLoggedIn) {
        final user = await _authRepository.getCurrentUser();
        if (user != null) {
          _user.value = user;
        }
      }
    } catch (e) {
      _errorMessage.value = 'Failed to check auth status';
    } finally {
      _isLoading.value = false;
    }
  }
  
  Future<void> login(String username, String password) async {
    _isLoading.value = true;
    _errorMessage.value = '';
    
    try {
      final user = await _authRepository.login(username, password);
      _user.value = user;
      Get.snackbar('Success', 'Login successful!');
    } catch (e) {
      _errorMessage.value = _mapExceptionToMessage(e);
      Get.snackbar('Error', _errorMessage.value, backgroundColor: Get.theme.colorScheme.error);
    } finally {
      _isLoading.value = false;
    }
  }
  
  Future<void> logout() async {
    _isLoading.value = true;
    try {
      await _authRepository.logout();
      _user.value = Rx<UserEntity?>(null).value;
      Get.snackbar('Success', 'Logged out successfully!');
    } catch (e) {
      _errorMessage.value = 'Failed to logout';
      Get.snackbar('Error', _errorMessage.value, backgroundColor: Get.theme.colorScheme.error);
    } finally {
      _isLoading.value = false;
    }
  }
  
  void clearError() {
    _errorMessage.value = '';
  }
  
  String _mapExceptionToMessage(dynamic exception) {
    if (exception is Failure) {
      return exception.message;
    } else if (exception.toString().contains('SocketException')) {
      return 'No internet connection';
    } else if (exception.toString().contains('TimeoutException')) {
      return 'Request timeout';
    } else {
      return 'An unexpected error occurred';
    }
  }
}
