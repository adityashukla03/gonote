import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {

  AuthService._privateConstructor();

  static final AuthService _instance = AuthService._privateConstructor();

  factory AuthService() {
    return _instance;
  }

  final userCollection = Firestore.instance.collection('users');

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],);

  String errMsg;

  //Create User Obj based on FBUser
//  User _userFromFBUser(FirebaseUser user) {
//    return user != null ? User(uid: user.uid) : null;
//  }

//  Stream<User> get user {
//    return _auth.onAuthStateChanged.map(_userFromFBUser);
//  }

  Future signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      dynamic result = await _auth.signInWithCredential(credential);
      if(result != null && result is AuthResult){
        final user = result.user;
        if(user != null){
          try{
            final timestamp = DateTime.now();
            Map<String, dynamic> data = {
              'uid': user.uid,
              'displayName': user.displayName ?? '',
              'email': user.email ?? '',
              'emailVerified':user.isEmailVerified ?? false,
              'phoneNumber':user.phoneNumber ?? '',
              'photoUrl':user.photoUrl ?? '',
              'modifiedAt': timestamp.millisecondsSinceEpoch,
            };
            await userCollection.document(user.uid).updateData(data);
            return result;
          } catch(e){
            print(e.toString());
            if (e is PlatformException && e.code == 'Error performing updateData'){
              try{
                final timestamp = DateTime.now();
                Map<String, dynamic> data = {
                  'uid': user.uid,
                  'displayName': user.displayName ?? '',
                  'email': user.email ?? '',
                  'emailVerified':user.isEmailVerified ?? false,
                  'phoneNumber':user.phoneNumber ?? '',
                  'photoUrl':user.photoUrl ?? '',
                  'createdAt': timestamp.millisecondsSinceEpoch,
                };
                await userCollection.document(user.uid).setData(data);
                return result;
              } catch(e){
                await signout();
                return e;
              }
            } else {
              await signout();
              return e;
            }
          }
        }
      }
      else {return result;}
    } catch (e) {
      if(e is NoSuchMethodError){
        try{
          dynamic result = _auth.signInWithEmailAndPassword(email: "", password: "");
          return result;
        } catch(e){
          return e;
        }
      } else {
        return e;
      }
    }
  }

  //Method to login email/password
  Future loginWithEmailPwd(String email, String password) async {
    try {
      dynamic result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if(result != null && result is AuthResult){
        final user = result.user;
        if(user != null){
          try{
            final timestamp = DateTime.now();
            Map<String, dynamic> data = {
              'uid': user.uid,
              'displayName': user.displayName ?? '',
              'email': user.email ?? '',
              'emailVerified':user.isEmailVerified ?? false,
              'phoneNumber':user.phoneNumber ?? '',
              'photoUrl':user.photoUrl ?? '',
              'modifiedAt': timestamp.millisecondsSinceEpoch,
            };
            await userCollection.document(user.uid).updateData(data);
            return result;
          } catch(e){
            print(e.toString());
            if (e is PlatformException && e.code == 'Error performing updateData'){
              try{
                final timestamp = DateTime.now();
                Map<String, dynamic> data = {
                  'uid': user.uid,
                  'displayName': user.displayName ?? '',
                  'email': user.email ?? '',
                  'emailVerified':user.isEmailVerified ?? false,
                  'phoneNumber':user.phoneNumber ?? '',
                  'photoUrl':user.photoUrl ?? '',
                  'createdAt': timestamp.millisecondsSinceEpoch,
                };
                await userCollection.document(user.uid).setData(data);
                return result;
              } catch(e){
                await signout();
                return e;
              }
            } else {
              await signout();
              return e;
            }
          }
        }
      }
      else {return result;}
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

  //Register  with email
  Future registerwithEmailPwd(String email, String password) async {
    try {
      dynamic result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if(result != null && result is AuthResult){
        final user = result.user;
        if(user != null){
          try{
            final timestamp = DateTime.now();
            Map<String, dynamic> data = {
              'uid': user.uid,
              'displayName': user.displayName ?? '',
              'email': user.email ?? '',
              'emailVerified':user.isEmailVerified ?? false,
              'phoneNumber':user.phoneNumber ?? '',
              'photoUrl':user.photoUrl ?? '',
              'modifiedAt': timestamp.millisecondsSinceEpoch,
            };
            await userCollection.document(user.uid).updateData(data);
            return result;
          } catch(e){
            print(e.toString());
            if (e is PlatformException && e.code == 'Error performing updateData'){
              try{
                final timestamp = DateTime.now();
                Map<String, dynamic> data = {
                  'uid': user.uid,
                  'displayName': user.displayName ?? '',
                  'email': user.email ?? '',
                  'emailVerified':user.isEmailVerified ?? false,
                  'phoneNumber':user.phoneNumber ?? '',
                  'photoUrl':user.photoUrl ?? '',
                  'createdAt': timestamp.millisecondsSinceEpoch,
                };
                await userCollection.document(user.uid).setData(data);
                //final notesCollection = userCollection.document(user.uid).collection('notes');
                //await userCollection.document(user.uid).collection('notes').document().setData({});
                //await userCollection.document(user.uid).collection('todo').document().setData({});
//                await userCollection.document(user.uid).collection(collectionPath);
//                await userCollection.document(user.uid).collection('todo').add({});
                //final todoCollection = Firestore.instance.collection('users').document(user.uid).collection('todo');
                return result;
              } catch(e){
                await signout();
                return e;
              }
            } else {
              await signout();
              return e;
            }
          }
        }
      }
      else {return result;}
    } catch(e) {
      print(e.toString());
      return e;
    }
  }

  //signout
  Future signout() async {
    try {
      await _auth.signOut();
      bool response = await _googleSignIn.isSignedIn();
      if (response == true) {
        await _googleSignIn.signOut();
      }
      await _googleSignIn.disconnect();
    } catch(e) {
      print(e.toString());
      //return e;
    }
  }

}