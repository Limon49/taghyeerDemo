import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'presentation/controllers/auth_controller.dart';
import 'presentation/controllers/product_controller.dart';
import 'presentation/controllers/post_controller.dart';
import 'presentation/controllers/theme_controller.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/home_screen.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/product_repository.dart';
import 'domain/repositories/post_repository.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/product_repository_impl.dart';
import 'data/repositories/post_repository_impl.dart';
import 'data/datasources/remote/auth_remote_data_source.dart';
import 'data/datasources/remote/product_remote_data_source.dart';
import 'data/datasources/remote/post_remote_data_source.dart';
import 'data/datasources/local/auth_local_data_source.dart';
import 'data/datasources/local/theme_local_data_source.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(MyApp(sharedPreferences: sharedPreferences));
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  
  const MyApp({super.key, required this.sharedPreferences});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Taghyeer Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      initialBinding: AppBindings(sharedPreferences),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (controller) {
        if (controller.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        if (controller.isLoggedIn) {
          return const HomeScreen();
        }
        
        return LoginScreen();
      },
    );
  }
}

class AppBindings extends Bindings {
  final SharedPreferences sharedPreferences;
  
  AppBindings(this.sharedPreferences);

  @override
  void dependencies() {
    // Repositories
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(
      remoteDataSource: AuthRemoteDataSourceImpl(client: http.Client()),
      localDataSource: AuthLocalDataSourceImpl(sharedPreferences: sharedPreferences),
    ));
    
    Get.lazyPut<ProductRepository>(() => ProductRepositoryImpl(
      remoteDataSource: ProductRemoteDataSourceImpl(client: http.Client()),
    ));
    
    Get.lazyPut<PostRepository>(() => PostRepositoryImpl(
      remoteDataSource: PostRemoteDataSourceImpl(client: http.Client()),
    ));

    // Data Sources
    Get.lazyPut<ThemeLocalDataSource>(() => ThemeLocalDataSourceImpl(
      sharedPreferences: sharedPreferences,
    ));

    // Controllers
    Get.lazyPut<AuthController>(() => AuthController(Get.find()));
    Get.lazyPut<ProductController>(() => ProductController(Get.find()));
    Get.lazyPut<PostController>(() => PostController(Get.find()));
    Get.lazyPut<ThemeController>(() => ThemeController(Get.find()));
  }
}
