import 'package:cms_flutter/screens/courses/courses.dart';
import 'package:flutter/material.dart';
import 'package:cms_flutter/models/user.dart';
import 'package:cms_flutter/services/moodle_client.dart' as moodle;

class Login extends StatelessWidget {
  static const String routeName = '/login';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Builder(
        // Create an inner BuildContext so that snackbar onPressed
        // methods can refer to Scaffold with Scaffold.of()
        // see https://api.flutter.dev/flutter/material/Scaffold/of.html#material.Scaffold.of.2
        builder: (BuildContext context) {
          return Center(
            child: TextField(
              decoration: InputDecoration(
                labelText: 'token',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) async {
                User user = await moodle.auth(value);
                if (user != null) {
                  Navigator.pushReplacementNamed(context, Courses.routeName,
                      arguments: user);
                } else {
                  Scaffold.of(context).hideCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Unauthorized'),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
