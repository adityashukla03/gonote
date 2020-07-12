import 'package:cloud_firestore/cloud_firestore.dart';

//class DatabaseService {
//
//  final String uid;
//  DatabaseService({this.uid});
//
//  //collection reference
//  final CollectionReference _collectionRef = Firestore.instance.collection('users');
//
//  Future updateUserData(String sugers, String name, int strength) async {
//    return await _collectionRef.document(uid).setData({
//      'sugers':sugers,
//      'name':name,
//      'strength':strength
//    });
//  }
//
//  //get brew list from spashots
//  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
//    return snapshot.documents.map((doc){
//      return Brew(
//          name: doc.data['name'] ?? '',
//          strength: doc.data['strength'] ?? 0,
//          sugers: doc.data['sugers'] ?? '0'
//      );
//    }).toList();
//  }
//
//  //Get User data from snapshot
//  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
//    return UserData (
//      uid: uid,
//      name: snapshot.data['name'],
//      sugers: snapshot.data['sugers'],
//      strength: snapshot.data['strength'],
//    );
//  }
//
//  //get brew stream
//  Stream<List<Brew>> get brews {
//    return brewCollection.snapshots().map(_brewListFromSnapshot);
//  }
//
//  //Stream for Userdata
//  Stream<UserData> get userData {
//    return brewCollection.document(uid).snapshots().map(_userDataFromSnapshot);
//  }
//
//}