import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hr_app/Inquiry_Management/Model/Api%20Model/add_Lead_Model.dart';
import 'package:hr_app/Inquiry_Management/Model/Api%20Model/dismiss_Model.dart';
import 'package:hr_app/staff_HRM_module/Model/Realtomodels/Realtoleavetypesmodel.dart';
import 'package:hr_app/staff_HRM_module/Model/Realtomodels/Realtoofficelocationmodel.dart';
import 'package:hr_app/staff_HRM_module/Model/Realtomodels/Realtostaffprofilemodel.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../Inquiry_Management/Model/Api Model/allInquiryModel.dart';
import '../Inquiry_Management/Model/Api Model/dismiss_dropdown_Model.dart';
import '../Inquiry_Management/Model/Api Model/edit_Lead_Model.dart';
import '../Inquiry_Management/Model/Api Model/fetch_Transfer_Inquiry_Model.dart';
import '../Inquiry_Management/Model/Api Model/fetch_booking_Model.dart';
import '../Inquiry_Management/Model/Api Model/fetch_visit_Model.dart';
import '../Inquiry_Management/Model/Api Model/followup_Cnr_Model.dart';
import '../Inquiry_Management/Model/Api Model/inquiryTimeLineModel.dart';
import '../Inquiry_Management/Model/Api Model/inquiry_filter_model.dart';
import '../Inquiry_Management/Model/Api Model/inquiry_transfer_Model.dart';
import '../dashboard_ui/DashboardModels/RealtosmartdashboardModel.dart';
import '../dashboard_ui/DashboardModels/dashboardpermissionModel.dart';
import '../staff_HRM_module/Model/Realtomodels/Realtoallstaffleavesmodel.dart';
import '../staff_HRM_module/Model/Realtomodels/Realtostaffattendancemodel.dart';
import '../staff_HRM_module/Model/Realtomodels/Realtostaffleavesmodel.dart';
import 'package:hr_app/Inquiry_Management/Model/Api%20Model/allInquiryModel.dart' as AllInquiry;
import 'package:hr_app/Inquiry_Management/Model/Api%20Model/followup_Cnr_Model.dart' as Followup;

class ApiService{
  final FlutterSecureStorage _secureStorage=FlutterSecureStorage();
  static const String baseUrl="https://admin.dev.ajasys.com/api";
  static const String childUrl="https://admin.dev.ajasys.com/api/all_inquiry_data";
  static const String followupCnrInqUrl="$baseUrl/show_list_Dismiss_allinquiry";
  final String apiUrl = "https://admin.dev.ajasys.com/api/SelfiPunchAttendance";


  Future<Realtostaffleavesmodel?> fetchStaffLeavesData () async {

    final url = Uri.parse("$baseUrl/Leave_list_status");

    try {

      String? token = await _secureStorage.read(key: 'token');

      if (token == null) {

        return null;

      }

      final response = await http.post(

          url,
          headers: {

            'Content-Type': "application/json"

          },
          body: jsonEncode({'token': token})

      );

      if (response.statusCode == 200) {

        final data = jsonDecode(response.body);

        return Realtostaffleavesmodel.fromJson(data);

      } else {

        return null;

      }

    } catch (e) {

      return null;

    }

  }

