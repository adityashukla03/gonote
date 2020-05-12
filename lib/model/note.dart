import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Note with ChangeNotifier {
  final String id;
  String title;
  String content;
  NoteState state;
  final DateTime createdAt;
  DateTime modifiedAt;

  Note({
    this.id,
    this.title,
    this.content,
    this.state,
    DateTime createdAt,
    DateTime modifiedAt,
  })  : this.createdAt = createdAt ?? DateTime.now(),
        this.modifiedAt = modifiedAt ?? DateTime.now();

  static List<Note> fromQuery(QuerySnapshot snapshot) =>
      snapshot != null ? toNotes(snapshot) : [];

  bool get pinned => state == NoteState.pinned;

  bool get isNotEmpty => title?.isNotEmpty == true || content?.isNotEmpty == true;

  void update(Note other, {bool updateTimestamp = true}) {
    title = other.title;
    content = other.content;
    state = other.state;

    if (updateTimestamp || other.modifiedAt == null) {
      modifiedAt = DateTime.now();
    } else {
      modifiedAt = other.modifiedAt;
    }
    notifyListeners();
  }

  Note updateWith({
    String title,
    String content,
    NoteState state,
    bool updateTimestamp = true,
  }) {
    if (title != null) this.title = title;
    if (content != null) this.content = content;
    if (state != null) this.state = state;
    if (updateTimestamp) modifiedAt = DateTime.now();
    notifyListeners();
    return this;
  }

  /// Serializes this note into a JSON object.
  Map<String, dynamic> toJson() => {
    'title': title,
    'content': content,
    'createdAt': (createdAt ?? DateTime.now()).millisecondsSinceEpoch,
    'modifiedAt': (modifiedAt ?? DateTime.now()).millisecondsSinceEpoch,
  };

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
        createdAt:
            DateTime.fromMillisecondsSinceEpoch(doc.data['createdAt'] ?? 0),
        modifiedAt:
            DateTime.fromMillisecondsSinceEpoch(doc.data['modifiedAt'] ?? 0),
      )
    : null;

Color _parseColor(num colorInt) => Color(colorInt ?? 0xFFFFFFFF);

extension NoteStateX on NoteState {
  bool get canCreate => this <= NoteState.pinned;

  bool get canEdit => this < NoteState.deleted;

  bool operator <(NoteState other) => (this?.index ?? 0) < (other?.index ?? 0);
  bool operator <=(NoteState other) => (this?.index ?? 0) <= (other?.index ?? 0);

  String get message {
    switch (this) {
      case NoteState.archived:
        return 'Note archived';
      case NoteState.deleted:
        return 'Note moved to trash';
      default:
        return '';
    }
  }

  String get filterName {
    switch (this) {
      case NoteState.archived:
        return 'Archive';
      case NoteState.deleted:
        return 'Trash';
      default:
        return '';
    }
  }

  String get emptyResultMessage {
    switch (this) {
      case NoteState.archived:
        return 'Archived notes appear here';
      case NoteState.deleted:
        return 'Notes in trash appear here';
      default:
        return 'Notes you add appear here';
    }
  }
}