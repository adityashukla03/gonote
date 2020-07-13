import 'package:flutter/material.dart';
import 'package:gonote/model/note.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../model/user.dart' show CurrentUser;

import '../service/notes_service.dart';

enum ConfirmAction { Cancel, Accept}

class DeleteBtn extends StatelessWidget {

  const DeleteBtn({
    this.note,
    this.atDetailScreen = false
  }) : super();

  final Note note;
  final bool atDetailScreen;

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<CurrentUser>(context)?.data;
    final uid = user?.uid;

    final userNotesCollection = Firestore.instance.collection('users').document(uid).collection('notes');

    return IconButton(
      onPressed: () async {
        final ConfirmAction action = await _asyncConfirmDialog(context);
        print("Confirm Action $action" );
        if (action == ConfirmAction.Accept) {
          print(this.note.toJson());
          if (note.id != null) {
            note
              ..delFromFireStore(uid);
            if (this.atDetailScreen)
              Navigator.of(context).pop();
          }
        }
      },
      icon: Icon(Icons.delete),
      alignment: Alignment.centerRight,
    );
  }

  Future<ConfirmAction> _asyncConfirmDialog(BuildContext context) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete this note?'),
          content: const Text(
              'This will be deleted from your account.'),
          actions: <Widget>[
            FlatButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.Cancel);
              },
            ),
            FlatButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.Accept);
              },
            )
          ],
        );
      },
    );
  }

}

