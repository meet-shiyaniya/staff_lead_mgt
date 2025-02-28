import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hr_app/Inquiry_Management/Model/Api%20Model/add_Lead_Model.dart';
import 'package:hr_app/Inquiry_Management/Model/Api%20Model/fetch_Transfer_Inquiry_Model.dart';
import 'package:hr_app/staff_HRM_module/Model/Realtomodels/Realtoallstaffleavesmodel.dart';
import 'package:hr_app/staff_HRM_module/Model/Realtomodels/Realtoleavetypesmodel.dart';
import 'package:hr_app/staff_HRM_module/Model/Realtomodels/Realtoofficelocationmodel.dart';
import 'package:hr_app/staff_HRM_module/Model/Realtomodels/Realtostaffattendancemodel.dart';
import 'package:hr_app/staff_HRM_module/Model/Realtomodels/Realtostaffleavesmodel.dart';
import 'package:hr_app/staff_HRM_module/Model/Realtomodels/Realtostaffprofilemodel.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../Inquiry_Management/Model/Api Model/allInquiryModel.dart';
import '../Inquiry_Management/Model/Api Model/fetch_visit_Model.dart';
import '../Inquiry_Management/Model/Api Model/inquiryTimeLineModel.dart';

class ApiService{
  final FlutterSecureStorage _secureStorage=FlutterSecureStorage();
  static const String baseUrl="https://admin.dev.ajasys.com/api";
  static const String childUrl="https://admin.dev.ajasys.com/api/all_inquiry_data";
  final String apiUrl = "https://admin.dev.ajasys.com/api/SelfiPunchAttendance";
  final String updateProfilePicUrl = "$baseUrl/uploadProfileImage";

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

  Future<bool> updateProfilePic(File imageFile) async {
    try {
      String? token = await _secureStorage.read(key: 'token');

      if (token == null) {
        Fluttertoast.showToast(msg: "❌ Authentication error: Token not found");
        return false;
      }

      var request = http.MultipartRequest("POST", Uri.parse(updateProfilePicUrl));

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


  Future<PaginatedInquiries?> fetchInquiries(int limit, int status,  {required int page, required String search}) async {
    
    final url = Uri.parse("$childUrl?limit=$limit&status=$status&page=$page&search=$search");
    print("API URL: $url"); //


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
          body: jsonEncode({'token': token})




      );

      if (response.statusCode == 200) {
        print("resoponse json${response.body}");
        print("Response Status Code: ${response.statusCode}");
        // Ensure response is valid JSON before parsing
        if (response.body.startsWith('{') || response.body.startsWith('[')) {
          final Map<String, dynamic> jsonData = jsonDecode(response.body);
          return PaginatedInquiries.fromJson(jsonData);
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

  Future<VisitEntryModel> fetchVisitData() async {
    String? token = await _secureStorage.read(key: 'token');
    final body = {
      "token": token ,
      "edit_id": 95560,
    };
    print(token);

    final response = await http.post(
      Uri.parse('$baseUrl/fetch_visit_data'),
      headers: {
        'Content-Type': 'application/json',
      },

      body: jsonEncode(body),

    );
    print(response.body);

    if (response.statusCode == 200) {
      print("Api Successfully worked");
      return VisitEntryModel.fromJson(jsonDecode(response.body));

      print(response.body);

    } else {
      throw Exception('Failed to load visit data: ${response.statusCode} - ${response.body}');
    }
  }

  Future<Realtostaffattendancemodel?> fetchStaffAttendanceData () async {

    final url = Uri.parse("$baseUrl/month_attendance");

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

}