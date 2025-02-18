import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hr_app/Api_services/api_service.dart';
import 'package:hr_app/staff_HRM_module/Model/Realtomodels/Realtoleavetypesmodel.dart';
import 'package:hr_app/staff_HRM_module/Model/Realtomodels/Realtoofficelocationmodel.dart';
import 'package:hr_app/staff_HRM_module/Model/Realtomodels/Realtostaffleavesmodel.dart';
import 'package:hr_app/staff_HRM_module/Model/Realtomodels/Realtostaffprofilemodel.dart';
import '../Inquiry_Management/Model/Api Model/allInquiryModel.dart';

class UserProvider with ChangeNotifier{

  bool _isLoggedIn=false;
  bool get isLoggedIn=> _isLoggedIn;

  // final ApiService _apiService=ApiService();
  final FlutterSecureStorage _secureStorage=FlutterSecureStorage();

  Realtostaffprofilemodel? _profileData;
  Realtostaffprofilemodel? get profileData => _profileData;

  Realtoofficelocationmodel? _officeLocationData;
  Realtoofficelocationmodel? get officeLocationData => _officeLocationData;

  Realtostaffleavesmodel? _staffLeavesData;
  Realtostaffleavesmodel? get staffLeavesData => _staffLeavesData;

  Realtoleavetypesmodel? _leaveTypesData;
  Realtoleavetypesmodel? get leaveTypesData => _leaveTypesData;





  final ApiService _apiService = ApiService();

  List<Inquiry> _inquiries = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  final int _limit = 20;  // Number of items per API call

  List<Inquiry> get inquiries => _inquiries;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;


  Future<void> fetchInquiries({bool isLoadMore = false}) async {
    if (isLoadMore && !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      PaginatedInquiries? newInquiry = await _apiService.fetchInquiries(_limit, page: _currentPage);

      if (newInquiry != null) {
        if (isLoadMore) {
          _inquiries.addAll(newInquiry.inquiries); // Append new data
        } else {
          _inquiries = newInquiry.inquiries; // Replace existing data
        }

        // Update pagination state
        _hasMore = _currentPage < newInquiry.totalPages;
        if (_hasMore) _currentPage++;
      }
    } catch (e) {
      print("Error fetching inquiries: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Refresh the data
  Future<void> refreshInquiries() async {
    _currentPage = 1;
    _inquiries.clear();
    _hasMore = true;
    await fetchInquiries();
  }

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

  Future<void> fetchLeaveTypesData () async {

    _leaveTypesData = await _apiService.fetchLeaveTypesData();

    notifyListeners();

  }

  Future<bool> sendLeaveRequest ({

    required String head_name,
    required String full_name,
    required String under_team,
    required String date,
    required String reporting_to,
    required String apply_days,
    required String from_date,
    required String to_date,
    required String leave_reason,
    required String leave_type,
    required String leave_type_id,

  }) async {

    try {

      bool success = await _apiService.sendLeaveRequest(
        head_name: head_name, full_name: full_name, under_team: under_team, date: date, reporting_to: reporting_to, apply_days: apply_days, from_date: from_date, to_date: to_date, leave_reason: leave_reason, leave_type: leave_type, leave_type_id: leave_type_id
      );

      if (success) {

        notifyListeners();
        return true;

      } else {

        return false;

      }

    } catch (e) {

      return false;

    }

  }




  // Future<void> fetchInquiries({bool isLoadMore = false}) async {
  //   if (isLoadMore && _currentPage >= _totalPages) return;
  //   if (_isLoading) return;
  //
  //   _isLoading = true;
  //   notifyListeners();
  //
  //   try {
  //     PaginatedInquiries response = await _apiService.fetchInquiries(page: _currentPage);
  //
  //     if (isLoadMore) {
  //       _inquiries.addAll(response.inquiries);
  //     } else {
  //       _inquiries = response.inquiries;
  //     }
  //
  //     _totalPages = response.totalPages;
  //     _currentPage++;
  //   } catch (e) {
  //     print("Error fetching inquiries: $e");
  //   }
  //
  //   _isLoading = false;
  //   notifyListeners();
  // }

}