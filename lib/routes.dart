import 'package:flutter/widgets.dart';
import 'package:cms_flutter/screens/sections/sections.dart';
import 'package:cms_flutter/screens/courses/courses.dart';
import 'package:cms_flutter/screens/login/login.dart';

final String initialRoute = Login.routeName;

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  Login.routeName: (BuildContext context) => Login(),
  Courses.routeName: (BuildContext context) => Courses(),
  Sections.routeName: (BuildContext context) => Sections(),
};
