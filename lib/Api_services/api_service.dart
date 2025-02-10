import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiService{
  final FlutterSecureStorage _secureStorage=FlutterSecureStorage();
  static const String baseUrl="https://admin.dev.ajasys.com/api";

  Future<bool> login(String username, String password) async {
    final url = Uri.parse("$baseUrl/stafflogin");
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "username": username,
          "password": password,
          "product_id": "1",
          "token": "zYPi153TmqFatXhJUOsrxyfgi79xhj8kQ6t9HXXr23mRcL4Sufvxdd3Y9Rmzq6DJ"
        }),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['token'] != null) {
          String token = data['token'];
          print("Token received: $token");

          await _secureStorage.write(key: 'token', value: token);
          return true;
        } else {
          print("Token missing in response");
          return false;
        }
      } else {
        print("Error: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Exception during login: $e");
      return false;
    }
  }



}