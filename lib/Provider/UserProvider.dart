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
import '../Inquiry_Management/Model/Api Model/allInquiryModel.dart';
import '../Inquiry_Management/Model/Api Model/fetch_visit_Model.dart';
import '../Inquiry_Management/Model/Api Model/followup_Cnr_Model.dart';
import '../Inquiry_Management/Model/Api Model/inquiryTimeLineModel.dart';

class UserProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  final ApiService _apiService = ApiService();

  Realtostaffprofilemodel? _profileData;
  Realtostaffprofilemodel? get profileData => _profileData;

  Realtostaffprofilemodel? _sendTransferInqData;
  Realtostaffprofilemodel? get sendTransferInqData => _sendTransferInqData;

  Realtoofficelocationmodel? _officeLocationData;
  Realtoofficelocationmodel? get officeLocationData => _officeLocationData;

  Realtostaffleavesmodel? _staffLeavesData;
  Realtostaffleavesmodel? get staffLeavesData => _staffLeavesData;

  Realtoleavetypesmodel? _leaveTypesData;
  Realtoleavetypesmodel? get leaveTypesData => _leaveTypesData;

  List<Realtostaffattendancemodel>? _staffAttendanceData;
  List<Realtostaffattendancemodel>? get staffAttendanceData => _staffAttendanceData;

  Realtoallstaffleavesmodel? _allStaffLeavesData;
  Realtoallstaffleavesmodel? get allStaffLeavesData => _allStaffLeavesData;

  fetchTransferInquiryModel? _transferInquiryData;
  fetchTransferInquiryModel? get transferInquiryData => _transferInquiryData;

  List<Inquiry> _inquiries = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  final int _limit = 20; // Number of items per API call

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

  followup_Cnr_Model? _followupCnrData;
  followup_Cnr_Model? get followupCnrData => _followupCnrData;

  // New function to fetch follow-up inquiries
  Future<void> fetchFollowupCnrInquiries({
    required int status,
    required String followupDay,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Notify UI that loading has started

    try {
      final data = await _apiService.fetchFollowupCnrInquiries(
        status,
        followupDay: followupDay,
      );
      if (data != null) {
        _followupCnrData = data;
        print("Follow-up CNR data loaded successfully: ${data.tab?.length} inquiries");
      } else {
        _errorMessage = "No follow-up inquiries received from the server";
        print("Warning: No follow-up data fetched");
      }
    } catch (e) {
      _errorMessage = "Error fetching follow-up inquiries: $e";
      print("Error: $_errorMessage");
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify UI that loading is complete
    }
  }

  Future<void> fetchInquiries({
    bool isLoadMore = false,
    int status = 0,
    String search = '',
    String stages = '', // Added stages parameter
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
        status,
        page: _currentPage,
        search: search,
        stages: stages, // Pass stages to API
      );

      if (response != null && response.inquiries.isNotEmpty) {
        paginatedInquiries = response;

        final newInquiries = response.inquiries
            .where((newInquiry) => !_inquiries.any((existing) => existing.id == newInquiry.id))
            .toList();

        if (isLoadMore) {
          _inquiries.addAll(newInquiries);
        } else {
          _inquiries = List.from(newInquiries);
        }

        _hasMore = _currentPage < response.totalPages! && newInquiries.isNotEmpty;
        if (hasMore) _currentPage++;

        _stageCounts = {
          "Total_Sum": getStageCount(status, "Total_Sum", response), // Add Total_Sum
          "Fresh": getStageCount(status, "Fresh", response),
          "Contacted": getStageCount(status, "Contacted", response),
          "Appointment": getStageCount(status, "Appointment", response),
          "Visited": getStageCount(status, "Visited", response),
          "Negotiation": getStageCount(status, "Negotiation", response),
          "Feedback": getStageCount(status, "Feedback", response),
          "Re_Appointment": getStageCount(status, "Re_Appointment", response),
          "reVisited": getStageCount(status, "reVisited", response),
          "Converted": getStageCount(status, "Converted", response),
        };

        print("Fetched ${_inquiries.length} unique inquiries, HasMore: $_hasMore, Page: $_currentPage");
      } else {
        _hasMore = false;
        print("No new inquiries to fetch");
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
    InquiryStatus? statusData = data.inquiryStatus.firstWhere(
          (s) => s.inquiryStatus == status.toString(),
      orElse: () => InquiryStatus(
        inquiryStatus: status.toString(),
        fresh: '0',
        contacted: '0',
        appointment: '0',
        visited: '0',
        negotiations: '0',
        feedBack: '0',
        reAppointment: '0',
        reVisited: '0',
        converted: '0',
        Total_Sum: '0', // Default to '0' as string
      ),
    );

    switch (stage) {
      case "Total_Sum":
        return int.parse(statusData.Total_Sum);
      case "Fresh":
        return int.parse(statusData.fresh);
      case "Contacted":
        return int.parse(statusData.contacted);
      case "Appointment":
        return int.parse(statusData.appointment);
      case "Visited":
        return int.parse(statusData.visited);
      case "Negotiation":
        return int.parse(statusData.negotiations);
      case "Feedback":
        return int.parse(statusData.feedBack);
      case "Re_Appointment":
        return int.parse(statusData.reAppointment);
      case "reVisited":
        return int.parse(statusData.reVisited);
      case "Converted":
        return int.parse(statusData.converted);
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
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.fetchAddLeadData();
      if (response != null) {
        _dropdownData = response;
      } else {
        _errorMessage = "Failed to fetch dropdown data from API";
        print("Provider: $_errorMessage");
      }
    } catch (e) {
      _errorMessage = "Error fetching dropdown options: $e";
      print("Provider Error: $_errorMessage");
    } finally {
      _isLoadingDropdown = false;
      notifyListeners();
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

  Future<bool> login(String username, String password) async {
    bool success = await _apiService.login(username, password);

    if (success) {
      _isLoggedIn = true;
      notifyListeners();
      return true;
    } else {
      _isLoggedIn = false;
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
        Future.wait([fetchTwoMonthsAttendance()]);
      } else {
        _isLoggedIn = false;
      }
      notifyListeners();
    } catch (e) {
      _isLoggedIn = false;
      notifyListeners();
    }
  }

  Future<void> fetchProfileData() async {
    try {
      _profileData = await _apiService.fetchProfileData();
      notifyListeners();
    } catch (e) {
      print("Error fetching profile data: $e");
    }
  }

  Future<void> fetchOfficeLocationData() async {
    try {
      _officeLocationData = await _apiService.fetchOfficeLocationData();
      notifyListeners();
    } catch (e) {
      print("Error fetching office location data: $e");
    }
  }

  Future<void> fetchStaffLeavesData() async {
    try {
      _staffLeavesData = await _apiService.fetchStaffLeavesData();
      notifyListeners();
    } catch (e) {
      print("Error fetching staff leaves data: $e");
    }
  }

  Future<void> fetchAllStaffLeavesData() async {
    try {
      _allStaffLeavesData = await _apiService.fetchAllStaffLeavesData();
      notifyListeners();
    } catch (e) {
      print("Error fetching staff leaves data: $e");
    }
  }

  Future<void> fetchLeaveTypesData() async {
    try {
      _leaveTypesData = await _apiService.fetchLeaveTypesData();
      notifyListeners();
    } catch (e) {
      print("Error fetching leave types data: $e");
    }
  }

  Future<bool> sendLeaveRequest({
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
        head_name: head_name,
        full_name: full_name,
        under_team: under_team,
        date: date,
        reporting_to: reporting_to,
        apply_days: apply_days,
        from_date: from_date,
        to_date: to_date,
        leave_reason: leave_reason,
        leave_type: leave_type,
        leave_type_id: leave_type_id,
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
    required String altmobileno,
    required String description,
  }) async {
    try {
      bool success = await _apiService.addLead(
        action: action,
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
        inquiry_type: inquiry_type,
        inquiry_source_type: inquiry_source_type,
        intrested_area_name: intrested_area_name,
        intersted_site_name: intersted_site_name,
        altmobileno: altmobileno,
        houseno: houseno,
        PropertyConfiguration: PropertyConfiguration,
        society: society,
        description: description,
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
        print("Inquiry Timeline Data:");
        print("Result: ${_inquiryTimeline!.result}");
        print("Inquiry ID: ${_inquiryTimeline!.inquiryId}");
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

  String? _error;
  String? get error => _error;

  VisitEntryModel? _visitData;
  VisitEntryModel? get visitData => _visitData;

  Future<void> fetchVisitData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _visitData = await _apiService.fetchVisitData();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTwoMonthsAttendance() async {
    try {
      _staffAttendanceData = await _apiService.fetchTwoMonthsAttendance();
      notifyListeners();
    } catch (e) {
      print("Error fetching staff attendance data: $e");
      _staffAttendanceData = null; // Optional: Reset data on error
      notifyListeners();
    }
  }

  Future<void> fetchTransferInquiryData() async {
    try {
      _transferInquiryData = await _apiService.fetchTransferInquiryData();
      notifyListeners();
    } catch (e) {
      print("Error fetching staff attendance data: $e");
    }
  }

  Future<void> sendTransferInquiry({
    required List<String> inqIds, // Changed to accept a list of IDs
    required String actionKey,
    required String employeeId,
  }) async {
    try {
      await _apiService.sendTransferInquiry(inqIds: inqIds, actionKey: actionKey, employeeId: employeeId);
      notifyListeners();
    } catch (e) {
      print("Error sending leave request: $e");
      return null;
    }
  }

  Future<bool> sendApproveReject({
    required String leaveId,
    required String action,
  }) async {
    try {
      await _apiService.sendApproveReject(leaveId: leaveId, action: action);
      notifyListeners();
      return true;
    } catch (e) {
      print("Error sending leave request: $e");
      return false;
    }
  }

  Future<bool> sendMemberAttendance({required String qrAttendance}) async {
    try {
      await _apiService.sendMemberAttendance(qrAttendance: qrAttendance);
      notifyListeners();
      return true;
    } catch (e) {
      print("Error sending leave request: $e");
      return false;
    }
  }
}