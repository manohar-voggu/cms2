import 'dart:io';
import 'package:cms_flutter/models/course.dart';
import 'package:cms_flutter/models/user.dart';
import 'package:cms_flutter/services/moodle_client.dart' as moodle;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:open_file/open_file.dart' as opFile;

class Sections extends StatefulWidget {
  static const String routeName = '/sections';
  Sections({Key key}) : super(key: key);

  @override
  _SectionsState createState() => _SectionsState();
}

class _SectionsState extends State<Sections> {
  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

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
          future: moodle.getSections(user.token, course.id),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  List modules = snapshot.data[index]['modules'];

                  // hide sections which have no modules
                  if (modules == null) return null;
                  if (modules.length == 0) return null;
                  List<Widget> moduleWidgets = modules.map((module) {
                    // get modicon as widget.
                    // modicon is image for resources and svg for others
                    final Widget modIcon = FutureBuilder(
                      future: moodle.getCacheFile(module['modicon']),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          if (module['modname'] == 'resource') {
                            return Image.file(snapshot.data);
                          } else {
                            return SvgPicture.file(snapshot.data);
                          }
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    );

                    List contents = module['contents'];
                    if (contents != null) {
                      List<Widget> contentWidgets = contents.map((content) {
                        int contentIndex = contents.indexOf(content);
                        return ListTile(
                          dense: contents.length != 1,
                          title: Text(content['filename']),
                          onTap: () async {
                            switch (module['modname']) {
                              case 'folder':
                              case 'resource':
                                File file = await moodle.getCacheFile(
                                    '${contents[contentIndex]['fileurl']}&token=${user.token}');
                                opFile.OpenFile.open(file.path);
                                break;
                              case 'url':
                                _launchInBrowser(
                                    '${contents[contentIndex]['fileurl']}');
                                break;
                            }
                          },
                        );
                      }).toList();
                      if (contents.length == 1) {
                        return contentWidgets[0];
                      }
                      return ExpansionTile(
                        leading: modIcon,
                        title: Text(module['name']),
                        children: contentWidgets,
                      );
                    } else {
                      if (module['modname'] == 'forum') {
                        // show announcements
                        return Text(module['name']);
                      } else if (module['description'] != null) {
                        List<dom.Element> links = parse(module['description'])
                            .getElementsByTagName('a');
                        bool linksFound = links.length != 0;
                        return ListTile(
                          leading: Icon(Icons.link),
                          title: Text(module['name']),
                          onTap: () async {
                            if (linksFound) {
                              // launch all found links
                              links.forEach((link) {
                                _launchInBrowser(
                                  link.attributes['href'],
                                );
                              });
                            } else {
                              // open module in CMS website
                              _launchInBrowser(module['url']);
                            }
                          },
                        );
                      } else {
                        // unhandled modname
                        return ListTile(
                          leading: Icon(Icons.link),
                          title: Text(module['name']),
                          onTap: () {
                            // open module in CMS website
                            _launchInBrowser(module['url']);
                          },
                        );
                      }
                    }
                  }).toList();
                  // add section summary(if present) to start of list
                  if (snapshot.data[index]['summary'] != null) {
                    moduleWidgets.insert(
                      0,
                      Text(
                        parse(snapshot.data[index]['summary']).body.text,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  }
                  return Card(
                    child: ExpansionTile(
                      // section name as title
                      title: Text(snapshot.data[index]['name']),
                      children: moduleWidgets,
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
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
