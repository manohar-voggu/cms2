import 'dart:convert';
import 'dart:io';
import 'package:cms_flutter/models/user.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart';

final String host = 'td.bits-hyderabad.ac.in';
final String path = '/moodle/webservice/rest/server.php';

Future<User> auth(String token) async {
  var params = {
    'wsfunction': 'core_webservice_get_site_info',
    'moodlewsrestformat': 'json',
    'wstoken': '$token',
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
    return null;
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
    List decoded = json.decode(resp.body);
    return decoded;
  } else {
    return null;
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
    List decoded = json.decode(resp.body);
    return decoded;
  } else {
    return null;
  }
}

Future<File> getCacheFile(String url) async {
  return await DefaultCacheManager().getSingleFile(url);
}
