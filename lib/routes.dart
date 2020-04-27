import 'package:flutter/widgets.dart';
import 'package:cms_flutter/screens/sections.dart';
import 'package:cms_flutter/screens/courses.dart';
import 'package:cms_flutter/screens/login.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  '/login': (BuildContext context) => Login(),
  '/courses': (BuildContext context) => Courses(),
  '/section': (BuildContext context) => Sections(),
};
