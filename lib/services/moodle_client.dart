import 'dart:convert';
import 'package:cms_flutter/models/user.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
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

  Future<List> getCourses(String token, int userId) async {
    var params = {
      'wsfunction': 'core_enrol_get_users_courses',
      'moodlewsrestformat': 'json',
      'wstoken': '$token',
      'userid': '$userId'
    };
    var uri = Uri.https(host, path, params);
    Response resp = await get(uri);
    if (resp.statusCode == 200) {
      List decoded = json.decode(resp.body) as List;
      return decoded;
    } else {
      return [];
    }
  }

  Future<List> getSections(String token, int courseId) async {
    var params = {
      'wsfunction': 'core_course_get_contents',
      'moodlewsrestformat': 'json',
      'wstoken': '$token',
      'courseid': '$courseId'
    };
    var uri = Uri.https(host, path, params);
    Response resp = await get(uri);
    if (resp.statusCode == 200) {
      List decoded = json.decode(resp.body) as List;
      return decoded;
    } else {
      return [];
    }
  }

  Future getCacheFile(String url) async {
    return await DefaultCacheManager().getSingleFile(url);
  }
}
