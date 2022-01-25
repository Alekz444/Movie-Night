import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_night/MovieReader.dart';
import 'package:movie_night/adminPage.dart';

import './menuDrawer.dart';
import './dashboard.dart';
import 'AdminPage.dart';
import 'data/event.dart' as ev;
import 'data/event_dao.dart';


class Dashboard extends StatefulWidget {
  Dashboard({ Key? key, }) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cast your vote now!')
      ),
      drawer: MenuDrawer(),
      body: SingleChildScrollView(
        child: Center(
          child: MyAppH())),
      );
    
  }



}



