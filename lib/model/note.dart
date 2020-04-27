import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Note with ChangeNotifier {
  final String id;
  String title;
  String content;
  Color color;
  NoteState state;
  final DateTime createdAt;
  DateTime modifiedAt;

  Note({
    this.id,
    this.title,
    this.content,
    this.color,
    this.state,
    DateTime createdAt,
    DateTime modifiedAt,
  })  : this.createdAt = createdAt ?? DateTime.now(),
        this.modifiedAt = modifiedAt ?? DateTime.now();

  static List<Note> fromQuery(QuerySnapshot snapshot) =>
      snapshot != null ? toNotes(snapshot) : [];

  void update(Note other, {bool updateTimestamp = true}) {
    title = other.title;
    content = other.content;
    color = other.color;
    state = other.state;

    if (updateTimestamp || other.modifiedAt == null) {
      modifiedAt = DateTime.now();
    } else {
      modifiedAt = other.modifiedAt;
    }
    notifyListeners();
  }

  Note copy({bool updateTimestamp = false}) => Note(
        id: id,
        createdAt:
            (updateTimestamp || createdAt == null) ? DateTime.now() : createdAt,
      )..update(this, updateTimestamp: updateTimestamp);
}

enum NoteState {
  unspecified,
  pinned,
  archived,
  deleted,
}

List<Note> toNotes(QuerySnapshot query) =>
    query.documents.map((d) => toNote(d)).where((n) => n != null).toList();

Note toNote(DocumentSnapshot doc) => doc.exists
    ? Note(
        id: doc.documentID,
        title: doc.data['title'],
        content: doc.data['content'],
        state: NoteState.values[doc.data['state'] ?? 0],
        color: _parseColor(doc.data['color']),
        createdAt:
            DateTime.fromMillisecondsSinceEpoch(doc.data['createdAt'] ?? 0),
        modifiedAt:
            DateTime.fromMillisecondsSinceEpoch(doc.data['modifiedAt'] ?? 0),
      )
    : null;

Color _parseColor(num colorInt) => Color(colorInt ?? 0xFFFFFFFF);
