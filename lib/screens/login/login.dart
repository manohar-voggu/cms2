import 'package:cms_flutter/models/user.dart';
import 'package:cms_flutter/services/moodle_client.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
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
            decoration: InputDecoration(labelText: 'token'),
            onSubmitted: (value) async {
              User user = await MoodleClient().authenticate(value);
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
