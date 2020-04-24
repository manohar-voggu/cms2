import 'dart:convert';
import 'package:cms_flutter/models/user.dart';
import 'package:http/http.dart';

class MoodleClient {
  final String host = 'td.bits-hyderabad.ac.in';
  final String path = '/moodle/webservice/rest/server.php';

  Future<User> authenticate(String token) async {
    var params = {
      'wsfunction': 'core_webservice_get_site_info',
      'moodlewsrestformat': 'json',
      'wstoken': '$token'
    };
    var uri = Uri.https(host, path, params);
    Response resp = await get(uri);
    if (resp.statusCode == 200) {
      var decoded = json.decode(resp.body);
      return User(
        userId: decoded['userid'],
        fullName: decoded['fullname'],
        email: decoded['username'],
        dpUrl: decoded['userpictureurl'],
        token: token,
      );
    } else {
      return User();
    }
  }
}
