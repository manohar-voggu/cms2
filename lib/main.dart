import 'package:flutter/material.dart';
import 'package:cms_flutter/routes.dart';

void main() {
  runApp(CMS());
}

class CMS extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CMS',
      initialRoute: initialRoute,
      routes: routes,
    );
  }
}
