import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityUtils {
  static bool _isShowing = false;
  static bool _hasShownInitial = false;
  
  static Future<bool> checkConnection() async {
    try {
      final results = await Connectivity().checkConnectivity();
      final isConnected = results.isNotEmpty && 
          results.first != ConnectivityResult.none;
      
      if (!isConnected && !_isShowing) {
        _showNoInternetDialog();
      }
      
      return isConnected;
    } catch (e) {
      if (!_isShowing) {
        _showNoInternetDialog();
      }
      return false;
    }
  }
  
  static void _showNoInternetDialog() {
    _isShowing = true;
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.wifi_off, color: Colors.red),
              SizedBox(width: 8),
              Text('No Internet'),
            ],
          ),
          content: const Text(
            'Please check your internet connection and try again.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                _isShowing = false;
              },
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () async {
                Get.back();
                _isShowing = false;
                await Future.delayed(const Duration(seconds: 1));
                await checkConnection();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }
  
  static void listenToConnectivity() {
    _checkInitialConnection();
    
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      final isConnected = results.isNotEmpty && 
          results.first != ConnectivityResult.none;
      
      if (!isConnected && !_isShowing) {
        _showNoInternetDialog();
      } else if (isConnected && _isShowing) {
        Get.back();
        _isShowing = false;
        Get.snackbar(
          'Connected',
          'Internet connection restored',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    });
  }
  
  static void _checkInitialConnection() async {
    try {
      final results = await Connectivity().checkConnectivity();
      final isConnected = results.isNotEmpty && 
          results.first != ConnectivityResult.none;
      
      if (!isConnected && !_isShowing && !_hasShownInitial) {
        _hasShownInitial = true;
        _showNoInternetDialog();
      }
    } catch (e) {
    }
  }
  
  static void testConnectivity() {
    print('Testing connectivity...');
    Connectivity().checkConnectivity().then((results) {
      final isConnected = results.isNotEmpty && 
          results.first != ConnectivityResult.none;
      print('Connection status: $isConnected');
      print('Results: $results');
      if (!isConnected) {
        _showNoInternetDialog();
      }
    });
  }
}
