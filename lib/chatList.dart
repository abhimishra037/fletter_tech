import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tech/home_page_listing.dart';
import 'dart:convert';
import 'events.dart';
import 'new_chat_screen.dart';
import 'newsList.dart';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => new _ChatListState();
}

class _ChatListState extends State<ChatList> {

  Query _ref;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _ref = FirebaseDatabase.instance.reference()
        .child('Details').orderByKey();
  }

  Widget _userItem (Map contact){
    return Container(child: Card(
        child: InkWell(
          onTap: () {
            print(contact['sm']);

            List sm = jsonDecode(contact['sm']);
            print("dddd$sm");
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatPage(user:contact['name'],sm: sm,image:contact['image'],userId:contact['anotherUserId'] ,)),
            );

           /* Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatScreenTwo(user:contact['name'],sm: contact['number'],image: "",messagess: contact['message'],)),
            );
        */  },
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
                      image: AssetImage('assest/profile.png'),
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
                          contact['name'],
                          style: TextStyle(
                              color: Colors.black, fontSize: 14.0,fontWeight: FontWeight.bold),
                        )) ,
                    Container(
                        margin: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          contact['message'],
                          style: TextStyle(
                              color: Colors.grey, fontSize: 12.0),
                          overflow: TextOverflow.ellipsis,

                        )),
                  ],
                ),
              )
            ],
          ),
        )),);

  }
/*
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
*/

  final fifteenAgo = new DateTime.now().subtract(new Duration(minutes: 15));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff091730),
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

          child: FirebaseAnimatedList(query:_ref ,itemBuilder:(BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index){
            Map contact = snapshot.value;
             return _userItem(contact);
          }),
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
