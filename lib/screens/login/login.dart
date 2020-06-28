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
      body: Builder(builder: (BuildContext context) {
        // Use a separate builder for scaffold,
        // so as to access it's context with Scaffold.of(context)
        return Center(
          child: TextField(
            decoration: InputDecoration(
              labelText: 'token',
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.teal,
                ),
              ),
            ),
            onSubmitted: (value) async {
              User user = await moodle.auth(value);
              if (user.userId != null) {
                Navigator.pushNamed(context, '/courses', arguments: user);
              } else {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Unauthorized'),
                  ),
                );
              }
            },
          ),
        );
      }),
    );
  }
}
