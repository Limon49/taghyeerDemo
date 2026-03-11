class AppConstants {
  // API Endpoints
  static const String baseUrl = 'https://dummyjson.com';
  static const String loginEndpoint = '/auth/login';
  static const String productsEndpoint = '/products';
  static const String postsEndpoint = '/posts';
  
  // Pagination
  static const int defaultLimit = 10;
  static const int defaultSkip = 0;
  
  // Login Credentials
  static const String defaultUsername = 'emilys';
  static const String defaultPassword = 'emilyspass';
  static const int defaultExpiresInMins = 30;
  
  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String themeKey = 'theme_mode';
  
  // Request Headers
  static const String contentTypeHeader = 'application/json';
  static const String authorizationHeader = 'Authorization';
}
