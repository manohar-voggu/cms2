import 'package:flutter/widgets.dart';
import 'package:cms_flutter/screens/sections/sections.dart';
import 'package:cms_flutter/screens/courses/courses.dart';
import 'package:cms_flutter/screens/login/login.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  '/login': (BuildContext context) => Login(),
  '/courses': (BuildContext context) => Courses(),
  '/section': (BuildContext context) => Sections(),
};
