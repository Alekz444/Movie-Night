

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_night/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './register.dart';

class Login extends StatefulWidget {
  final TabController tabController;
  Login({required this.tabController});
  @override
  //_LoginState createState() => _LoginState();
  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late User user;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
  
    
    super.initState();
    //signIn();
  }

  @override
  void dispose() {
     _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
   }

  Future<void> _signIn() async {
    //FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      var firebaseResponse = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      
      if(firebaseResponse.user != null) {
        user = firebaseResponse.user!;
         SharedPreferences prefs = await SharedPreferences.getInstance();
         prefs.setString('Username', user.email!);
        Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '${user.email} signed in'),
        ),
      );
      }
      
    } catch (e) {
      Scaffold.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to sign in with Email & Password'),
        ),
      );
    }
  }
  /*try {
  
  UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: "barry.allen@example.com",
    password: "SuperSecretPassword!",
      );
} on FirebaseAuthException catch (e) {
  if (e.code == 'user-not-found') {
    print('No user found for that email.');
  } else if (e.code == 'wrong-password') {
    print('Wrong password provided for that user.');
  }
}*/

  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        //backgroundColor: Colors.purple[100],
        child: Container(
          padding: EdgeInsets.only(top: 150),
          margin: EdgeInsets.all(0),
          decoration: new BoxDecoration(
            borderRadius: new BorderRadius.circular(16.0),
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      //obscureText: true,
                      controller: _emailController,
                      decoration: InputDecoration(
                        fillColor: Color.fromARGB(1, 176, 211, 245),
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    )),
                Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextFormField(
                      obscureText: true,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        fillColor: Color.fromARGB(1, 176, 211, 245),
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    )),
                TextButton(
                  onPressed: () {
                    //forgot password screen
                  },
                  style: TextButton.styleFrom(
                    primary: Colors.blueGrey,
                  ),
                  child: Text('Forgot Password'),
                ),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      child: Text('Log In'),
                      onPressed: () async {
                        //final User user = _auth.currentUser;

                        if (_formKey.currentState == null)
                          print("CurrentState is null");
                        //if (_formKey.currentState != null || _formKey.currentState!.validate()) {
                        if (_formKey.currentState != null) {
                          if (_formKey.currentState!.validate()) {
                            await _signIn();
                            
                           Navigator.popUntil(context, (route) => route.isFirst);
                            
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Dashboard()),
                            );
                          }
                        }
                        //initState();
                        //print(nameController.text);
                        //print(passwordController.text);
                      },
                      style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.blueGrey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40))),
                    )),
                Container(
                    child: Row(
                  children: <Widget>[
                    Text('Do not have account?'),
                    TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.blueGrey,
                      ),
                      child: Text(
                        'Sign up',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        widget.tabController.animateTo(1);
                        //Navigator.push(
                        //context,
                        //MaterialPageRoute(builder: (context) => Register()),
                        // );
                        //signup screen
                      },
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ))
              ]),
        ),
      ),
    );
  }
}
