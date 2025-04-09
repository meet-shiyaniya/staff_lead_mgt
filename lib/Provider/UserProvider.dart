import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/All%20Reports/Models/campaign_Dropdown_Model.dart';
import 'package:hr_app/All%20Reports/Models/fetch_Conversions_Report_Model.dart';
import 'package:hr_app/All%20Reports/Models/fetch_Conversions_Report_Model.dart';
import 'package:hr_app/All%20Reports/Models/fetch_Daily_Reports_Model.dart';
import 'package:hr_app/All%20Reports/Models/fetch_Lead_Reports_Model.dart';
import 'package:hr_app/All%20Reports/Models/fetch_Lead_Reports_Model.dart';
import 'package:hr_app/All%20Reports/Models/fetch_Month_Filter_Model.dart';
import 'package:hr_app/All%20Reports/Models/fetch_Projects_Dropdown_Model.dart';
import 'package:hr_app/All%20Reports/Models/fetch_Projects_Dropdown_Model.dart';
import 'package:hr_app/All%20Reports/Models/fetch_Site_Reports_Model.dart';
import 'package:hr_app/All%20Reports/Models/fetch_User_Model.dart';
import 'package:hr_app/All%20Reports/Models/fetch_Visit_Reports_Model.dart';
import 'package:hr_app/All%20Reports/Models/performance_Model.dart';
import 'package:hr_app/Api_services/api_service.dart';
import 'package:hr_app/Inquiry_Management/Model/Api%20Model/assignToOther_Model.dart';
import 'package:hr_app/Inquiry_Management/Model/Api%20Model/dismiss_Model.dart';
import '../All Reports/Models/fetch_Inquiry_Reports_Model.dart';
import '../Inquiry_Management/Inquiry Management Screens/Filters/inquiry_Filter_Screen.dart';
import '../Inquiry_Management/Model/Api Model/add_Lead_Model.dart';
import '../Inquiry_Management/Model/Api Model/allInquiryModel.dart';
import '../Inquiry_Management/Model/Api Model/dismiss_dropdown_Model.dart';
import '../Inquiry_Management/Model/Api Model/edit_Lead_Model.dart';
import '../Inquiry_Management/Model/Api Model/fetch_Transfer_Inquiry_Model.dart';
import '../Inquiry_Management/Model/Api Model/fetch_booking_Model.dart';
import '../Inquiry_Management/Model/Api Model/fetch_unitno_model.dart';
import '../Inquiry_Management/Model/Api Model/fetch_visit_Model.dart';
import '../Inquiry_Management/Model/Api Model/inquiryTimeLineModel.dart';
import '../Inquiry_Management/Model/Api Model/inquiry_filter_model.dart';
import '../Inquiry_Management/Model/Api Model/inquiry_transfer_Model.dart';
import '../dashboard_ui/DashboardModels/RealtosmartdashboardModel.dart';
import '../dashboard_ui/DashboardModels/dashboardpermissionModel.dart';
import '../staff_HRM_module/Model/Realtomodels/Realtoallstaffleavesmodel.dart';
import '../staff_HRM_module/Model/Realtomodels/Realtoleavetypesmodel.dart';
import '../staff_HRM_module/Model/Realtomodels/Realtoofficelocationmodel.dart';
import '../staff_HRM_module/Model/Realtomodels/Realtostaffattendancemodel.dart';
import '../staff_HRM_module/Model/Realtomodels/Realtostaffleavesmodel.dart';
import '../staff_HRM_module/Model/Realtomodels/Realtostaffprofilemodel.dart';

class UserProvider with ChangeNotifier {

  bool _isLoggedIn=false;
  bool get isLoggedIn=> _isLoggedIn;

  // final ApiService _apiService=ApiService();
  final FlutterSecureStorage _secureStorage=FlutterSecureStorage();

  Realtostaffprofilemodel? _profileData;
  Realtostaffprofilemodel? get profileData => _profileData;

  inquiryReportModel? _inquiryReportData;
  inquiryReportModel? get inquiryReportData => _inquiryReportData;

  performanceModel? _performamceReportData;
  performanceModel? get performamceReportData => _performamceReportData;
  bool _isPerformanceLoading = false;
  bool get isPerformanceLoading => _isPerformanceLoading;

  FetchDailyReportsModel? _dailyReportsData;
  FetchDailyReportsModel? get dailyReportsData => _dailyReportsData;
  bool _isDailyRpLoading = false;
  bool get isDailyRpLoading => _isDailyRpLoading;