  Future<bool> sendMannualAttendanceData () async {

    String editBioStatus = "0";
    String createdAtDateTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()).toString();
    String entryDateTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()).toString();

    final url = Uri.parse('$baseUrl/insert_attendance_newday');

    try {

      String? token = await _secureStorage.read(key: 'token');

      if (token == null) {

        return false;

      }

      Map<String, String> bodyData = {

        "token": token,
        "edit_bio": editBioStatus,
        "created_at": createdAtDateTime,
        "entry_date_time": entryDateTime,

      };

      final response = await http.post(

          url,
          headers: {

            'Content-Type': 'application/json'

          },
          body: jsonEncode(bodyData)

      );

      if (response.statusCode == 200) {

        // final data = jsonDecode(response.body);

        Fluttertoast.showToast(msg: "✅ Attendance marked: Present");
        return true;

      } else {

        Fluttertoast.showToast(msg: "Failed to send attendance data!");
        return false;

      }

    } catch (e) {

      Fluttertoast.showToast(msg: "Something Went Wrong!");
      return false;

    }

  }

  Future<Realtoallstaffleavesmodel?> fetchAllStaffLeavesData () async {

    final url = Uri.parse('$baseUrl/child_leave_request');

    try {

      String? token = await _secureStorage.read(key: 'token');

      if (token == null) {

        return null;

      }

      final response = await http.post(

          url,
          headers: {

            'Content-Type': 'application/json'

          },
          body: jsonEncode({'token': token})

      );

      if (response.statusCode == 200) {

        // Fluttertoast.showToast(msg: "data fetched.");

        final data = jsonDecode(response.body);

        return Realtoallstaffleavesmodel.fromJson(data);

      } else {

        Fluttertoast.showToast(msg: "Data not fetched!");
        return null;

      }

    } catch (e) {

      return null;

    }

  }
  Future<List<Realtostaffattendancemodel>> fetchTwoMonthsAttendance() async {
    final url = Uri.parse("$baseUrl/month_attendance");
    final String? token = await _secureStorage.read(key: 'token');

    if (token == null) {
      throw Exception('No token found');
    }

    DateTime now = DateTime.now();
    DateTime currentMonth = DateTime(now.year, now.month, 1);
    DateTime lastMonth = DateTime(now.year, now.month - 1, 1);

    try {
      // Fetch current month data
      final currentMonthResponse = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'token': token,
          'selectedYear': currentMonth.year,
          'selectedMonth': currentMonth.month,
        }),
      );

      // Fetch last month data
      final lastMonthResponse = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'token': token,
          'selectedYear': lastMonth.year,
          'selectedMonth': lastMonth.month,
        }),
      );

      List<Realtostaffattendancemodel> attendanceData = [];

      // Process current month response
      if (currentMonthResponse.statusCode == 200) {
        final currentJsonResponse = json.decode(currentMonthResponse.body);
        attendanceData.add(Realtostaffattendancemodel.fromJson(currentJsonResponse));
      } else {
        throw Exception('Failed to load current month data: ${currentMonthResponse.statusCode}');
      }

      // Process last month response
      if (lastMonthResponse.statusCode == 200) {
        final lastJsonResponse = json.decode(lastMonthResponse.body);
        attendanceData.add(Realtostaffattendancemodel.fromJson(lastJsonResponse));
      } else {
        throw Exception('Failed to load last month data: ${lastMonthResponse.statusCode}');
      }

      return attendanceData;

    } catch (e) {
      print("Error fetching attendance data: $e");
      rethrow; // Allow the caller to handle the error
    }
  }
  Future<Realtoleavetypesmodel?> fetchLeaveTypesData () async {

    final url = Uri.parse("$baseUrl/Leave_add_list");

    try {

      String? token = await _secureStorage.read(key: 'token');

      if (token == null) {

        return null;

      }

      final response = await http.post(

          url,
          headers: {

            'Content-Type': 'application/json'

          },
          body: jsonEncode({'token': token})

      );

      if (response.statusCode == 200) {

        final data = jsonDecode(response.body);

        return Realtoleavetypesmodel.fromJson(data);

      } else {

        return null;

      }

    } catch (e) {

      return null;

    }

  }
  Future<bool> updateProfilePic(File imageFile) async {
    try {
      String? token = await _secureStorage.read(key: 'token');

      if (token == null) {
        Fluttertoast.showToast(msg: "❌ Authentication error: Token not found");
        return false;
      }

      var request = http.MultipartRequest("POST", Uri.parse("$baseUrl/uploadProfileImage"));

      request.files.add(
        await http.MultipartFile.fromPath('profile_image', imageFile.path),
      );

      request.fields['token'] = token;

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        print("Response Data: $responseData");
        Fluttertoast.showToast(msg: "✅ Profile Picture updated successfully");
        return true;
      } else {
        var errorData = await response.stream.bytesToString();
        print("❌ Error Data: $errorData");
        Fluttertoast.showToast(msg: "❌ Failed to update profile picture: $errorData");
        return false;
      }
    } catch (e) {
      print("❌ Exception: $e");
      Fluttertoast.showToast(msg: "❌ Error: $e");
      return false;
    }
  }

  Future<bool> sendAppUseRequest () async {

    final url = Uri.parse("$baseUrl/sendAccessRequest");

    try {

      String? token = await _secureStorage.read(key: 'token');

      if (token == null) {

        return false;

      }

      final response = await http.post(

          url,
          headers: {

            'Content-Type': 'application/json'

          },
          body: jsonEncode({'token': token})

      );

      if (response.statusCode == 200) {

        Fluttertoast.showToast(msg: "Request sent successfully");
        return true;

      } else {

        Fluttertoast.showToast(msg: "Request not sent!");
        return false;

      }

    } catch (e) {

      Fluttertoast.showToast(msg: "Something Went Wrong!");
      return false;

    }

  }

  Future<int> sendMemberAttendance({required String qrAttendance}) async {
    final url = Uri.parse('$baseUrl/memberAttendanceInsert');
    try {
      String? token = await _secureStorage.read(key: 'token');
      // String token = "ZXlKMWMyVnlibUZ0WlNJNkltUmxiVzlmWVdGcllYTm9JaXdpY0dGemMzZHZjbVFpT2lJeE1qTWlMQ0pwWkNJNklqSXpNU0lzSW5CeWIyUjFZM1JmYVdRaU9pSXhJbjA9";

      if (token == null) return 0;

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': token, 'qrAttendance': qrAttendance}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        Fluttertoast.showToast(msg: responseData['status'] == 1
            ? 'Attendance recorded successfully.'
            : 'Wrong QR code.');
        return responseData['status'] ?? 2;
      }
    } catch (_) {}
    Fluttertoast.showToast(msg: 'Failed to add attendance.');
    return 2;
  }

  Future<void> sendApproveReject({
    required String leaveId,
    required String action,
  }) async {final url = Uri.parse("$baseUrl/leave_request_action");

  try {
    String? token = await _secureStorage.read(key: 'token');
    if (token == null) return;

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'token': token, 'leave_id': leaveId, 'action': action}),
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: "Send Success");

    } else {
      Fluttertoast.showToast(msg: "Failed to update leave request.");
    }
  } catch (e) {
    Fluttertoast.showToast(msg: "Send not Success");
  }
  }

  Future<void> uploadSelfie(File imageFile) async {
    try {
      String? token = await _secureStorage.read(key: 'token');
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      String latitude = position.latitude.toString();
      String longitude = position.longitude.toString();

      // Get current date and time
      String currentDateTime =
      DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()).toString();

      var request = http.MultipartRequest("POST", Uri.parse(apiUrl));


      request.files.add(
          await http.MultipartFile.fromPath('photoData', imageFile.path));

      request.fields['location'] = '$latitude, $longitude';
      request.fields['date'] = currentDateTime;
      request.fields['token'] = token!;

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        print("Response Data: $responseData");

        print(response.stream);
        Fluttertoast.showToast(msg: "✅ Selfie uploaded successfully");
      } else {
        var errorData = await response.stream.bytesToString();
        print("Error Data: $errorData");
        Fluttertoast.showToast(msg: "❌ Failed to upload selfie ($errorData)");
      }

    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }

  Future<bool> login(String username,String password) async{
    final url=Uri.parse("$baseUrl/stafflogin");
    try{
      final response=await http.post(
        url,headers: {
        'Content-Type':'application/json',
      },
        body: jsonEncode({
          'username':username,
          'password':password,
          'product_id':'1',
          'token':"zYPi153TmqFatXhJUOsrxyfgi79xhj8kQ6t9HXXr23mRcL4Sufvxdd3Y9Rmzq6DJ"
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



  Future<Realtostaffprofilemodel?> fetchProfileData() async {

    final url = Uri.parse('$baseUrl/StaffProfile');

    try {

      String? token = await _secureStorage.read(key: 'token');

      if (token == null) {

        return null;

      }

      final response = await http.post(

        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'token': token}),

      );

      if (response.statusCode == 200) {

        final data = jsonDecode(response.body);

        return Realtostaffprofilemodel.fromJson(data);

      } else {

        return null;

      }

    } catch(e) {

      return null;

    }

  }

  Future<Realtoofficelocationmodel?> fetchOfficeLocationData () async {

    final url = Uri.parse("$baseUrl/SelfiPunch_lati_logi");

    try {

      String? token = await _secureStorage.read(key: 'token');

      if (token == null) {

        return null;

      }

      final response = await http.post(

          url,
          headers: {

            'Content-Type': "application/json"

          },
          body: jsonEncode({'token': token})

      );

      if (response.statusCode == 200) {

        final data = jsonDecode(response.body);

        return Realtoofficelocationmodel.fromJson(data);

      } else {

        return null;

      }

    } catch (e) {

      return null;

    }

  }


  Future<List<NextSlot>> fetchNextSlots(String date) async {
    final url = Uri.parse("$baseUrl/nxt_followup_slottime");
    print("Step 1 - API URL: $url");

    try {
      String? token = await _secureStorage.read(key: 'token');
      print("Step 2 - Token: $token");
      if (token == null || token.isEmpty) {
        throw Exception("Token is null or empty");
      }

      final formattedDate = DateFormat('dd-MM-yyyy')
          .format(DateFormat('yyyy-MM-dd').parse(date));
      print("Step 3 - Formatted Date: $formattedDate");

      final requestBody = jsonEncode({
        'token': token,
        'nxt_follow_up': formattedDate,
      });
      print("Step 4 - Request Body: $requestBody");

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: requestBody,
      );

      print("Step 5 - Response Status Code: ${response.statusCode}");
      print("Step 6 - Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        print("Step 7 - Parsed JSON: $jsonData");
        return jsonData.map((json) => NextSlot.fromJson(json)).toList();
      } else {
        throw Exception("API Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Step 8 - Error: $e");
      rethrow;
    }
  }

  Future<bool> updateLeadData({
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
    final url = Uri.parse("$baseUrl/update_inquiry_data");
    try {
      String? token = await _secureStorage.read(key: 'token');
      Map<String, dynamic> bodyData = {
        "token": token,
        "edit_id": leadId,
        "action": "update",
        "full_name": fullName,
        "mobileno": mobileno,
        "altmobileno": altmobileno,
        "email": email,
        "houseno": houseno,
        "society": society,
        "area": area,
        "city": city,
        "country_code": countryCode,
        "intrested_area": intrestedArea,
        "intrested_area_name": intrestedAreaName,
        "intersted_site_name": interstedSiteName,
        "budget": budget,
        "purpose_buy": purposeBuy,
        "approx_buy": approxBuy,
        "PropertyConfiguration": propertyConfiguration,
        "inquiry_type": inquiryType,
        "inquiry_source_type": inquirySourceType,
        "inquiry_description": description,
        "intrested_product": intrestedProduct,
      };
      if (nxtFollowUp != null) bodyData["nxt_follow_up"] = nxtFollowUp;

      print("Update Lead API Payload: ${jsonEncode(bodyData)}");

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bodyData),
      );

      print("Update Lead API Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse['success'] == true || jsonResponse['status'] == 'success';
      }
      return false;
    } catch (e) {
      print("Error updating lead data: $e");
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
    required String description


  }) async {
    final url = Uri.parse("$baseUrl/insert_Inquiry_data");

    try {
      String? token = await _secureStorage.read(key: 'token');
      print("Token: $token");

      if (token == null) {
        print("Token is null, aborting request");
        return false;
      }

      Map<String, String> bodyData = {
        "token": token,
        "action": action,
        "nxt_follow_up": nxt_follow_up,
        "time": time,
        "purpose_buy": purpose_buy,
        "city": city,
        "country_code": country_code,
        "intrested_area": intrested_area,
        "full_name": full_name,
        "budget": budget,
        "approx_buy": approx_buy,
        "area": area,
        "mobileno": mobileno,
        "inquiry_type": inquiry_type,
        "inquiry_source_type": inquiry_source_type,
        "intrested_area_name": intrested_area_name,
        "intersted_site_name": intersted_site_name,
        "PropertyConfiguration":PropertyConfiguration,
        "society":society,
        "houseno":houseno,
        "altmobileno":altmobileno,
        "inquiry_description":description
      };

      print("Request URL: $url");
      print("Request Body: ${jsonEncode(bodyData)}");

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(bodyData),
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        print("Lead added successfully");
        return true;
      } else {
        print("Failed to add lead. Status Code: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error adding lead: $e");
      return false;
    }
  }


  Future<Map<String, dynamic>> updateInquiryStatus({
    required String inquiryId,
    required String selectedTab,
    required Map<String, dynamic> formData,
    String? interestedProduct,
    int? isSiteVisit,
    int? interest,
  }) async {
    final url = Uri.parse('$baseUrl/inquiry_update_status_api');

    try {
      String? token = await _secureStorage.read(key: 'token');
      if (token == null) {
        return {'success': false, 'message': 'No token found'};
      }

      Map<String, dynamic> requestData = {
        'token': token,
        'inquiry_id': inquiryId,
        'remark': formData['remark'] ?? '',
        'call_recording_url': 'undefined',
      };

      switch (selectedTab.toLowerCase()) {
        case 'follow up':
          requestData.addAll({
            'nxt_follow_up': formData['nextFollowUp'] ?? '',
            'call_time': formData['callTime'] ?? '',
            'status_btn_click': (interest != null && interest > 0) ? '13' : '2',
            'tag_btn_click': 'Contacted',
          });
          break;

        case 'dismissed':
          requestData.addAll({
            'intrested_product': interestedProduct ?? '5',
            'status_btn_click': '7',
            'inquiry_close_reason': formData['closeReasonId'] ?? '2',
            'inquiry_close_reasons': formData['closeReasonId'] ?? '2',
            'tag_btn_click': 'Dismissed',
          });
          break;

        case 'appointment':
          requestData.addAll({
            'intrested_product': interestedProduct ?? '5',
            'nxt_follow_up': formData['nextFollowUp'] ?? '',
            'call_time': formData['callTime'] ?? '',
            'appointment_date': formData['appointDate'] ?? '',
            'status_btn_click': (isSiteVisit != null && isSiteVisit > 0) ? '10' : '3',
            'tag_btn_click': 'Appointment',
          });
          break;

        case 'cnr':
          requestData.addAll({
            'intrested_product': interestedProduct ?? '5',
            'nxt_follow_up': formData['nextFollowUp'] ?? '',
            'call_time': formData['callTime'] ?? '',
            'appointment_date': formData['appointDate'] ?? '',
            'status_btn_click': '17',
            'tag_btn_click': 'CNR',
          });
          break;

        case 'negotiations':
          requestData.addAll({
            'intrested_product': interestedProduct ?? '5',
            'nxt_follow_up': formData['nextFollowUp'] ?? '',
            'call_time': formData['callTime'] ?? '',
            'appointment_date': formData['appointDate'] ?? '',
            'status_btn_click': '6',
            'tag_btn_click': 'Negotiations',
          });
          break;

        case 'feedback':
          requestData.addAll({
            'intrested_product': interestedProduct ?? '5',
            'nxt_follow_up': formData['nextFollowUp'] ?? '',
            'call_time': formData['callTime'] ?? '',
            'appointment_date': formData['appointDate'] ?? '',
            'status_btn_click': '9',
            'tag_btn_click': 'Feedback',
          });
          break;

        default:
          return {'success': false, 'message': 'Invalid tab selection'};
      }

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestData),
      );

      print('Request Data: ${jsonEncode(requestData)}');
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'success': responseData['result'] == 1,
          'message': responseData['result'] == 1 ? 'Update successful' : 'Update failed',
          'data': responseData
        };
      }
      return {'success': false, 'message': 'Server error'};
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<RealtosmartdashboardModel?> fetchDashboard({

    required String countwise,
    String fromDate = '2025-03-01',
    String toDate = '2025-03-01',
    String area = '',
    String dateDashboard = '2025-03-01',
  }) async {
    final url = Uri.parse("$baseUrl/main_dashboard_api");
    try {
      String? token = await _secureStorage.read(key: 'token');
      print("Token: $token");
      if (token == null) {
        print("Error: No token found");
        return null;
      }

      final response = await http.post(
        url,
        headers: {
          'Content-Type': "application/json",
        },
        body: jsonEncode({
          'token': token,
          'countwise': countwise,
          'fromdate': fromDate,
          'todate': toDate,
          'area': area,
          'date_dashboard': dateDashboard,
        }),
      );

      if (response.statusCode == 200) {
        print("Response Status Code: ${response.statusCode}");
        final data = jsonDecode(response.body);
        print(data);



        return RealtosmartdashboardModel.fromJson(data);

      } else {
        print("Error fetching data: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("API error: $e");
      return null;
    }
  }
  Future<DashboardpermissionModel?> fetchDashboardpermission() async {
    final url = Uri.parse("$baseUrl/permission_dashboard_api");
    try {
      // Fetch token from secure storage
      String? token = await _secureStorage.read(key: 'token');
      if (token == null) {
        throw Exception('No authentication token found');
      }

      // Prepare request body
      Map<String, String> bodyData = {
        "token": token,
      };

      // Make HTTP POST request with timeout
      final response = await http
          .post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bodyData),
      )
          .timeout(const Duration(seconds: 15)); // 15-second timeout

      // Check response status
      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          return DashboardpermissionModel.fromJson(data);
        } catch (e) {
          throw Exception('Failed to parse JSON response: $e');
        }
      } else {
        throw Exception('Server error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching inquiry timeline: $e'); // Log for debugging
      return null; // Indicate failure with null
    }
  }


  Future<AllInquiry.PaginatedInquiries?> fetchInquiries(
      int status, {
        required int page,
        required String search,
        String stages = '', // Added stages parameter
      }) async {
    final url = Uri.parse("$childUrl?&status=$status&page=$page&search=$search");
    try {
      String? token = await _secureStorage.read(key: 'token');
      print("Token: $token");
      if (token == null) {
        print("Error: No token found");
        return null;
      }
      final response = await http.post(
        url,
        headers: {
          'Content-Type': "application/json",
        },
        body: jsonEncode({
          'token': token,
          'stages': stages, // Pass stages in the body
        }),
      );

      if (response.statusCode == 200) {
        print("Response Status Code: ${response.statusCode}");
        if (response.body.startsWith('{') || response.body.startsWith('[')) {
          final Map<String, dynamic> jsonData = jsonDecode(response.body);
          return AllInquiry.PaginatedInquiries.fromJson(jsonData);
        } else {
          print(response.body);
          print("Error: Received non-JSON response");
          return null;
        }
      } else {
        print("Error fetching data: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("API error: $e");
      return null;
    }
  }

  Future<Followup.PaginatedInquiries?> fetchFollowupCnrInquiry({
    required int status,
    required String followupDay,
    required int page,
    required String search,
    String stages = '',
  }) async {
    final url = Uri.parse("$followupCnrInqUrl?status=$status&page=$page&search=$search");
    try {
      String? token = await _secureStorage.read(key: 'token');
      if (token == null) {
        print("Error: No token found");
        return null;
      }

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Assuming token-based auth
        },
        body: jsonEncode({
          'token': token,
          'stages': stages,
          'follow_up_day': followupDay,
        }),
      );

      if (response.statusCode == 200) {
        print("Response Status Code: ${response.statusCode}");
        final jsonData = jsonDecode(response.body);
        if (jsonData is Map<String, dynamic>) {
          return Followup.PaginatedInquiries.fromJson(jsonData);
        } else {
          print("Error: Received non-JSON response: ${response.body}");
          return null;
        }
      } else {
        print("Error fetching data: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("API error: $e");
      return null;
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

    final url = Uri.parse("$baseUrl/Leave_Add");

    try {

      String? token = await _secureStorage.read(key: 'token');

      if (token == null) {

        return false;

      }

      Map<String, String> bodyData = {

        "token": token,
        "head": head_name,
        "full_name": full_name,
        "under_team": under_team,
        "date": date,
        "reporting_to": reporting_to,
        "leave_apply_days": apply_days,
        "leave_from_date": from_date,
        "leave_to_date": to_date,
        "leave_reason": leave_reason,
        "type_of_leave": leave_type,
        "type_of_leave_id": leave_type_id

      };

      final response = await http.post(

          url,
          headers: {

            'Content-Type': 'application/json'

          },
          body: jsonEncode(bodyData)

      );

      if (response.statusCode == 200) {
        print(response.body);

        return true;

      } else {

        return false;

      }

    } catch (e) {

      return false;

    }

  }

  Future<AddLeadDataModel?> fetchAddLeadData() async {
    final url = Uri.parse("https://admin.dev.ajasys.com/api/InquiryDetails"); // Use your baseUrl
    print("Full API URL for dropdown options: $url");

    try {
      String? token = await _secureStorage.read(key: 'token');
      print("Token: $token");
      if (token == null || token.isEmpty) {
        print("Error: Token is null or empty");
        return null;
      }

      // Send token in the body instead of header
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'token': token, // Adjust this key if API expects something else (e.g., "auth_token")
        }),
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        print("Parsed JSON Data: $jsonData");

        // Check for success status (adjust based on API convention)
        if (jsonData['status'] == null || jsonData['status'] == 1) { // Assuming 1 is success
          return AddLeadDataModel.fromJson(jsonData);
        } else {
          print("API Error: ${jsonData['message']}");
          return null;
        }
      } else {
        print("Error fetching dropdown options: Status ${response.statusCode}, Body: ${response.body}");
        return null;
      }
    } catch (e) {
      print("API error fetching dropdown options: $e");
      return null;
    }
  }

  Future<InquiryStatusModel?> fetchInquiryStatus() async {
    final url = Uri.parse("https://admin.dev.ajasys.com/api/fetch_dismiss_data"); // Use your baseUrl
    print("Full API URL for dropdown options: $url");

    try {
      // Retrieve token from secure storage
      String? token = await _secureStorage.read(key: 'token');
      print("Token: $token");

      if (token == null || token.isEmpty) {
        print("Error: Token is null or empty");
        return null;
      }

      // API Request
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'token': token}), // Adjust key if needed
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        print("Parsed JSON Data: $jsonData");

        return InquiryStatusModel.fromJson(jsonData);
      } else {
        print("Error: Failed to load inquiry status. Status: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Exception occurred: $e");
      return null;
    }
  }
  Future<DismissModel?> fetchDismissData(int pageNumber) async {
    final url = Uri.parse("$baseUrl/show_list_Dismiss_allinquiry?pageNumber=$pageNumber");
    print("API URL: $url");

    try {
      String? token = await _secureStorage.read(key: 'token'); // Assuming _secureStorage is defined
      print("Token: $token");
      if (token == null) {
        print("Error: No token found");
        return null;
      }

      // Updated body with additional parameters
      final Map<String, dynamic> requestBody = {
        'token': token,
        'follow_up_day': 'closerequest',
        'action': '',
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': "application/json",
        },
        body: jsonEncode(requestBody), // Encode the updated body
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        if (response.body.startsWith('{') || response.body.startsWith('[')) {
          final Map<String, dynamic> jsonData = jsonDecode(response.body);
          return DismissModel.fromJson(jsonData);
        } else {
          print("Error: Received non-JSON response");
          return null;
        }
      } else {
        print("Error fetching data: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("API error: $e");
      return null;
    }
  }

  Future<fetchTransferInquiryModel?> fetchTransferInquiryData () async {

    final url = Uri.parse('$baseUrl/sendallinquiry');

    try {

      String? token = await _secureStorage.read(key: 'token');

      if (token == null) {

        return null;

      }

      final response = await http.post(

          url,
          headers: {

            'Content-Type': 'application/json'

          },
          body: jsonEncode({'token': token})

      );

      if (response.statusCode == 200) {

        Fluttertoast.showToast(msg: "data fetched.");

        final data = jsonDecode(response.body);

        return fetchTransferInquiryModel.fromJson(data);

      } else {

        Fluttertoast.showToast(msg: "Data not fetched!");
        return null;

      }

    } catch (e) {

      return null;

    }

  }

  Future<void> sendTransferInquiry({
    required List<String> inqIds, // Changed to accept a list of IDs
    required String actionKey,
    required String employeeId,
  }) async {
    final url = Uri.parse("$baseUrl/people_assign_bulkapi");

    try {
      String? token = await _secureStorage.read(key: 'token');

      if (token == null) {
        Fluttertoast.showToast(msg: "No authentication token found");
        return;
      }

      // Join the inquiry IDs into a comma-separated string
      String inquiryIdsString = inqIds.join(',');

      Map<String, String> bodyData = {
        "token": token,
        "inquiry_id": inquiryIdsString, // Send as "123,456,789"
        "action_name": actionKey,
        "action": "assign",
        "assign_id": employeeId
      };

      print('Sending to backend: $bodyData'); // Debug print

      final response = await http.post(
        url,
        body: bodyData,
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Fluttertoast.showToast(msg: inqIds.toString());
        Fluttertoast.showToast(msg: "Inquiries transferred successfully");
      } else {
        Fluttertoast.showToast(
          msg: "Failed to transfer inquiries: ${response.statusCode}",
        );
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong: $e");
      rethrow;
    }
  }

  Future<InquiryTimeLineModel?> fetchInquiryTimeline({
    required String inquiryId,
  }) async {
    final url = Uri.parse("$baseUrl/inquiry_log_show");
    try {
      // Fetch token from secure storage
      String? token = await _secureStorage.read(key: 'token');
      if (token == null) {
        throw Exception('No authentication token found');
      }

      // Prepare request body
      Map<String, String> bodyData = {
        "token": token,
        "inquiry_id": inquiryId,
      };

      // Make HTTP POST request with timeout
      final response = await http
          .post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bodyData),
      )
          .timeout(const Duration(seconds: 15)); // 15-second timeout

      // Check response status
      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          return InquiryTimeLineModel.fromJson(data);
        } catch (e) {
          throw Exception('Failed to parse JSON response: $e');
        }
      } else {
        throw Exception('Server error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching inquiry timeline: $e'); // Log for debugging
      return null; // Indicate failure with null
    }
  }


  Future<InquiryModel> fetchInquiryData(String id) async {
    final url = Uri.parse("$baseUrl/inquiry_call_api");
    try {
      String? token = await _secureStorage.read(key: 'token');
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'inquiry_id': id, 'token': token}),
      );

      if (response.statusCode == 200) {
        print(response.body);
        return InquiryModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load inquiry data');
      }
    } catch (e) {
      throw Exception('Error fetching inquiry data: $e');
    }
  }
