import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

class Todo with ChangeNotifier {

  String id = '';
  String name = '';
  bool completed = false;
  DateTime createdAt = DateTime.now();
  DateTime modifiedAt = DateTime.now();

  Todo({String id, String name, bool completed, dynamic createdAt, dynamic modifiedAt}){
    this.id = id;
    this.name = name;
    this.completed = completed;
    this.createdAt = ((createdAt == null) ? DateTime.now() : (createdAt is DateTime ? createdAt : (createdAt as Timestamp).toDate()));
    this.modifiedAt = ((modifiedAt == null) ? DateTime.now() : (modifiedAt is DateTime ? modifiedAt : (modifiedAt as Timestamp).toDate()));
  }

//  Todo(String id, String name, bool completed, dynamic createdAt, dynamic modifiedAt){
//
//  }

  //Todo({this.id, this.name, this.completed, this.createdAt, this.modifiedAt});

  // Getter and setter for name
//  getId() => this.id;
//  setId(id) => this.id = id;
//  getName() => this.name;
//  setName(name) => this.name = name;
//  getModifiedAt() => this.modifiedAt;
//  setModifiedAt(modifiedAt) => this.modifiedAt = modifiedAt;
//
//  isCompleted() => this.completed;
//  setCompleted(completed) => this.completed = completed;

  Todo copyWith(){
    return Todo(id:this.id, name:this.name, completed:this.completed, createdAt:this.createdAt, modifiedAt:this.modifiedAt);
  }

}
