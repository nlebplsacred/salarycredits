import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:salarycredits/utility/api_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiToken {
  //final storage = const FlutterSecureStorage();

  Future<String> getToken() async {
    String token = "";
    try {
      var request = http.Request('POST', Uri.parse(APIHelper.tokenUrl));

      request.bodyFields = {
        'grant_type': 'password',
        'username': APIHelper.userName,
        'password': APIHelper.password
      };

      var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {

        String jsonBody = await response.stream.bytesToString();
        var data = jsonDecode(jsonBody);
        token = data['access_token'];

        //print('nitya$token');

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('tokenValue', token);
      }
    } catch (ex) {
      throw Exception(ex);
    }
    return token;
  }
}
