import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_night/dashboard.dart';
import 'package:movie_night/welcomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './loginPage.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends  StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Virtual Movie Night',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.grey[100]
      ),
      
      home: MyHomePage(),
    );
  }
}

Widget defaultHome = Container(
  color: Color(0xFF21303e)
);

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

 

  @override
  _MyHomePageState createState() => _MyHomePageState();
}



class _MyHomePageState extends State<MyHomePage> {
  

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUserLogin();
  }

  void checkUserLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
    String? email = prefs.getString('Username');
    
    if (email == null) {
      setState(() {
        defaultHome = WelcomePage();
      });
    } else {
      setState(() {
        defaultHome = Dashboard();
      });        
    }
  }
  

  @override
  Widget build(BuildContext context) {
    Color color = Color(0xFF21303e);
    return defaultHome;
  }
  }

  class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

