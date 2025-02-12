import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hr_app/Api_services/api_service.dart';
import 'package:hr_app/staff_HRM_module/Model/Realtomodels/Realtoofficelocationmodel.dart';
import 'package:hr_app/staff_HRM_module/Model/Realtomodels/Realtostaffleavesmodel.dart';
import 'package:hr_app/staff_HRM_module/Model/Realtomodels/Realtostaffprofilemodel.dart';

class UserProvider with ChangeNotifier{

  bool _isLoggedIn=false;
  bool get isLoggedIn=> _isLoggedIn;

  final ApiService _apiService=ApiService();
  final FlutterSecureStorage _secureStorage=FlutterSecureStorage();

  Realtostaffprofilemodel? _profileData;
  Realtostaffprofilemodel? get profileData => _profileData;

  Realtoofficelocationmodel? _officeLocationData;
  Realtoofficelocationmodel? get officeLocationData => _officeLocationData;

  Realtostaffleavesmodel? _staffLeavesData;
  Realtostaffleavesmodel? get staffLeavesData => _staffLeavesData;

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

  Future<void> fetchProfileData () async {

    _profileData = await _apiService.fetchProfileData();

    notifyListeners();

  }

  Future<void> fetchOfficeLocationData () async {

    _officeLocationData = await _apiService.fetchOfficeLocationData();

    notifyListeners();

  }

  Future<void> fetchStaffLeavesData () async {

    _staffLeavesData = await _apiService.fetchStaffLeavesData();

    notifyListeners();

  }

}