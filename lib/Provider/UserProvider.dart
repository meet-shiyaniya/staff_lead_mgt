import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hr_app/Api_services/api_service.dart';
import 'package:hr_app/Inquiry_Management/Model/Api%20Model/add_Lead_Model.dart';
import 'package:hr_app/staff_HRM_module/Model/Realtomodels/Realtoleavetypesmodel.dart';
import 'package:hr_app/staff_HRM_module/Model/Realtomodels/Realtoofficelocationmodel.dart';
import 'package:hr_app/staff_HRM_module/Model/Realtomodels/Realtostaffattendancemodel.dart';
import 'package:hr_app/staff_HRM_module/Model/Realtomodels/Realtostaffleavesmodel.dart';
import 'package:hr_app/staff_HRM_module/Model/Realtomodels/Realtostaffprofilemodel.dart';
import '../Inquiry_Management/Model/Api Model/allInquiryModel.dart';

class UserProvider with ChangeNotifier {

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

  Realtostaffattendancemodel? _staffAttendanceData;
  Realtostaffattendancemodel? get staffAttendanceData => _staffAttendanceData;

  final ApiService _apiService = ApiService();

  List<Inquiry> _inquiries = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  final int _limit = 20;  // Number of items per API call

  List<Inquiry> get inquiries => _inquiries;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  PaginatedInquiries? paginatedInquiries;

  Map<String, int> _stageCounts = {};
  Map<String, int> get stageCounts => _stageCounts;

  AddLeadDataModel? _dropdownData;
  bool _isLoadingDropdown = false;

