import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hr_app/staff_HRM_module/Model/Realtomodels/Realtostaffprofilemodel.dart';
import 'package:http/http.dart' as https;

class ApiService{
  final FlutterSecureStorage _secureStorage=FlutterSecureStorage();
  static const String baseUrl="https://admin.dev.ajasys.com/api";

  Future<bool> login(String username,String password) async{
    final url=Uri.parse("$baseUrl/stafflogin");
    try{
      final response=await https.post(
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

      String token = await "ZXlKMWMyVnlibUZ0WlNJNkltUmxiVzlmWVdGMWMyZ2lMQ0p3WVhOemQyOXlaQ0k2SWtvNWVpTk5TVEJQTmxkTWNEQlZjbUZ6Y0RCM0lpd2lhV1FpT2lJeU1qUWlMQ0p3Y205a2RXTjBYMmxrSWpvaU1TSjk=";

      if (token == null) {

        return null;

      }

      final response = await https.post(

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


}