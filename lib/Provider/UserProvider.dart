import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hr_app/Api_services/api_service.dart';
import 'package:hr_app/Inquiry_Management/Model/Api%20Model/add_Lead_Model.dart';
import 'package:hr_app/Inquiry_Management/Model/Api%20Model/fetch_Transfer_Inquiry_Model.dart';
import 'package:hr_app/staff_HRM_module/Model/Realtomodels/Realtoallstaffleavesmodel.dart';
import 'package:hr_app/staff_HRM_module/Model/Realtomodels/Realtoleavetypesmodel.dart';
import 'package:hr_app/staff_HRM_module/Model/Realtomodels/Realtoofficelocationmodel.dart';
import 'package:hr_app/staff_HRM_module/Model/Realtomodels/Realtostaffattendancemodel.dart';
import 'package:hr_app/staff_HRM_module/Model/Realtomodels/Realtostaffleavesmodel.dart';
import 'package:hr_app/staff_HRM_module/Model/Realtomodels/Realtostaffprofilemodel.dart';
import 'package:http/http.dart' as http;
import '../Inquiry_Management/Model/Api Model/allInquiryModel.dart';
import '../Inquiry_Management/Model/Api Model/fetch_booking_Model.dart';
import '../Inquiry_Management/Model/Api Model/fetch_visit_Model.dart';
import '../Inquiry_Management/Model/Api Model/inquiryTimeLineModel.dart';
import '../Inquiry_Management/Model/Api Model/inquiry_filter_model.dart';

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

  Realtoallstaffleavesmodel? _allStaffLeavesData;
  Realtoallstaffleavesmodel? get allStaffLeavesData => _allStaffLeavesData;

  fetchTransferInquiryModel? _transferInquiryData;
  fetchTransferInquiryModel? get transferInquiryData => _transferInquiryData;

  final ApiService _apiService = ApiService();

  List<Inquiry> _inquiries = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  final int _limit = 20;

  FetchBookingData2? _bookingData; // Made nullable and properly declared
  FetchBookingData2? get bookingData => _bookingData;

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

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<NextSlot> _nextSlots = [];
  List<NextSlot> get nextSlots => _nextSlots;

  InquiryFilter? _filterData;
  // bool _isLoading = false;
  String? _error;

  InquiryFilter? get filterData => _filterData;
  // bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchFilterData() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _filterData = await _apiService.fetchFilterData();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }


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


  Future<void> fetchVisitData(String inquiryId) async {
    try {
      String? token = await _secureStorage.read(key: 'token');
      final body = {
        "token": token,
        "edit_id": int.parse(inquiryId), // Convert to int if needed
      };
      print('Fetching visit data with body: $body');

      final response = await http.post(
        Uri.parse('https://admin.dev.ajasys.com/api/fetch_visit_data'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      print('Response: ${response.body}');

      if (response.statusCode == 200) {
        _visitData = VisitEntryModel.fromJson(jsonDecode(response.body));
        notifyListeners();
      } else {
        _error = 'Failed to load visit data: ${response.statusCode} - ${response.body}';
        notifyListeners();
        throw Exception(_error);
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      throw e;
    }
  }


  Future<void> fetchBookingData(String editId) async {

    try {
      _isLoading = true;
      notifyListeners();
      _bookingData = await _apiService.fetchBookingData(editId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      throw e;
    }
  }

  Future<void> fetchAddLeadData() async {
    try {
      _isLoadingDropdown = true;
      notifyListeners();

      String? token = await _secureStorage.read(key: 'token');
      final response = await http.post(
        Uri.parse('https://admin.dev.ajasys.com/api/InquiryDetails'), // Replace with actual endpoint
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"token": token}),
      );

      if (response.statusCode == 200) {
        _dropdownData = AddLeadDataModel.fromJson(jsonDecode(response.body));
        _isLoadingDropdown = false;
        notifyListeners();
      } else {
        _error = 'Failed to load dropdown data: ${response.statusCode} - ${response.body}';
        _isLoadingDropdown = false;
        notifyListeners();
        throw Exception(_error);
      }
    } catch (e) {
      _error = e.toString();
      _isLoadingDropdown = false;
      notifyListeners();
      throw e;
    }
  }


  Future<void> fetchNextSlots(String date) async {
    _isLoading = true;
    _errorMessage = null;
    _nextSlots = [];
    notifyListeners();

    try {
      _nextSlots = await _apiService.fetchNextSlots(date);
      print("UserProvider: Successfully fetched ${_nextSlots.length} slots");
      if (_nextSlots.isEmpty) {
        _errorMessage = "No slots available for this date";
        print("UserProvider: No slots available");
      } else {
        print("UserProvider: Slots fetched - ${jsonEncode(_nextSlots.map((slot) => {'id': slot.id, 'source': slot.source, 'disabled': slot.disabled}).toList())}");
      }
    } catch (e) {
      _errorMessage = "Error fetching data: $e";
      print("UserProvider Error: $_errorMessage");
      _nextSlots = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _nextSlots = [];
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
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

  Future<void> fetchAllStaffLeavesData () async {
    try {
      _allStaffLeavesData = await _apiService.fetchAllStaffLeavesData();
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

  Future<bool> addLead({
    required String action,
    required String nxt_follow_up,
    required String time,
    required String purpose_buy,
    required String city,
    required String country_code,
    required String intrested_area,
    required String full_name,
    required String budget,
    required String approx_buy,
    required String area,
    required String mobileno,
    required String inquiry_type,
    required String inquiry_source_type,
    required String intrested_area_name,
    required String intersted_site_name,
    required String PropertyConfiguration,
    required String society,
    required String houseno,
    required String altmobileno, required String description

  }) async {
    try {
      bool success = await _apiService.addLead(
          action:action,
          nxt_follow_up: nxt_follow_up,
          time: time,
          purpose_buy: purpose_buy,
          city: city,
          country_code: country_code,
          intrested_area: intrested_area,
          full_name: full_name,
          budget: budget,
          approx_buy: approx_buy,
          area: area,
          mobileno: mobileno,
          inquiry_type:inquiry_type,
          inquiry_source_type:inquiry_source_type,
          intrested_area_name:intrested_area_name,
          intersted_site_name:intersted_site_name,
        altmobileno: altmobileno,
        houseno: houseno,
        PropertyConfiguration: PropertyConfiguration,
        society: society, description: ''

      );

      if (success) {
        print("Lead Added Successfully");
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error adding Lead  $e");
      return false;
    }
  }
  InquiryTimeLineModel? _inquiryTimeline;
  InquiryTimeLineModel? get inquiryTimeline => _inquiryTimeline;

  Future<void> fetchInquiryTimeline({required String inquiryId}) async {
    try {
      _inquiryTimeline = await _apiService.fetchInquiryTimeline(inquiryId: inquiryId);
      if (_inquiryTimeline != null) {
        // Print the top-level fields
        print("Inquiry Timeline Data:");
        print("Result: ${_inquiryTimeline!.result}");
        print("Inquiry ID: ${_inquiryTimeline!.inquiryId}");

        // Print the list of Data objects
        if (inquiryTimeline!.data != null && inquiryTimeline!.data!.isNotEmpty) {
          print("Data List (${_inquiryTimeline!.data!.length} items):");
          for (var i = 0; i < _inquiryTimeline!.data!.length; i++) {
            final dataItem = _inquiryTimeline!.data![i];
            print("  Item #$i:");
            print("    Created At: ${dataItem.createdAt}");
            print("    Username: ${dataItem.username}");
            print("    Status Label: ${dataItem.statusLabel}");
            print("    Next Follow Date: ${dataItem.nxtfollowdate}");
            print("    Remark Text: ${dataItem.remarktext}");
            print("    Condition Wise BG: ${dataItem.conditionWIseBG}");
            print("    Stages ID: ${dataItem.stagesId}");
            print("    Inquiry Log: ${dataItem.inquiryLog}");
          }
        } else {
          print("No Data items available.");
        }
      } else {
        print("No data returned from API");
      }
      notifyListeners();
    } catch (e) {
      print("Error in provider: $e");
      _inquiryTimeline = null; // Reset on error
      notifyListeners();
    }

  }
  // String? _error;
  // String? get error => _error;

  VisitEntryModel? _visitData;
  VisitEntryModel? get visitData => _visitData;



  Future<void> fetchStaffAttendanceData () async {
    try {
      _staffAttendanceData = await _apiService.fetchStaffAttendanceData();
      notifyListeners();
    } catch (e) {
      print("Error fetching staff attendance data: $e");
    }
  }

  Future<void> fetchTransferInquiryData () async {
    try {
      _transferInquiryData = await _apiService.fetchTransferInquiryData();
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