  AddLeadDataModel? get dropdownData => _dropdownData;
  bool get isLoadingDropdown => _isLoadingDropdown;
  Future<void> fetchInquiries({
    bool isLoadMore = false,
    int status = 0,
    String search = '',
  }) async {
    if (!isLoadMore) {
      _currentPage = 1;
      _inquiries.clear();
      _stageCounts.clear();
    }
    if (isLoadMore && !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.fetchInquiries(
        _limit,
        status,
        search: search,
        page: _currentPage,
      );

      if (response != null) {
        paginatedInquiries = response;

        if (isLoadMore) {
          _inquiries.addAll(response.inquiries);
        } else {
          _inquiries = List.from(response.inquiries);
        }

        _hasMore = _currentPage < response.totalPages!;
        if (_hasMore) _currentPage++;

        // Update stage counts
        _stageCounts = {
          "Fresh": getStageCount(status, "Fresh", response),
          "Contacted": getStageCount(status, "Contacted", response),
          "Appointment": getStageCount(status, "Appointment", response),
          "Trial": getStageCount(status, "Visited", response),
          "Negotiation": getStageCount(status, "Negotiation", response),
          "Feedback": getStageCount(status, "Feedback", response),
          "Re-Appointment": getStageCount(status, "Re-Appointment", response),
          "Re-Visited": getStageCount(status, "Re-Visited", response),
          "Converted": getStageCount(status, "Converted", response),
        };

        print("Stage Counts: $_stageCounts");
      } else {
        _hasMore = false;
      }
    } catch (e) {
      print("Error fetching inquiries: $e");
      _hasMore = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  int getStageCount(int status, String stage, PaginatedInquiries data) {
    switch (status) {
      case 1: // Live
        switch (stage) {
          case "Fresh":
            return data.liveFresh ?? 0; // Now uses data.liveFresh
          case "Contacted":
            return data.liveContacted ?? 0; // Now uses data.liveContacted
          case "Appointment":
            return data.liveAppointment ?? 0;
          case "Visited":
            return data.liveVisited ?? 0;
          case "Negotiation":
            return data.liveNegotiation ?? 0;
          case "Feedback":
            return data.liveFeedback ?? 0;
          case "Re-Appointment":
            return data.liveReAppointment ?? 0;
          case "Re-Visited":
            return data.liveReVisited ?? 0;
          case "Converted":
            return data.liveConverted ?? 0;
          default:
            return 0;
        }
      case 2: // Dismiss
        switch (stage) {
          case "Fresh":
            return data.dismissFresh ?? 0; // Now uses data.dismissFresh
          case "Contacted":
            return data.dismissContacted ?? 0; // Now uses data.dismissContacted
          case "Appointment":
            return data.dismissAppointment ?? 0;
          case "Visited":
            return data.dismissVisited ?? 0;
          case "Negotiation":
            return data.dismissNegotiation ?? 0;
          case "Feedback":
            return data.dismissFeedback ?? 0;
          case "Re-Appointment":
            return data.dismissReAppointment ?? 0;
          case "Re-Visited":
            return data.dismissReVisited ?? 0;
          case "Converted":
            return data.dismissConverted ?? 0;
          default:
            return 0;
        }

      case 3: // Dismissed Request
        switch (stage) {
          case "Fresh":
            return data.dismissRequestFresh ?? 0;
          case "Contacted":
            return data.dismissRequestContacted ?? 0;
          case "Appointment":
            return data.dismissRequestAppointment ?? 0;
          case "Visited":
            return data.dismissRequestVisited ?? 0;
          case "Negotiation":
            return data.dismissRequestNegotiation ?? 0;
          case "Feedback":
            return data.dismissRequestFeedback ?? 0;
          case "Re-Appointment":
            return data.dismissRequestReAppointment ?? 0;
          case "Re-Visited":
            return data.dismissRequestReVisited ?? 0;
          case "Converted":
            return data.dismissRequestConverted ?? 0;
          default:
            return 0;
        }
      case 4: // Conversion Request
        switch (stage) {
          case "Fresh":
            return data.conversionRequestFresh ?? 0;
          case "Contacted":
            return data.conversionRequestContacted ?? 0;
          case "Appointment":
            return data.conversionRequestAppointment ?? 0;
          case "Visited":
            return data.conversionRequestVisited ?? 0;
          case "Negotiation":
            return data.conversionRequestNegotiation ?? 0;
          case "Feedback":
            return data.conversionRequestFeedback ?? 0;
          case "Re-Appointment":
            return data.conversionRequestReAppointment ?? 0;
          case "Re-Visited":
            return data.conversionRequestReVisited ?? 0;
          case "Converted":
            return data.conversionRequestConverted ?? 0;
          default:
            return 0;
        }
      case 5: // Due Appo
        switch (stage) {
          case "Fresh":
            return data.dueAppoFresh ?? 0;
          case "Contacted":
            return data.dueAppoContacted ?? 0;
          case "Appointment":
            return data.dueAppoAppointment ?? 0;
          case "Visited":
            return data.dueAppoVisited ?? 0;
          case "Negotiation":
            return data.dueAppoNegotiation ?? 0;
          case "Feedback":
            return data.dueAppoFeedback ?? 0;
          case "Re-Appointment":
            return data.dueAppoReAppointment ?? 0;
          case "Re-Visited":
            return data.dueAppoReVisited ?? 0;
          case "Converted":
            return data.dueAppoConverted ?? 0;
          default:
            return 0;
        }
      case 6: // CNR
        switch (stage) {
          case "Fresh":
            return data.CNRFresh ?? 0;
          case "Contacted":
            return data.CNRContacted ?? 0;
          case "Appointment":
            return data.CNRAppointment ?? 0;
          case "Visited":
            return data.CNRVisited ?? 0;
          case "Negotiation":
            return data.CNRNegotiation ?? 0;
          case "Feedback":
            return data.CNRFeedback ?? 0;
          case "Re-Appointment":
            return data.CNRReAppointment ?? 0;
          case "Re-Visited":
            return data.CNRReVisited ?? 0;
          case "Converted":
            return data.CNRConverted ?? 0;
          default:
            return 0;
        }
      default:
        return 0;
    }
  }

  void resetPagination() {
    _currentPage = 1;
    _inquiries.clear();
    _hasMore = true;
  }


  Future<void> fetchAddLeadData() async {
    _isLoadingDropdown = true;
    notifyListeners();

    try {
      final response = await _apiService.fetchAddLeadData();
      if (response != null) {
        _dropdownData = response;
      }
    } catch (e) {
      print("Error fetching dropdown options in provider: $e");
    } finally {
      _isLoadingDropdown = false;
      notifyListeners();
    }
  }
  // Map<String, int> _stageCounts = {};
  // Map<String, int> get stageCounts => _stageCounts;


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
  Future<void> checkLoginStatus() async {

    try {

      String? token = await _secureStorage.read(key: 'token');

      if (token != null) {

        _isLoggedIn = true;

        print(token);

        await fetchOfficeLocationData();

        fetchProfileData();

        fetchInquiries();

        // ✅ Run first (waits for completion)

        // Run remaining API calls in the background (parallel)
        Future.wait([

        ]);

      } else {

        _isLoggedIn = false;

      }
      notifyListeners();
    } catch (e) {
      _isLoggedIn = false;
      notifyListeners();

    }
  }

  Future<void> fetchProfileData () async {
    try {
      _profileData = await _apiService.fetchProfileData();
      notifyListeners();
    } catch (e) {
      print("Error fetching profile data: $e");
    }
  }

  Future<void> fetchOfficeLocationData () async {
    try {
      _officeLocationData = await _apiService.fetchOfficeLocationData();
      notifyListeners();
    } catch (e) {
      print("Error fetching office location data: $e");
    }
  }

  Future<void> fetchStaffLeavesData () async {
    try {
      _staffLeavesData = await _apiService.fetchStaffLeavesData();
      notifyListeners();
    } catch (e) {
      print("Error fetching staff leaves data: $e");
    }
  }

  Future<void> fetchLeaveTypesData () async {
    try {
      _leaveTypesData = await _apiService.fetchLeaveTypesData();
      notifyListeners();
    } catch (e) {
      print("Error fetching leave types data: $e");
    }
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
        head_name: head_name, full_name: full_name, under_team: under_team, date: date, reporting_to: reporting_to, apply_days: apply_days, from_date: from_date, to_date: to_date, leave_reason: leave_reason, leave_type: leave_type, leave_type_id: leave_type_id,
      );

      if (success) {
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error sending leave request: $e");
      return false;
    }
  }

  Future<void> fetchStaffAttendanceData () async {
    try {
      _staffAttendanceData = await _apiService.fetchStaffAttendanceData();
      notifyListeners();
    } catch (e) {
      print("Error fetching staff attendance data: $e");
    }
  }

//   void resetPagination() {
//     _currentPage = 1;
//     _inquiries.clear();
//     _hasMore = true;
//   }
}

// Add a getValue function to access the pagination data as a string and parse to int