// Fetch edit lead data with ID in body
  Future<EditLeadData?> fetchEditLeadData(String leadId) async {
    final url = Uri.parse("$baseUrl/edit_inquiry_list_data");

    try {
      String? token = await _secureStorage.read(key: 'token');
      if (token == null) {
        throw Exception('No authentication token found');
      }

      Map<String, String> bodyData = {
        "token": token,
        "edit_id": leadId,
        "action": "edit"  // Added static action parameter
      };

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bodyData),
      );

      if (response.statusCode == 200) {
        try {
          final jsonResponse = jsonDecode(response.body);
          final data = jsonResponse['data'][0]; // Assuming single lead data
          print(response.body);
          return EditLeadData.fromJson(data);
        } catch (e) {
          throw Exception('Failed to parse JSON response: $e');
        }
      } else {
        throw Exception('Server error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching edit lead data: $e');
      return null;
    }
  }


  Future<Realtostaffattendancemodel?> fetchStaffAttendanceData () async {

    final url = Uri.parse("$baseUrl/Attendance");

    try {

      String? token = await _secureStorage.read(key: 'token');

      if (token == null) {

        return null;

      }

      final response = await http.post(

          url,
          headers: {

            'Content-Type': 'application/json'

          },
          body: jsonEncode({'token': token})

      );

      if (response.statusCode == 200) {

        final data = jsonDecode(response.body);

        return Realtostaffattendancemodel.fromJson(data);

      } else {

        return null;

      }

    } catch (e) {

      return null;

    }

  }

  Future<VisitEntryModel> fetchVisitData(String inquiryId) async {
    String? token = await _secureStorage.read(key: 'token');
    final body = {
      "token": token,
      "edit_id": int.parse(inquiryId), // Convert inquiryId to int if API expects it as a number
    };
    print('Fetching visit data with body: $body');

    final response = await http.post(
      Uri.parse('$baseUrl/fetch_visit_data'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );
    print('Response: ${response.body}');

    if (response.statusCode == 200) {
      print("API Successfully worked");
      return VisitEntryModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load visit data: ${response.statusCode} - ${response.body}');
    }
  }
  Future<Map<String, dynamic>> submitVisitData(Map<String, dynamic> data) async {
    print("API Service - Data to be sent: ${jsonEncode(data)}"); // Log the data being sent

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/visit_insert_data"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(data), // Data is encoded and sent in the body
      );

      print("API Service - Response Status: ${response.statusCode}"); // Log the status code
      print("API Service - Response Body: ${response.body}"); // Log the raw response body

      if (response.statusCode == 200) {
        return {
          "success": true,
          "message": "Data submitted successfully",
        };
      } else {
        return {
          "success": false,
          "message": "Failed to submit data: ${response.statusCode} - ${response.body}",
        };
      }
    } catch (e) {
      print("API Service - Error: $e"); // Log any exceptions
      return {
        "success": false,
        "message": "Error: $e",
      };
    }
  }
  Future<Map<String, dynamic>> submitBookingData(Map<String, dynamic> bookingData) async {
    String? token = await _secureStorage.read(key: 'token');

    try {

      final requestBody = {
        'token': token,
        ...bookingData,
      };

      // Log the full request body
      debugPrint('=== Booking API Request Start ===');
      // debugPrint('Request URL: $_baseUrl');
      debugPrint('Request Headers:');
      debugPrint('  Content-Type: application/json');
      debugPrint('  Authorization: Bearer $token');
      debugPrint('Request Body: ${jsonEncode(requestBody)}');

      // Send the API request
      final response = await http.post(
        Uri.parse('https://admin.dev.ajasys.com/api/booking_insert'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );

      // Log the response details
      debugPrint('Response Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');
      debugPrint('=== Booking API Request End ===');

      // Parse and return the response
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData;
      } else {
        debugPrint('API Request Failed: Status Code ${response.statusCode}');
        return {
          'status': 0,
          'message': 'Failed to submit booking. Status code: ${response.statusCode}',
        };
      }
    } catch (e) {
      // Log any exceptions
      debugPrint('Exception during API call: $e');
      debugPrint('=== Booking API Request Failed ===');
      return {
        'status': 0,
        'message': 'Error submitting booking: $e',
      };
    }
  }
  Future<FetchBookingData2> fetchBookingData(String editId) async {
    final url = Uri.parse("$baseUrl/fetch_booking_data");
    print("Fetching booking data - API URL: $url");

    try {
      String? token = await _secureStorage.read(key: 'token');
      print("Token: $token");
      if (token == null || token.isEmpty) {
        throw Exception("Token is null or empty");
      }

      final requestBody = jsonEncode({
        'token': token,
        'edit_id': int.parse(editId),
      });
      print("Request Body: $requestBody");

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return FetchBookingData2.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("API Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Error fetching booking data: $e");
      rethrow;
    }
  }
  Future<InquiryFilter> fetchFilterData() async {

    try {
      String? token = await _secureStorage.read(key: 'token');
      final response = await http.post(
        Uri.parse('$baseUrl/fetch_filter_data'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'token': token,
        }),
      );

      if (response.statusCode == 200) {
        return inquiryFilterFromJson(response.body);
      } else {
        throw Exception('Failed to load filter data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching filter data: $e');
    }
  }

}