import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as https;

class ApiService{
  final FlutterSecureStorage _secureStorage=FlutterSecureStorage();
  static const String baseUrl="https://admin.dev.ajasys.com/api/stafflogin";

  Future<bool> login(String username,String password) async{
    final url=Uri.parse("$baseUrl/login");
    try{
      final response=await https.post(
        url,headers: {
          'Content-Type':'application/json',
      },
          body: jsonEncode({
            'username':username,
            'password':password,
            'product_id':'1',
            'token':"zYPi153TmqFatXhJUOsrxyfgi79xhj8kQ6t9HXXr23mRcL4Sufvxdd3Y9Rmzq6DJ",
          }),
      );
      if(response.statusCode==200){
        final data=jsonDecode(response.body);
        String token=data['token'];
        print(token);


        await _secureStorage.write(key: 'token', value: token);
        return true;
      }else{
        return false;
      }


    }
    catch(e){
      print(e);
      return false;
    }
  }


}