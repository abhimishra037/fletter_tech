import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:flutter_tech/alertDialog.dart';
import 'package:flutter_tech/chatList.dart';
import 'package:http/http.dart' as http;

import 'chatsScreen.dart';
import 'events.dart';
import 'new_chat_screen.dart';
import 'newsList.dart';

class MyNewApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(home: new SearchByCityOrPerson());
  }
}

class SearchByCityOrPerson extends StatefulWidget {
  SearchByCityOrPerson({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SearchByCityOrPerson createState() => _SearchByCityOrPerson();
}

class _SearchByCityOrPerson extends State<SearchByCityOrPerson>
    with SingleTickerProviderStateMixin {

  Future<List<Experts>> _getNewList;
  List<String> _persons = [
    "John Smith",
    "Alex Johnson",
    "Jane Doe",
    "Eric Johnson",
    "Michael Eastwood",
    "Benjamin Woods"
  ];
  List<String> _cities = [];
  List<Experts> expert = [];

  Future<List<Experts>> _getNewsList() async {
    print('skljnffejf');
    String url = "https://assisteduapp.com/old_files/api/getAgentTimeSlot";
    Map data = {
      "device_code": "a67e4a7fe95bd667",
      "sdk_code": 29,
      "device_model": "Xiaomi Redmi Note 9 Pro Max",
    };
    Map dataUser = {
      "t":
          "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJyZWdfaWQiOiJjMTYyNzkxOWRhZjFlYWIzMWQ0NGIyMmZkMGMwNzEyYmE5YWFkZmExMjM2ZDRhMmU0YjJmZWM4ZWFjMWRmMWE5IiwidHlwZSI6IjEifQ.K1rE45yiztuPDTlQltX25YVYFX-76WpVIKgIPVht0zg",
      "from": 0,
      "to": 20,
      "type": "8",
      "temp1": "",
    };

    List datalist = [data, dataUser];

    String test = json.encode(datalist);
    String paramName = 'data'; // give the post param a name
    String formBody = paramName + '=' + Uri.encodeQueryComponent(test);
    List<int> bodyBytes = utf8.encode(formBody); // utf8 encode
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    var response = await http.post(url, body: bodyBytes, headers: headers);

    print("kkk");
    // Map<String, dynamic> map = json.decode(response.body);
    // print(response.body);

    var jsonData = json.decode(response.body);

    for (var u in jsonData) {
      Experts experts =
          Experts(u["i"], u["n"], u["img"], u["qlt"], u["c"], u["sm"]);
      expert.add(experts);
    }
    for (var u in jsonData) {
      //String experts = Experts(u["n"]);
      _cities.add(u["n"]);
    }
    print(_cities.length);
    // print(expert[1].Sm);
    // print(expert);

    return expert;
  }

  List<String> _filteredList = [];

  List<String> _personsList = [];

  TextEditingController controller = new TextEditingController();

  TabController _tabController;

  String filter = "";
  String persons = "";
  Icon actionIcon = new Icon(Icons.search);
  Widget appBarTitle = new Text(
    "Search...",
    style: TextStyle(color: Colors.black),
  );

  void _handleTabIndex() {
    setState(() {});
  }

  @override
  void dispose() {
    controller.dispose();
    _tabController.removeListener(_handleTabIndex);
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    print("init");

    check().then((intenet) {
      if (intenet != null && intenet) {
        // Internet Present Case
      }else{
        _showMyDialog(context);
      }
      // No-Internet Case
    });

    // _getNewsList();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);
    setState(() {
      _filteredList = _cities;
      _personsList = _persons;
    });
    controller.addListener(() {
      if (controller.text.isEmpty) {
        setState(() {
          filter = "";
          persons = "";
          _filteredList = _cities;
          _personsList = _persons;
        });
      } else {
        setState(() {
          filter = controller.text;
          persons = controller.text;
        });
      }
    });
    _getNewList=_getNewsList();


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("kksksks");

    ListTile personListTile(
            String bookOrPerson, String country, img, alt, List sm, String i) =>
        ListTile(
            onTap: () async {
             // print(sm[0]['social_media_number']);
             // print(i);
             // print(sm.length);
              if (sm.length != 0) {
                 print(sm.length);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatPage(
                            user: bookOrPerson,
                            sm: sm,
                            image: img,
                            userId: i,
                          )),
                );

/*                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatScreen(
                            user: bookOrPerson,
                            sm: sm[0]['social_media_number'],
                          )),
                );*/
              } else {
                print("sgsggsgsg");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatPage(
                            user: bookOrPerson,
                            sm: sm,
                            image: img,
                            userId: i,
                          )),
                );
              }
              //  final Product prodName = await _asyncSimpleDialog(context);
            },
            //   leading: Icon(icons[index]),
            title: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(8),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage('assest/profile.png')),
                  ),
                ),

                // Icon(icons[index]),

                Container(
                  margin: const EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        bookOrPerson,
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            alt,
                            style:
                                TextStyle(color: Colors.grey, fontSize: 12.0),
                          )),
                      Container(
                        margin: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          country,
                          style: TextStyle(color: Colors.grey, fontSize: 12.0),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          "Available Communication",
                          style: TextStyle(color: Colors.pink, fontSize: 12.0),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ));
    Card personCard(bookOrPerson, country, image, qlt, List sm, i) => Card(
          child: Container(
            decoration: BoxDecoration(color: Colors.white),
            child: personListTile(bookOrPerson, country, image, qlt, sm, i),
          ),
        );

    if ((filter.isNotEmpty)) {
      List<String> tmpList = new List<String>();
      for (int i = 0; i < _filteredList.length; i++) {
        if (_filteredList[i].toLowerCase().contains(filter.toLowerCase())) {
          tmpList.add(_filteredList[i]);
        }
      }
      _filteredList = tmpList;
    }

    if ((persons.isNotEmpty)) {
      List<String> _tmpList2 = new List<String>();
      for (int i = 0; i < _personsList.length; i++) {
        if (_personsList[i].toLowerCase().contains(persons.toLowerCase())) {
          _tmpList2.add(_personsList[i]);
        }
      }
      _personsList = _tmpList2;
    }

    final appBody = TabBarView(controller: _tabController, children: [
      Container(
          child: FutureBuilder(
              future: _getNewList,
              builder: (BuildContext context, AsyncSnapshot snapshots) {
                if (snapshots.hasData) {
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: _cities == null ? 0 : _filteredList.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (_cities.isEmpty) {
                        print("list3");

                        return Container(
                          child: Center(
                            child: Text("loading...."),
                          ),
                        );
                      } else {
                        print("list");
                        return personCard(
                            _filteredList[index],
                            expert[index].c,
                            expert[index].img,
                            expert[index].qlt,
                            expert[index].Sm,
                            expert[index].i);
                      }
                    },
                  );
                } else {
                  return Container(
                    child: Center(
                      child: Text("loading...."),
                    ),
                  );
                }
              })),
      Container(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: _persons == null ? 0 : _personsList.length,
          itemBuilder: (BuildContext context, int index) {
            print("list2");

            return personCard(
                _personsList[index],
                expert[index].c,
                expert[index].img,
                expert[index].qlt,
                expert[index].Sm,
                expert[index].i);
          },
        ),
      ),
    ]);

    final appTopAppBar = AppBar(
      elevation: 1.0,
      backgroundColor: Colors.white,
      bottom: TabBar(controller: _tabController, tabs: [
        Row(children: [
          Icon(
            Icons.home,
            color: Colors.pink,
          ),
          SizedBox(width: 5),
          Text(
            "Assisted Expert",
            style: TextStyle(color: Colors.black),
          )
        ]),
        Row(children: [
          Icon(Icons.person, color: Colors.pink),
          SizedBox(width: 5),
          Text("Agent", style: TextStyle(color: Colors.black))
        ]),
      ]),
      title: appBarTitle,
      actions: <Widget>[
        new IconButton(
          color: Colors.black,
          icon: actionIcon,
          onPressed: () {
            setState(() {
              if (this.actionIcon.icon == Icons.search) {
                this.actionIcon = new Icon(Icons.close);
                this.appBarTitle = new TextField(
                  controller: controller,
                  decoration: new InputDecoration(
/*
                    prefixIcon: new Icon(Icons.search, color: Colors.black),
*/
                    hintText: "Search...",
                    hintStyle: new TextStyle(color: Colors.black),
                  ),
                  style: new TextStyle(
                    color: Colors.black,
                  ),
                  autofocus: true,
                  cursorColor: Colors.black,
                );
              } else {
                this.actionIcon = new Icon(Icons.search);
                this.appBarTitle = new Text(
                    _tabController.index == 0 ? "Assisted Expert" : "Agent");
                _filteredList = _cities;
                _personsList = _persons;
                controller.clear();
              }
            });
          },
        ),
      ],
    );




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
          body: Scaffold(
            backgroundColor: Colors.white,
            appBar: appTopAppBar,
            body: appBody,
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                print("Clicked");

                //  Navigator.pushNamed(context, '/newsList');

                // Add your onPressed code here!
              },
              child: Icon(Icons.filter_9_plus),
              backgroundColor: const Color(0xffffb7a1),
            ),
          )),
    );
  }
}

class Experts {
  String i;
  String n;
  String img;
  String qlt;
  String c;
  List Sm;

  Experts(this.i, this.n, this.img, this.qlt, this.c, this.Sm);
}

class Sm {
  String social_media_id;
  String social_media_number;
  String social_media;
  String redirect_link;

  Sm(this.social_media_id, this.social_media_number, this.social_media,
      this.redirect_link);
}
Future<bool> check() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return true;
  }
  return false;
}
Future<void> _showMyDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Alert'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('No Internet Connection Available'),
             // Text('Would you like to approve of this message?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('close'),
            onPressed: () {
              exit(0);
             // Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}