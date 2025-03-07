import 'dart:collection';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/Api_services/api_service.dart';
import 'package:hr_app/Inquiry_Management/Model/Api%20Model/followup_Cnr_Model.dart';
import '../Inquiry_Management/Model/Api Model/add_Lead_Model.dart';
import '../Inquiry_Management/Model/Api Model/dismiss_Model.dart';
import '../Inquiry_Management/Model/Api Model/dismiss_dropdown_Model.dart';
import '../Inquiry_Management/Model/Api Model/edit_Lead_Model.dart';
import '../Inquiry_Management/Model/Api Model/fetch_Transfer_Inquiry_Model.dart';
import '../Inquiry_Management/Model/Api Model/fetch_booking_Model.dart';
import '../Inquiry_Management/Model/Api Model/fetch_visit_Model.dart';
import '../Inquiry_Management/Model/Api Model/inquiryTimeLineModel.dart';
import '../Inquiry_Management/Model/Api Model/inquiry_filter_model.dart';
import '../Inquiry_Management/Model/Api Model/inquiry_transfer_Model.dart';
import '../Inquiry_Management/Model/category_Model.dart';
import '../dashboard_ui/DashboardModels/RealtosmartdashboardModel.dart';
import '../dashboard_ui/DashboardModels/dashboardpermissionModel.dart';
import '../staff_HRM_module/Model/Realtomodels/Realtoallstaffleavesmodel.dart';
import '../staff_HRM_module/Model/Realtomodels/Realtoleavetypesmodel.dart';
import '../staff_HRM_module/Model/Realtomodels/Realtoofficelocationmodel.dart';
import '../staff_HRM_module/Model/Realtomodels/Realtostaffattendancemodel.dart';
import '../staff_HRM_module/Model/Realtomodels/Realtostaffleavesmodel.dart';
import '../staff_HRM_module/Model/Realtomodels/Realtostaffprofilemodel.dart';
import 'package:hr_app/Inquiry_Management/Model/Api%20Model/allInquiryModel.dart' as AllInquiry;

class UserProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  Realtostaffprofilemodel? _profileData;
  Realtostaffprofilemodel? get profileData => _profileData;
  bool _isLoadingInq = false;
  String? _errorInq;
  List<CategoryModel> _stages = [];
  bool get isLoadingInq => _isLoadingInq;
  String? get errorInq => _errorInq;
  List<CategoryModel> get stages => _stages;

  Realtoofficelocationmodel? _officeLocationData;
  Realtoofficelocationmodel? get officeLocationData => _officeLocationData;

  Realtostaffleavesmodel? _staffLeavesData;
  Realtostaffleavesmodel? get staffLeavesData => _staffLeavesData;

  Realtoleavetypesmodel? _leaveTypesData;
  Realtoleavetypesmodel? get leaveTypesData => _leaveTypesData;

  final ApiService _apiService = ApiService();

  List<AllInquiry.Inquiry> _inquiries = [];
  List<FollowupInquiry> _followupInquiries = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  List<AllInquiry.Inquiry> get inquiries => _inquiries;
  List<FollowupInquiry> get followupInquiries => UnmodifiableListView(_followupInquiries);
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  AllInquiry.PaginatedInquiries? paginatedInquiries;
  PaginatedInquiries? paginatedFollowupInquiries;

  Map<String, int> _stageCounts = {};
  Map<String, int> get stageCounts => UnmodifiableMapView(_stageCounts);

  Map<String, int> _followupStageCounts = {};
  Map<String, int> get followupStageCounts => UnmodifiableMapView(_followupStageCounts);

  AddLeadDataModel? _dropdownData;
  bool _isLoadingDropdown = false;

  AddLeadDataModel? get dropdownData => _dropdownData;
  bool get isLoadingDropdown => _isLoadingDropdown;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<NextSlot> _nextSlots = [];
  List<NextSlot> get nextSlots => _nextSlots;

  DashboardpermissionModel? _dashboardpermission;
  DashboardpermissionModel? get dashboardpermissionModel => _dashboardpermission;
  RealtosmartdashboardModel? _DashBoarddata;
  RealtosmartdashboardModel? get DashBoarddata => _DashBoarddata;

  Realtoallstaffleavesmodel? _allStaffLeavesData;
  Realtoallstaffleavesmodel? get allStaffLeavesData => _allStaffLeavesData;

  List<Realtostaffattendancemodel>? _staffAttendanceData;
  List<Realtostaffattendancemodel>? get staffAttendanceData => _staffAttendanceData;

  InquiryFilter? _filterData;
  InquiryFilter? get filterData => _filterData;

  FetchBookingData2? _bookingData;
  FetchBookingData2? get bookingData => _bookingData;

  VisitEntryModel? _visitData;
  VisitEntryModel? get visitData => _visitData;

  Future<void> fetchDashboardpermission() async {
    try {
      _dashboardpermission = await _apiService.fetchDashboardpermission();
      if (_dashboardpermission != null) {
        print("fetchDashboardpermission");
        print("ok: ${_dashboardpermission!.allDashboard}");
        print("ok ID: ${_dashboardpermission!.appointmentCalender}");
      } else {
        print("No data returned from API");
      }
      notifyListeners();
    } catch (e) {
      print("Error in provider: $e");
      notifyListeners();
    }
  }

  Future<void> fetchDashboard({required String countwise}) async {
    try {
      debugPrint('Fetching dashboard with countwise: $countwise');
      _DashBoarddata = await _apiService.fetchDashboard(countwise: countwise);
      notifyListeners();
    } catch (e) {
      debugPrint("Error in provider: $e");
      _DashBoarddata = null;
      notifyListeners();
    }
  }

  Future<void> fetchTwoMonthsAttendance() async {
    try {
      _staffAttendanceData = await _apiService.fetchTwoMonthsAttendance();
      notifyListeners();
    } catch (e) {
      print("Error fetching staff attendance data: $e");
      _staffAttendanceData = null;
      notifyListeners();
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

  Future<bool> sendMannualAttendanceData() async {
    try {
      await _apiService.sendMannualAttendanceData();
      notifyListeners();
      return true;
    } catch (e) {
      print("Error sending leave request: $e");
      return false;
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

  Future<bool> sendAppUseRequest() async {
    try {
      await _apiService.sendAppUseRequest();
      notifyListeners();
      return true;
    } catch (e) {
      print("Error sending leave request: $e");
      return false;
    }
  }

  Future<void> fetchInquiries({
    bool isLoadMore = false,
    int status = 0,
    String search = '',
    String stages = '',
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
        stages: stages,
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
          "Total_Sum": getStageCount(status, "Total_Sum", response),
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

  int getStageCount(int status, String stage, AllInquiry.PaginatedInquiries data) {
    AllInquiry.InquiryStatus? statusData = data.inquiryStatus.firstWhere(
          (s) => s.inquiryStatus == status.toString(),
      orElse: () => AllInquiry.InquiryStatus(
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
        Total_Sum: '0',
      ),
    );

    try {
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
    } catch (e) {
      print("Error parsing stage count for $stage: $e");
      return 0; // Fallback value
    }
  }

  void resetPagination() {
    _currentPage = 1;
    _inquiries.clear();
    _hasMore = true;
  }

  Future<void> fetchFollowupCnrInquiry({
    required String followupDay,
    bool isLoadMore = false,
    int status = 0,
    String search = '',
    String stages = '',
  }) async {
    if (!isLoadMore) {
      _currentPage = 1;
      _followupInquiries.clear();
      _stageCounts.clear();
      _hasMore = true;
    }
    if (isLoadMore && !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.fetchFollowupCnrInquiry(
        status: status,
        followupDay: followupDay,
        page: _currentPage,
        search: search,
        stages: stages,
      );

      if (response != null && response.status == 1 && response.inquiries.isNotEmpty) {
        paginatedFollowupInquiries = response;

        // Handle inquiries
        final newInquiries = response.inquiries
            .where((newInquiry) => !_followupInquiries.any((existing) => existing.id == newInquiry.id))
            .toList();

        if (isLoadMore) {
          _followupInquiries.addAll(newInquiries);
        } else {
          _followupInquiries = List.from(newInquiries);
        }

        _hasMore = _currentPage < response.totalPages && newInquiries.isNotEmpty;
        if (_hasMore) _currentPage++;

        // Process stage counts from inquiry_status
        _stageCounts = _processStageCounts(status, response);

        print("Fetched ${_followupInquiries.length} inquiries, Stage Counts: $_stageCounts, HasMore: $_hasMore, Page: $_currentPage");
      } else {
        _hasMore = false;
        print("No inquiries or unsuccessful response: ${response?.status}");
      }
    } catch (e) {
      print("Error fetching inquiries: $e");
      _hasMore = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Map<String, int> _processStageCounts(int status, PaginatedInquiries data) {
    final statusData = data.inquiryStatus.firstWhere(
          (s) => s.inquiryStatus == status.toString(),
      orElse: () => InquiryStatus(
        inquiryStatus: status.toString(),
        totalSum: 0,
        fresh: 0,
        contacted: 0,
        appointment: 0,
        visited: 0,
        negotiations: 0,
        feedback: 0,
        reAppointment: 0,
        reVisited: 0,
        converted: 0,
      ),
    );

    return {
      'Total_Sum': statusData.totalSum,
      'Fresh': statusData.fresh,
      'Contacted': statusData.contacted,
      'Appointment': statusData.appointment,
      'Visited': statusData.visited,
      'Negotiations': statusData.negotiations,
      'Feed_Back': statusData.feedback,
      'Re_Appointment': statusData.reAppointment,
      'Re_Visited': statusData.reVisited,
      'Converted': statusData.converted,
    };
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

  InquiryStatusModel? _inquiryStatus;
  InquiryStatusModel? get inquiryStatus => _inquiryStatus;

  Future<void> fetchInquiryStatus() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await _apiService.fetchInquiryStatus();
      if (data != null) {
        _inquiryStatus = data;
      } else {
        _errorMessage = "Failed to load data";
      }
    } catch (e) {
      _errorMessage = "Error: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
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

  Future<void> fetchLeaveTypesData() async {
    try {
      _leaveTypesData = await _apiService.fetchLeaveTypesData();
      notifyListeners();
    } catch (e) {
      print("Error fetching leave types data: $e");
    }
  }

  Future<EditLeadData?> fetchEditLeadData(String leadId) async {
    try {
      final editData = await _apiService.fetchEditLeadData(leadId);
      if (editData == null) {
        throw Exception('Failed to fetch edit lead data');
      }
      return editData;
    } catch (e) {
      print('Error in provider fetching edit lead data: $e');
      return null;
    }
  }

  Future<bool> updateInquiryStatus({
    required String inquiryId,
    required String selectedTab,
    required Map<String, dynamic> formData,
    String? interestedProduct,
    int? isSiteVisit,
    int? interest,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _apiService.updateInquiryStatus(
        inquiryId: inquiryId,
        selectedTab: selectedTab,
        formData: formData,
        interestedProduct: interestedProduct,
        isSiteVisit: isSiteVisit,
        interest: interest,
      );

      _isLoading = false;

      if (result['success']) {
        _error = 'Inquiry status updated successfully';
        notifyListeners();
        return true;
      } else {
        _error = result['message'];
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _error = 'Unexpected error: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> handleFollowUpUpdate({
    required String inquiryId,
    required Map<String, dynamic> formData,
    required int interest,
  }) async {
    return await updateInquiryStatus(
      inquiryId: inquiryId,
      selectedTab: 'follow up',
      formData: formData,
      interest: interest,
      isSiteVisit: formData['isSiteVisit'] as int?,
      interestedProduct: formData['interestedProduct'] as String?,
    );
  }

  Future<bool> updateLead({
    required String action,
    required String leadId,
    required String fullName,
    required String mobileno,
    required String altmobileno,
    required String email,
    required String houseno,
    required String society,
    required String area,
    required String city,
    required String countryCode,
    required String intrestedArea,
    required String intrestedAreaName,
    required String interstedSiteName,
    required String budget,
    required String purposeBuy,
    required String approxBuy,
    required String propertyConfiguration,
    required String inquiryType,
    required String inquirySourceType,
    required String description,
    required String intrestedProduct,
    String? nxtFollowUp,
  }) async {
    try {
      final success = await _apiService.updateLeadData(
        leadId: leadId,
        fullName: fullName,
        mobileno: mobileno,
        altmobileno: altmobileno,
        email: email,
        houseno: houseno,
        society: society,
        area: area,
        city: city,
        countryCode: countryCode,
        intrestedArea: intrestedArea,
        intrestedAreaName: intrestedAreaName,
        interstedSiteName: interstedSiteName,
        budget: budget,
        purposeBuy: purposeBuy,
        approxBuy: approxBuy,
        propertyConfiguration: propertyConfiguration,
        inquiryType: inquiryType,
        inquirySourceType: inquirySourceType,
        description: description,
        intrestedProduct: intrestedProduct,
        nxtFollowUp: nxtFollowUp,
      );
      print("Update Lead Result: $success");
      notifyListeners();
      return success;
    } catch (e) {
      print('Error in provider updating lead data: $e');
      return false;
    }
  }

  InquiryModel? _inquiryModel;
  InquiryModel? get inquiryModel => _inquiryModel;

  Future<void> loadInquiryData(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      _inquiryModel = await _apiService.fetchInquiryData(id);
    } catch (e) {
      print('Error: $e');
    }

    _isLoading = false;
    notifyListeners();
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
        description: '',
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
      _inquiryTimeline = null;
      notifyListeners();
    }
  }

  String? _error;
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

  Future<void> fetchVisitData(String inquiryId) async {
    try {
      _isLoading = true;
      _visitData = await _apiService.fetchVisitData(inquiryId);
      notifyListeners();
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

  DismissModel? _dismissmodel;
  DismissModel? get dismissmodel => _dismissmodel;

  Future<void> fetchDismissData(int pageNumber) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      _dismissmodel = null;
      notifyListeners();

      print('Fetching dismiss data for page: $pageNumber');
      _dismissmodel = await _apiService.fetchDismissData(pageNumber);
      print('Dismiss data fetched: ${_dismissmodel?.toJson()}');

      _isLoading = false;
      if (_dismissmodel == null) {
        _errorMessage = "No dismiss data returned from API";
        print('Error: No data returned');
      }
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _dismissmodel = null;
      _errorMessage = "Error fetching dismiss data: $e";
      print('Exception: $_errorMessage');
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  fetchTransferInquiryModel? _transferInquiryData;
  fetchTransferInquiryModel? get transferInquiryData => _transferInquiryData;

  Future<void> fetchTransferInquiryData() async {
    try {
      _transferInquiryData = await _apiService.fetchTransferInquiryData();
      notifyListeners();
    } catch (e) {
      print("Error fetching staff attendance data: $e");
    }
  }

  Future<void> sendTransferInquiry({
    required List<String> inqIds,
    required String actionKey,
    required String employeeId,
  }) async {
    try {
      await _apiService.sendTransferInquiry(inqIds: inqIds, actionKey: actionKey, employeeId: employeeId);
      notifyListeners();
    } catch (e) {
      print("Error sending leave request: $e");
    }
  }
}