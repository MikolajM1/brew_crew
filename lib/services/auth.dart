import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
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
  Future signIn({String email, String passwd}) async {
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: passwd);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    }catch (e){
      print(e.toString());
      return null;
    }
  }

  //register with email and passwd
  Future registerWithEmailAndPasswd({String email, String passwd}) async {
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: passwd);
      FirebaseUser user = result.user;
      //create a new document for the user with thr uid
      await DatabaseService(uid: user.uid).updateUserData('0', 'new crew member', 100);
      return _userFromFirebaseUser(user);
    }catch (e){
      print(e.toString());
      return null;
    }
  }

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