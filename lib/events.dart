import 'package:flutter/material.dart';
import 'package:flutter_tech/home_page_listing.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:timeago/timeago.dart' as timeago;

import 'detailsnewList.dart';
import 'drawarWidget.dart';
import 'newsList.dart';

class EventList extends StatefulWidget {
  @override
  _EventListState createState() => new _EventListState();
}

class _EventListState extends State<EventList> {
  Future<List<Articles>> _getNewsList() async {
    var data = await http
        .get("https://www.assisteduapp.com/old_files/Apiview/getEvents");
    var jsonData = json.decode(data.body);
    print(jsonData);

    List<Articles> aritcles = [];

    for (var u in jsonData) {
      Articles articles = Articles(u["id"], u["title"], u["description"],
          u["image"], u["entry_date"], u["status"]);
      aritcles.add(articles);
    }
    print(aritcles.length);

    return aritcles;
  }

  final fifteenAgo = new DateTime.now().subtract(new Duration(minutes: 15));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff0e264f),
          actions: <Widget>[Icon(Icons.settings)],
        ),
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text('Drawer Header'),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                title: Text('Home'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyNewApp()),
                  );
                },
              ),
              ListTile(
                title: Text('Events'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EventList()),
                  );
                },
              ),
              ListTile(
                title: Text('Articels'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewsList()),
                  );
                },
              ),
              ListTile(
                title: Text('News'),
                onTap: () {
                  // setState();
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewsList()),
                  );
                },
              ),
              ListTile(
                title: Text('Chats'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: Container(
          child: FutureBuilder(
            future: _getNewsList(),
            builder: (BuildContext context, AsyncSnapshot snapshots) {
              if (snapshots.data == null) {
                return Container(
                  child: Center(
                    child: Text("loading...."),
                  ),
                );
              } else {
                return ListView.builder(
                    itemCount: snapshots.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                          child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailsNewList(
                                    snapshots.data[index].image,
                                    snapshots.data[index].title,
                                    snapshots.data[index].description)),
                          );
                        },
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Text(""),
                            ),
                            Container(
                              margin: EdgeInsets.all(8),
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: NetworkImage(snapshots.data[index].image),
                                    fit: BoxFit.cover),
                              ),
                            ),

                            //  Icon(icons[index]),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 10.0,
                                  right: 10.0,
                                  top: 10.0,
                                  bottom: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      margin: const EdgeInsets.only(top: 5.0),
                                      child: Text(
                                        "Seminar",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12.0),
                                      )),
                                ],
                              ),
                            )
                          ],
                        ),
                      ));
                    });
              }
            },
          ),
        ),
      ),
    );
  }
}

class Articles {
  String id;
  String title;
  String description;
  String image;
  String entry_date;
  String status;

  Articles(this.id, this.title, this.description, this.image, this.entry_date,
      this.status);
}
