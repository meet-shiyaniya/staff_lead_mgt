import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hr_app/staff_HRM_module/Model/Realtomodels/Realtoleavetypesmodel.dart';
import 'package:hr_app/staff_HRM_module/Model/Realtomodels/Realtoofficelocationmodel.dart';
import 'package:hr_app/staff_HRM_module/Model/Realtomodels/Realtostaffattendancemodel.dart';
import 'package:hr_app/staff_HRM_module/Model/Realtomodels/Realtostaffleavesmodel.dart';
import 'package:hr_app/staff_HRM_module/Model/Realtomodels/Realtostaffprofilemodel.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../Inquiry_Management/Model/Api Model/allInquiryModel.dart';

class ApiService{
  final FlutterSecureStorage _secureStorage=FlutterSecureStorage();
  static const String baseUrl="https://admin.dev.ajasys.com/api";
  static const String childUrl="https://admin.dev.ajasys.com/api/all_inquiry_data";
  final String apiUrl = "https://admin.dev.ajasys.com/api/SelfiPunchAttendance";


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


  Future<PaginatedInquiries?> fetchInquiries(int limit, int status,  {required int page}) async {
    
    final url = Uri.parse("$childUrl?limit=$limit&status=$status&page=$page");
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

        return true;

      } else {

        return false;

      }

    } catch (e) {

      return false;

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

}