  fetchVisitReportsModel? _visitReportsData;
  bool _isVisitRpLoading = false;
  bool _isMoreLoading = false;
  bool hasFetchedInactive = false; // New flag to track if inactive users are fetched
  bool canFetchMore = true;
  bool hasMoreData = false;
  fetchVisitReportsModel? get visitReportsData => _visitReportsData;
  bool get isVisitRpLoading => _isVisitRpLoading;
  bool get isMoreLoading => _isMoreLoading;

  FetchConversionsReportModel? _conversionsReportData;
  bool _isConversionsRpLoading = false;
  bool get isConversionsRpLoading => _isConversionsRpLoading;
  FetchConversionsReportModel? get conversionsReportData => _conversionsReportData;

  FetchProjectsDropdownModel? _projectsDropdownData;
  bool _isLoadingProjectsDropdown = false;
  FetchProjectsDropdownModel? get projectsDropdownData => _projectsDropdownData;
  bool get isLoadingProjectsDropdown => _isLoadingProjectsDropdown;

  campaignDropdownModel? _campaignDropdownData;
  bool _isLoadingCampaignDropdown = false;
  campaignDropdownModel? get campaignDropdownData => _campaignDropdownData;
  bool get isLoadingCampaignDropdown => _isLoadingCampaignDropdown;

  FetchLeadReportsModel? _leadReportsData;
  FetchLeadReportsModel? get leadReportsData => _leadReportsData;
  bool _isLeadRpLoading = true;
  bool get isLeadRpLoading => _isLeadRpLoading;

  FetchSiteReportsModel? _siteReportsData;
  bool _isSiteRpLoading = false;
  bool get isSiteRpLoading => _isSiteRpLoading;
  FetchSiteReportsModel? get siteReportsData => _siteReportsData;

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

  DashboardpermissionModel? _dashboardpermission;
  DashboardpermissionModel? get dashboardpermissionModel => _dashboardpermission;
  RealtosmartdashboardModel? _DashBoarddata;
  RealtosmartdashboardModel? get DashBoarddata => _DashBoarddata;

  Realtoallstaffleavesmodel? _allStaffLeavesData;
  Realtoallstaffleavesmodel? get allStaffLeavesData => _allStaffLeavesData;

  List<Realtostaffattendancemodel>? _staffAttendanceData;
  List<Realtostaffattendancemodel>? get staffAttendanceData => _staffAttendanceData;


  InquiryFilter? _filterData;
  // String? _error;

  InquiryFilter? get filterData => _filterData;
  // String? get _error => _error;

  FetchBookingData2? _bookingData;
  FetchBookingData2? get bookingData => _bookingData;

  VisitEntryModel? _visitData;
  VisitEntryModel? get visitData => _visitData;

  FetchUnitnoModel? _unitNoData;
  FetchUnitnoModel? get unitNoData => _unitNoData;

  FetchUserModel? _userData;
  FetchUserModel? get userData => _userData;

  fetchMonthFilterModel? _monthsData;
  fetchMonthFilterModel? get monthsData => _monthsData;

  List<InquiryFollowup> _inquiriesAssignToOther = [];
  bool _isLoadingAssignToOther = false;
  bool _hasMoreAssignToOther = true;
  Map<String, String> _stageCountsAssignToOther = {}; // Changed to String values
  PaginatedInquiriesFollowup? paginatedInquiriesAssignToOther;

  // Getters
  List<InquiryFollowup> get inquiriesAssignToOther => _inquiriesAssignToOther;
  bool get isLoadingAssignToOther => _isLoadingAssignToOther;
  bool get hasMoreAssignToOther => _hasMoreAssignToOther;
  Map<String, String> get stageCountsAssignToOther => _stageCountsAssignToOther;



  List<InquiryFollowup> _inquiriesFollowup = [];
  Map<String, String> _stageCountsFollowup = {}; // Changed to String values
  PaginatedInquiriesFollowup? paginatedInquiriesFollowup;

