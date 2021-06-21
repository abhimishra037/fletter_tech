import 'package:flutter/material.dart';
import 'package:flutter_tech/chatList.dart';
import 'package:flutter_tech/home_page_listing.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:timeago/timeago.dart' as timeago;

import 'detailsnewList.dart';
import 'drawarWidget.dart';
import 'events.dart';

class NewsList extends StatefulWidget {
  @override
  _NewsListState createState() => new _NewsListState();
}

class _NewsListState extends State<NewsList> {
  Future<List<Articles>> _getNewsList() async {
    var data = await http
        .get("https://www.assisteduapp.com/old_files/Apiview/getnews");
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatList()),
                  );
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
                        margin: EdgeInsets.all(10.0),
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
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              children: <Widget>[
                                Image.network(snapshots.data[index].image),
                                Text(
                                  snapshots.data[index].title,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      timeago.format(fifteenAgo),
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text("   1 minutes read",
                                        style: TextStyle(color: Colors.grey)),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
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
