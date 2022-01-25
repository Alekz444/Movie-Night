// import 'package:firebase_auth/firebase_auth.dart';

// class AuthenticationService {
//   final FirebaseAuth _firebaseAuth;

//   AuthenticationService(this._firebaseAuth);

//   Stream<User> get authStateChanges => _firebaseAuth.authStateChanges(); 

//   Future<String> signIn({String @required email, String @required password}) async {
    
//     try {
//       await _firebaseAuth.signInWithEmailAndPassword(email: @required email, password: @required password);
//       return "Signed in";
//     } on FirebaseAuthException catch (e) {
//         return e.message;
//     }
//   }

//   Future<String> signUp({String email, String password}) async {
//      try {
//       await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)(email: @required email, password: @required password);
//       return "Signed up";
//     } on FirebaseAuthException catch (e) {
//         return e.message;
//     }
//   }
// }