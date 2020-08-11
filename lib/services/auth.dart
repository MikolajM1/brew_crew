import 'package:brew_crew/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create custom user object based on FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
        .map(_userFromFirebaseUser);
  }

  // sign in anon
  Future singInAnon() async {
    try{
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    }catch (e){
      print(e.toString());
      return null;
    }
  }

  //email and passwd sign in

  //register with email and passwd

  //sign out
  Future signOut() async {
    try{
      return await _auth.signOut();
    }catch (e){
      print(e.toString());
      return null;
    }
  }
}