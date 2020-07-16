import 'package:flutter/material.dart';
import 'package:gonote/model/note.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gonote/model/todo.dart';
import 'package:provider/provider.dart';
import '../model/user.dart' show CurrentUser;

import '../service/notes_service.dart';

enum ConfirmAction { Cancel, Accept}

class DeleteBtn extends StatelessWidget {

  DeleteBtn({
    this.todo = null,
    this.note = null,
    this.atDetailScreen = false
  }) : super();

  final Note note;
  final bool atDetailScreen;

  final Todo todo;

  bool isAlertForNoteDeletion = true;

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<CurrentUser>(context)?.data;
    final uid = user?.uid;

    this.isAlertForNoteDeletion = this.note != null ? true : false;

    final userFSDocument = Firestore.instance.collection('users').document(uid);

    return IconButton(
      onPressed: () async {
        final ConfirmAction action = await _asyncConfirmDialog(context);
        print("Confirm Action $action" );
        if (action == ConfirmAction.Accept) {
          if (this.isAlertForNoteDeletion == true) {
            if (note.id != null) {
              userFSDocument.collection('notes').document(note.id).delete();
              if (this.atDetailScreen)
                Navigator.of(context).pop();
            }
          } else {
            if (todo.id != null){
              userFSDocument.collection('todo').document(todo.id).delete();
            }
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
          title: Text(this.isAlertForNoteDeletion == true ? 'Delete this note?' : 'Delete this todo?'),
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

