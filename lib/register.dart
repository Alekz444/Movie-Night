import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_night/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget{
  @override
  //_RegisterState createState() => _RegisterState();
  @override
  State<StatefulWidget> createState() => _RegisterState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;

class _RegisterState extends State<Register> {
   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    bool? _success; //PROBLEM!
    String _userEmail = '';

  /*
   @override
   void initState() {
    // TODO: implement initState
    super.initState();
    @override
    State<StatefulWidget> createState() => _RegisterState();
    register();
  }*/
  /*
  void register() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: "barry.allen@example.com",
      password: "SuperSecretPassword!"
    );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
         print('The account already exists for that email.');
      }
    } catch (e) {
        print(e);
    }
  }*/
  
   @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 150),
         decoration: new BoxDecoration(
            borderRadius: new BorderRadius.circular(16.0)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget> [
              
              Container(
                alignment: Alignment.center,
                child: Text("Create an account, it's free!",
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.w200,
                  fontSize: 20
                ),)
              ),
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
                )
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                )
              ),
              Container(
               padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
                child: TextField(
                  obscureText: true,
                  //controller: passwordController,
                  decoration: InputDecoration(
                    fillColor: Color.fromARGB(1, 176, 211, 245),
                    border: OutlineInputBorder(),
                    labelText: 'Confirm Password',
                  ),
                )
              ),
              Container(
                height: 50,
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: Text('Sign Up'),
                  onPressed: () async {
                   if (_formKey.currentState != null || _formKey.currentState!.validate()) { // CHANGE this to 2 if statements
                          await _register();
                          Navigator.popUntil(context, (route) => route.isFirst);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Dashboard()),
                      );
                    }
                  },
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.blueGrey,  
                    shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(40)
                    )          
                  ),
                  ),
              ),
              Container(
                    alignment: Alignment.center,
                    child: Text(_success == null
                        ? ''
                        : (_success!
                            ? 'Successfully registered $_userEmail'
                            : 'Registration failed')),
                  )
            ]
          )
        )
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Example code for registration, !User can be NULL
  Future<void> _register() async {
    final User? user = (await _auth.createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    ))
        .user;
    if (user != null) {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     prefs.setString('Username', user.email!);
     setState(() {
        _success = true;
        if(user.email != null){
          _userEmail = user.email!;
        }
      });
    } else {
      _success = false;
    }
  }
}