  int _currentPageFollowup = 1;
  bool _isLoadingFollowup = false;
  bool _hasMoreFollowup = true;
  List<InquiryFollowup> get inquiriesFollowup => _inquiriesFollowup;
  bool get isLoadingFollowup => _isLoadingFollowup;
  bool get hasMoreFollowup => _hasMoreFollowup;
  Map<String, String> get stageCountsFollowup => _stageCountsFollowup;
  //
  // Future<void> fetchInquiriesAssignOther({
  //   bool isLoadMore = false,
  //   int status = 0,
  //   String search = '',
  //   String stages = '',
  // }) async {
  //   if (!isLoadMore) {
  //     _currentPageFollowup = 1;
  //     _inquiriesFollowup.clear();
  //     _stageCountsFollowup.clear();
  //   }
  //   if (isLoadMore && !_hasMoreFollowup) return;
  //
  //   _isLoadingFollowup = true;
  //   notifyListeners();
  //
  //   try {
  //     // Assuming fetchFollowupAndCNR returns PaginatedInquiriesFollowup
  //     final response = await _apiService.fetchAssignToOtherInquiries(
  //       status,
  //       page: _currentPageFollowup,
  //       search: search,
  //       stages: stages,
  //     );
  //
  //     if (response != null && response.inquiries.isNotEmpty) {
  //       paginatedInquiriesFollowup = response;
  //
  //       final newInquiriesFollowup = response.inquiries
  //           .where((newInquiry) =>
  //       !_inquiriesFollowup.any((existing) => existing.id == newInquiry.id))
  //           .toList();
  //
  //       if (isLoadMore) {
  //         _inquiriesFollowup.addAll(newInquiriesFollowup);
  //       } else {
  //         _inquiriesFollowup = List.from(newInquiriesFollowup);
  //       }
  //
  //
  //       _hasMoreFollowup = _currentPageFollowup < (response.totalPages ?? 1) &&
  //           newInquiriesFollowup.isNotEmpty;
  //       if (hasMoreFollowup) _currentPageFollowup++;
  //
  //       _stageCountsFollowup = {
  //         "Total_Sum": getStageCountFollowup(status, "Total_Sum", response),
  //         "Fresh": getStageCountFollowup(status, "Fresh", response),
  //         "Contacted": getStageCountFollowup(status, "Contacted", response),
  //         "Appointment": getStageCountFollowup(status, "Appointment", response),
  //         "Visited": getStageCountFollowup(status, "Visited", response),
  //         "Negotiations": getStageCountFollowup(status, "Negotiations", response),
  //         "FeedBack": getStageCountFollowup(status, "FeedBack", response),
  //         "Re_Appointment": getStageCountFollowup(status, "Re_Appointment", response),
  //         "Re_Visited": getStageCountFollowup(status, "Re_Visited", response),
  //         "Converted": getStageCountFollowup(status, "Converted", response),
  //       };
  //
  //       print(
  //           "Fetched ${_inquiriesFollowup.length} unique follow-up inquiries, HasMore: $_hasMoreFollowup, Page: $_currentPageFollowup");
  //     } else {
  //       _hasMoreFollowup = false;
  //       print("No new follow-up inquiries to fetch");
  //     }
  //   } catch (e) {
  //     print("Error fetching follow-up inquiries: $e");
  //     _hasMoreFollowup = false;
  //   } finally {
  //     _isLoadingFollowup = false;
  //     notifyListeners();
  //   }
  // }


  Map<String, String> _fullStageCountFollowup = {}; // Changed to String values
  Map<String, String> get fullStageCountFollowup => _fullStageCountFollowup;

