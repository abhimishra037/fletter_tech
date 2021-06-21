import 'package:flutter/material.dart';
import 'package:flutter_tech/chatList.dart';
import 'package:flutter_tech/home_page_listing.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:timeago/timeago.dart' as timeago;

import 'detailsnewList.dart';
import 'drawarWidget.dart';
import 'events.dart';

class ButtonTest extends StatefulWidget {
  @override
  _ButtonTest createState() => new _ButtonTest();
}

class _ButtonTest extends State<ButtonTest> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff0e264f),
          actions: <Widget>[Icon(Icons.settings)],
        ),
        body: Container(
          child: Center(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(25),
                  child: FlatButton(
                    child: Text(
                      'Student',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    color: Colors.blueAccent,
                    textColor: Colors.white,
                    onPressed: () {

/*
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyNewApp(),
                      ));
*/

                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(25),
                  child: FlatButton(
                    child: Text(
                      'Expert',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    color: Colors.blueAccent,
                    textColor: Colors.white,
                    onPressed: () {
                      String usreid= "e19799ab02e980ea1cf8bd613434e5f67e2d6a3384a97c4acd0b47bcd37a554e";
/*                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatPage(user:"Sara Baga",sm: sm,image:contact['image'],userId:usreid ,)),
                      );*/
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
