import 'package:flutter/material.dart';
import 'package:cms_flutter/services/moodle_client.dart';
import 'package:cms_flutter/models/user.dart';

class Courses extends StatefulWidget {
  Courses({Key key}) : super(key: key);
  @override
  _CoursesState createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  @override
  Widget build(BuildContext context) {
    User user = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Courses'),
      ),
      body: FutureBuilder(
          future: MoodleClient().getCourses(user.token, user.userId),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      title: Text(
                        snapshot.data[index]['fullname'],
                      ),
                      onTap: () {
                        //TODO: show course section page
                      },
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Failed to load courses: ${snapshot.error}'),
              );
            } else {
              return Center(
                child: Text('Loading courses'),
              );
            }
          }),
    );
  }
}
