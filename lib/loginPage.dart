import 'package:flutter/material.dart';
import 'package:movie_night/register.dart';

import './login.dart';

class LoginPage extends StatefulWidget {
  
  const LoginPage({ Key? key }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin{
  TabController? _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: kMinInteractiveDimension,
        backgroundColor: Colors.blueGrey,
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Log In'),
            Tab(text: 'Sign Up'),
          ]
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Login(tabController: _tabController!,),
          Register()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        onPressed: (){
          Navigator.pop(context);
        },
        child: Icon(Icons.navigate_before_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );        
  }
}