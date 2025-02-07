import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hr_app/Api_services/api_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart';

class UserProvider with ChangeNotifier{

  bool _isLoggedIn=false;
  bool get isLoggedIn=> _isLoggedIn;

  final ApiService _apiService=ApiService();
  final FlutterSecureStorage _secureStorage=FlutterSecureStorage();

  Future<bool> login(String username,String password) async{
    bool success=await _apiService.login(username, password);

    if(success){
      _isLoggedIn=true;
      notifyListeners();
      return true;
    }else{
      _isLoggedIn=false;
      notifyListeners();
      return false;
    }

  }



}