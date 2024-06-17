

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthService {

  User? _user; // to store the credentials of the user 
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance; // creating a firebase auth instance

  User? get user{ // this is to get the user credentials through the authservice class
    return _user;
  }
  
  AuthService(){
    _firebaseAuth.authStateChanges().listen(authStateChangesStreamListner);
  }

  Future<bool> login(String Email, String Password) async {
    try {
      final credentials =  await _firebaseAuth.signInWithEmailAndPassword(email: Email, password: Password);
      if (credentials.user != null) { // if the credentials of the user is not null
        _user = credentials.user; // storing the credentials  of the user
        return true; // login Successful
      }
    } catch (e) {
      print(e);
    }
    return false; // the user has not entered the credntials i.e that credentials of the user is null
  }

  void authStateChangesStreamListner (User ? user){
    if (user != null) {
      _user = user;
    } else {
      _user = null;
    }
  }

  Future<bool> logout() async{
    try {
      await _firebaseAuth.signOut();
      return true; 
    } catch (e) {
      print(e);
    }
    return false;
  }
}