  Future<void> fetchInquiriesFollowup({
    bool isLoadMore = false,
    int status = 0,
    String search = '',
    String stages = '',
    required String followUpDay,
  }) async {
    if (!isLoadMore) {
      _currentPageFollowup = 1;
      _inquiriesFollowup.clear();
      if (stages.isEmpty) _stageCountsFollowup
          .clear(); // Clear only when fetching all
    }
    if (isLoadMore && !_hasMoreFollowup) return;

    _isLoadingFollowup = true;
    notifyListeners();

    try {
      final response = await _apiService.fetchFollowupAndCNR(
        status,
        page: _currentPageFollowup,
        search: search,
        stages: stages,
        follow_up_day: followUpDay,
      );

      if (response != null && response.inquiries.isNotEmpty) {
        paginatedInquiriesFollowup = response;

        final newInquiriesFollowup = response.inquiries
            .where((newInquiry) =>
        !_inquiriesFollowup.any((existing) => existing.id == newInquiry.id))
            .toList();

        if (isLoadMore) {
          _inquiriesFollowup.addAll(newInquiriesFollowup);
        } else {
          _inquiriesFollowup = List.from(newInquiriesFollowup);
        }

        _hasMoreFollowup = _currentPageFollowup < (response.totalPages ?? 1) &&
            newInquiriesFollowup.isNotEmpty;
        if (hasMoreFollowup) _currentPageFollowup++;

        // Update stage counts
        final newCounts = {
          "Total_Sum": getStageCountFollowup(status, "Total_Sum", response),
          "Fresh": getStageCountFollowup(status, "Fresh", response),
          "Contacted": getStageCountFollowup(status, "Contacted", response),
          "Appointment": getStageCountFollowup(status, "Appointment", response),
          "Visited": getStageCountFollowup(status, "Visited", response),
          "Negotiations": getStageCountFollowup(
              status, "Negotiations", response),
          "FeedBack": getStageCountFollowup(status, "FeedBack", response),
          "Re_Appointment": getStageCountFollowup(
              status, "Re_Appointment", response),
          "Re_Visited": getStageCountFollowup(status, "Re_Visited", response),
          "Converted": getStageCountFollowup(status, "Converted", response),
        };

        if (stages.isEmpty) {
          _fullStageCountFollowup = Map.from(newCounts);
        }
        _stageCountsFollowup = newCounts;

      } else {
        // Reset counts when no inquiries are returned
        _hasMoreFollowup = false;
        if (!isLoadMore) {
          _inquiriesFollowup.clear();
          if (stages.isEmpty) {
            _fullStageCountFollowup = {
              "Total_Sum": "0",
              "Fresh": "0",
              "Contacted": "0",
              "Appointment": "0",
              "Visited": "0",
              "Negotiations": "0",
              "FeedBack": "0",
              "Re_Appointment": "0",
              "Re_Visited": "0",
              "Converted": "0",
            };
          }
          _stageCountsFollowup = Map.from(_fullStageCountFollowup);
        }
      }
    } catch (e) {
      _hasMoreFollowup = false;
    } finally {
      _isLoadingFollowup = false;
      notifyListeners();
    }
  }

  String getStageCountFollowup(int status, String stage,
      PaginatedInquiriesFollowup data) {
    InquiryStatusFollowup? statusData = data.inquiryStatus.firstWhere(
          (s) => s.inquiryStatus == status.toString(),
      orElse: () =>
          InquiryStatusFollowup(
            inquiryStatus: status.toString(),
            totalSum: '0',
            fresh: '0',
            contacted: '0',
            appointment: '0',
            visited: '0',
            negotiations: '0',
            feedBack: '0',
            reAppointment: '0',
            reVisited: '0',
            converted: '0',
          ),
    );

    switch (stage) {
      case "Total_Sum":
        return statusData.totalSum;
      case "Fresh":
        return statusData.fresh;
      case "Contacted":
        return statusData.contacted;
      case "Appointment":
        return statusData.appointment;
      case "Visited":
        return statusData.visited;
      case "Negotiations":
        return statusData.negotiations;
      case "FeedBack":
        return statusData.feedBack;
      case "Re_Appointment":
        return statusData.reAppointment;
      case "Re_Visited":
        return statusData.reVisited;
      case "Converted":
        return statusData.converted;
      default:
        return '0';
    }
  }

  void clearInquiriesFollowup() {
    inquiriesFollowup.clear();
    fullStageCountFollowup.clear();
    _isLoadingFollowup = false;
    _hasMoreFollowup = true;
    notifyListeners();
  }

