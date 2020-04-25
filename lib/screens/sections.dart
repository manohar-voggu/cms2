import 'package:cms_flutter/models/course.dart';
import 'package:cms_flutter/models/user.dart';
import 'package:cms_flutter/services/moodle_client.dart';
import 'package:flutter/material.dart';

class Section extends StatefulWidget {
  Section({Key key}) : super(key: key);

  @override
  _SectionState createState() => _SectionState();
}

class _SectionState extends State<Section> {
  @override
  Widget build(BuildContext context) {
    Map<String, Object> args = ModalRoute.of(context).settings.arguments;
    User user = args['user'];
    Course course = args['course'];

    return Scaffold(
      appBar: AppBar(
        title: Text(course.name),
      ),
      body: FutureBuilder(
          future: MoodleClient().getSections(user.token, course.id),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  // hide sections which have no modules
                  if (snapshot.data[index]['modules'].length == 0) return null;

                  List modules = snapshot.data[index]['modules'];
                  return Card(
                    child: ExpansionTile(
                      title: Text(snapshot.data[index]['name']),
                      children: modules.map((module) {
                        return ListTile(
                          title: Text(module['name']),
                          onTap: () {
                            //TODO: show contents of module
                          },
                        );
                      }).toList(),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child:
                    Text('Failed to load course sections: ${snapshot.error}'),
              );
            } else {
              return Center(
                child: Text('Loading course sections'),
              );
            }
          }),
    );
  }
}
