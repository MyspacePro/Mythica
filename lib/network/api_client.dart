import 'dart:async';
import '../config/app_config.dart';
import 'network_exceptions.dart';

class ApiClient {
  final String baseUrl = AppConfig.instance.baseUrl;

  /// 🔹 MOCK GET REQUEST
  Future<Map<String, dynamic>> get(String endpoint) async {
    await Future.delayed(const Duration(seconds: 2));

    if (AppConfig.instance.enableLogging) {
      print("GET Request → $endpoint");
    }

    // Simulate error randomly (optional)
    if (endpoint.contains("error")) {
      throw NetworkException("Something went wrong!");
    }

    return {
      "success": true,
      "data": "Mock response from $endpoint",
    };
  }

  /// 🔹 MOCK POST REQUEST
  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    await Future.delayed(const Duration(seconds: 2));

    if (AppConfig.instance.enableLogging) {
      print("POST Request → $endpoint");
      print("Body → $body");
    }

    return {
      "success": true,
      "data": body,
    };
  }
}