  Future<void> fetchDashboardpermission() async {
    try {
      _dashboardpermission = await _apiService.fetchDashboardpermission();
      if (_dashboardpermission != null) {
        // Print the top-level fields
        print("fetchDashboardpermission");
        print("ok: ${_dashboardpermission!.allDashboard}");
        print("ok ID: ${_dashboardpermission!.appointmentCalender}");


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
  Future<void> fetchDashboard({required String countwise}) async {
    try {
      debugPrint('Fetching dashboard with countwise: $countwise');

      _DashBoarddata = await _apiService.fetchDashboard(countwise:countwise );



      notifyListeners();
    } catch (e) {
      debugPrint("Error in provider: $e");
      _DashBoarddata = null; // Changed from inquiryTimeline to _DashBoarddata
      notifyListeners();
    }
  }

  Future<void> fetchUnitNumbers(String intrestedProduct) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _unitNoData = await _apiService.fetchUnitNumbers(intrestedProduct);
      print("Unit numbers fetched: ${_unitNoData?.unitNo.map((unit) => 'Unit: ${unit.unitNo}, Size: ${unit.propertySize}').toList()}");

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      print('Error in fetchUnitNumbers: $e');
      notifyListeners();
      rethrow;
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
  Future<void> fetchAllStaffLeavesData () async {
    try {
      _allStaffLeavesData = await _apiService.fetchAllStaffLeavesData();
      notifyListeners();
    } catch (e) {
      print("Error fetching staff leaves data: $e");
    }
  }
  Future<bool> sendMemberAttendance({
    required String qrAttendance,
    required double latitude,
    required double longitude,
  }) async {
    try {
      bool success = await _apiService.sendMemberAttendance(
        qrAttendance: qrAttendance,
        latitude: latitude,
        longitude: longitude,
      );

      if (success) {
        notifyListeners(); // Notify UI of successful state change
      }
      return success;
    } catch (e) {
      print('Error sending attendance: $e');
      return false;
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

  Map<String, dynamic>? _assignToOther;
  Map<String, dynamic>? get assignToOther => _assignToOther;



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

        final newInquiries = response.inquiries.where((newInquiry) =>
        !_inquiries.any((existing) => existing.id == newInquiry.id)).toList();

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

  Future<void> fetchStaffLeavesData () async {
    try {
      _staffLeavesData = await _apiService.fetchStaffLeavesData();
      notifyListeners();
    } catch (e) {
      print("Error fetching staff leaves data: $e");
    }
  }

  // In UserProvider
  Future<void> fetchPerformanceReports({
    required String userId,
    required String fromDate,
    required String toDate
  }) async {
    _isPerformanceLoading = true;
    notifyListeners();
    try {
      _performamceReportData = await _apiService.fetchPerformanceReports(
          userId: userId,
          fromDate: fromDate,
          toDate: toDate
      );
      _isPerformanceLoading = false;
      notifyListeners();
    } catch (e) {
      print("Error fetching performance reports: $e");
      _isPerformanceLoading = false;
      _performamceReportData = null; // Explicitly set to null on error
      notifyListeners();
    }
  }

  Future<void> fetchMonthsData() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _monthsData = await _apiService.fetchMonthsData();
      if (_monthsData != null) {
        print("User data fetched: ${_monthsData!.dropDown?.length ?? 0} months");
        print("User reports: ${_monthsData!.dropDown?.map((u) => u.monthName).toList()}");
      } else {
        print("No data returned from API");
      }
    } catch (e) {
      _errorMessage = "Failed to fetch user data: $e";
      _monthsData = null;
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUserData() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _userData = await _apiService.fetchUserData();
      if (_userData != null) {
        print("User data fetched: ${_userData!.userReports?.length ?? 0} users");
        print("User reports: ${_userData!.userReports?.map((u) => u.firstname).toList()}");
      } else {
        print("No data returned from API");
      }
    } catch (e) {
      _errorMessage = "Failed to fetch user data: $e";
      _userData = null;
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDailyReports ({required String month}) async {
    _isDailyRpLoading = true;
    notifyListeners();
    try {
      print("object");
      _dailyReportsData = await _apiService.fetchDailyReports(month: month);
      // print(_performamceReportData);
      _isDailyRpLoading = false;
      notifyListeners();
    } catch (e) {
      print("Error fetching staff leaves data: $e");
    }
  }

  Future<void> fetchVisitReports({required String year}) async {
    try {
      _isVisitRpLoading = true;
      notifyListeners();

      final response = await _apiService.fetchVisitReports(year: year);

      if (response != null) {
        _visitReportsData = response; // Replace data with all users
      }

      _isVisitRpLoading = false;
      notifyListeners();
    } catch (e) {
      _isVisitRpLoading = false;
      notifyListeners();
      throw e;
    }
  }

  Future<void> fetchConversionsReport ({required String year}) async {
    _isConversionsRpLoading = true;
    notifyListeners();
    try {
      print("object");
      _conversionsReportData = await _apiService.fetchConversionsReport(year: year);
      print(_conversionsReportData?.message.toString());
      _isConversionsRpLoading = false;
      notifyListeners();
    } catch (e) {
      print("Error fetching staff leaves data: $e");
    }
  }

  Future<void> fetchProjectsDropdown () async {
    _isLoadingProjectsDropdown = true;
    notifyListeners();
    try {
      // print("object");
      _projectsDropdownData = await _apiService.fetchProjectsDropdown();
      // print(_conversionsReportData?.message.toString());
      _isLoadingProjectsDropdown = false;
      notifyListeners();
    } catch (e) {
      print("Error fetching staff leaves data: $e");
    }
  }

  Future<void> fetchCampaignDropdown() async {
    _isLoadingCampaignDropdown = true;
    notifyListeners();
    try {
      _campaignDropdownData = await _apiService.fetchCampaignDropdown();

      // Check if the dropdown data is effectively empty
      if (_campaignDropdownData == null ||
          _campaignDropdownData!.dropDown == null ||
          _campaignDropdownData!.dropDown!.isEmpty ||
          (_campaignDropdownData!.dropDown!.length == 1 &&
              _campaignDropdownData!.dropDown![0].pageId == "" &&
              _campaignDropdownData!.dropDown![0].pageName == "")) {
        _campaignDropdownData = null; // Treat as no data
      }

      _isLoadingCampaignDropdown = false;
      notifyListeners();
    } catch (e) {
      print("Error fetching campaign dropdown data: $e");
      _campaignDropdownData = null; // Reset on error
      _isLoadingCampaignDropdown = false;
      notifyListeners();
    }
  }

  Future<void> fetchLeadReports({required int pageID}) async {
    _isLeadRpLoading = true; // Ensure it's true at the start of the fetch
    notifyListeners();
    try {
      print("Fetching lead reports for pageID: $pageID");
      _leadReportsData = await _apiService.fetchLeadReports(pageID: pageID);
      print("data: $_leadReportsData");
    } catch (e) {
      print("Error fetching lead reports data: $e");
      _leadReportsData = null; // Explicitly set to null on error
    }
    _isLeadRpLoading = false; // Set to false after fetch completes
    notifyListeners();
  }

  Future<void> fetchSiteReports ({required String project, required String fromDate, required String toDate}) async {
    _isSiteRpLoading = true;
    notifyListeners();
    try {
      // print("object");
      _siteReportsData = await _apiService.fetchSiteReports(project: project, fromDate: fromDate, toDate: toDate);
      // print(_conversionsReportData?.message.toString());
      _isSiteRpLoading = false;
      notifyListeners();
    } catch (e) {
      print("Error fetching staff leaves data: $e");
    }
  }

  Future<void> fetchInquiryReport({required String fromDate, required String toDate}) async {
    try {
      debugPrint('Fetching dashboard with countwise: $fromDate to $toDate');
      _inquiryReportData = await _apiService.fetchInquiryReport(fromDate: fromDate, toDate: toDate);
      _errorMessage = null; // Clear error on success
      debugPrint('Inquiry Report Data: ${_inquiryReportData != null ? "Data fetched" : "No data"}');
      notifyListeners();
    } catch (e) {
      debugPrint("Error in provider: $e");
      _inquiryReportData = null;
      _errorMessage = e.toString(); // Store error message
      notifyListeners();
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
    required String altmobileno, required String description,
    // required String intrested_product

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
  String? _error;
  String? get error => _error;



  AllInquiryFilter? _allInquiryFilter;
  AllInquiryFilter? get allInquiryFilter => _allInquiryFilter;


  Future<void> filterInquiries(Map<String, dynamic> filters) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _allInquiryFilter = (await _apiService.fetchFilterData()) as AllInquiryFilter?;
    } catch (e) {
      _errorMessage = e.toString();
      _allInquiryFilter = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }





  Future<void> fetchVisitData(String inquiryId) async {
    try {
      _isLoading=true;

      _visitData=await _apiService.fetchVisitData(inquiryId);
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

  // Future<void> fetchStaffAttendanceData () async {
  //   try {
  //     _staffAttendanceData = (await _apiService.fetchStaffAttendanceData()) ;
  //     notifyListeners();
  //   } catch (e) {
  //     print("Error fetching staff attendance data: $e");
  //   }
  // }

  DismissModel? _dismissmodel;
  DismissModel? get dismissmodel => _dismissmodel;
  Future<void> fetchDismissData(int pageNumber) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      _dismissmodel = null;
      notifyListeners();

      print('Fetching dismiss data for page: $pageNumber');
      _dismissmodel = await _apiService.fetchDismissData(
        pageNumber,
      );
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

  Future<void> fetchTransferInquiryData () async {
    try {
      _transferInquiryData = await _apiService.fetchTransferInquiryData();
      notifyListeners();
    } catch (e) {
      print("Error fetching staff attendance data: $e");
    }
  }
  Future<void> fetch () async {
    try {
      _transferInquiryData = await _apiService.fetchTransferInquiryData();
      notifyListeners();
    } catch (e) {
      print("Error fetching staff attendance data: $e");
    }
  }

  Future<void> sendTransferInquiry ({
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



//   void resetPagination() {
//     _currentPage = 1;
//     _inquiries.clear();
//     _hasMore = true;
//   }
}

// Add a getValue function to access the pagination data as a string and parse to int

