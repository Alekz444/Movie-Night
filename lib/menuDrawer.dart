import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_night/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './main.dart';
import './adminPage.dart';

class MenuDrawer extends StatefulWidget {
  //const ({ Key? key }) : super(key: key);
  @override
  _State createState() => _State();
}

class _State extends State<MenuDrawer> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.purple[700],
                fontSize: 25
              )
            ),
            decoration: BoxDecoration(
              color: Colors.purple[200],
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/neonMovie.jpg'),
              )
            ),
          ),
          ListTile(
            title: Text('Log Out'),
            onTap: () {
              _logOut();          
             // Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Admin Page'),
            onTap: () {
              _goToAdminPage();
            },

          ),
          ListTile(
            title: Text('Event'),
            onTap: () {
              _goToDashboard();
            }
          )
        ]
      )
    );
  }
 
 void _logOut () async {
    _auth.signOut(); 
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Remove String
    prefs.remove("Username"); 
    Navigator.popUntil(context, (route) => route.isFirst);

    Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => MyHomePage(),
          )
        );
 }

 void _goToAdminPage() {
   //?? like this?
   Navigator.popUntil(context, (route) => route.isFirst);

    Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => AdminPage(),
          )
        );
 }

 void _goToDashboard() {
   Navigator.popUntil(context, (route) => route.isFirst);

    Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Dashboard(),
          )
        );
 }
  
}

/* class LogOut extends StatefulWidget {
  const LogOut({ Key? key }) : super(key: key);

  @override
  _LogOutState createState() => _LogOutState();
}

class _LogOutState extends State<LogOut> {
   late User user;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  var firebaseResponse = await _auth.signOut()

  @override
  Widget build(BuildContext context) {
    return Container(
     
    );
  }
} */

