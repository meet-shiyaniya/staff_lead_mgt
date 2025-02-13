import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hr_app/staff_HRM_module/Model/Realtomodels/Realtoleavetypesmodel.dart';
import 'package:hr_app/staff_HRM_module/Model/Realtomodels/Realtoofficelocationmodel.dart';
import 'package:hr_app/staff_HRM_module/Model/Realtomodels/Realtostaffleavesmodel.dart';
import 'package:hr_app/staff_HRM_module/Model/Realtomodels/Realtostaffprofilemodel.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ApiService{
  final FlutterSecureStorage _secureStorage=FlutterSecureStorage();
  static const String baseUrl="https://admin.dev.ajasys.com/api";
  final String apiUrl = "https://admin.dev.ajasys.com/api/SelfiPunchAttendance";
  final String token = 'ZXlKMWMyVnlibUZ0WlNJNkltUmxiVzlmWVdGMWMyZ2lMQ0p3WVhOemQyOXlaQ0k2SWtvNWVpTk5TVEJQTmxkTWNEQlZjbUZ6Y0RCM0lpd2lhV1FpT2lJeU1qUWlMQ0p3Y205a2RXTjBYMmxrSWpvaU1TSjk=';


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

}