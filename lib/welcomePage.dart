import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_night/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './main.dart';
import './loginPage.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({ Key? key }) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
       // appBar: AppBar(
         // title: Text(widget.title),
        //),
        
        body: Center(
          child: Container(
              color: Color(0xFF21303e),
              child: Column(
                children: <Widget>[
                  Image.asset('assets/images/movieNightGIF.gif'),
                  Text("Welcome to Virtual Friday Movie Night!", style: Theme.of(context).textTheme.headline3),          
              ]
           )
          
        )
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
          child: Icon(Icons.navigate_next_rounded),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}