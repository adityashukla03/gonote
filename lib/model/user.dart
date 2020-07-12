import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

@immutable
class CurrentUser {

  final bool isInitialValue;
  final FirebaseUser data;

  const CurrentUser._(this.data, this.isInitialValue);
  factory CurrentUser.create(FirebaseUser data) => CurrentUser._(data, false);

  /// The initial empty instance.
  static const initial = CurrentUser._(null, true);

}

class User {

  final String uid;
  User({this.uid});

}

class UserData {

  dynamic authKey;
  final String uid;
  final String displayName;
  final String email;
  final bool emailVerified;
  final String phoneNumber;
  final String photoUrl;

  UserData({this.authKey = const {}, this.uid, this.displayName, this.email, this.emailVerified = false, this.phoneNumber, this.photoUrl});

}