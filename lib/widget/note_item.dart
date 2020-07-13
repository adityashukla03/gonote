import 'package:flutter/material.dart';
import '../model/note.dart';

import 'package:gonote/widget/delet_btn.dart';

class NoteItem extends StatelessWidget {

  const NoteItem({
    Key key,
    this.note,
    this.isGridType = true,
  }) : super(key: key);

  final Note note;
  final bool isGridType;

  @override
  Widget build(BuildContext context) => Hero(
    tag: 'NoteItem${note.id}',
    child: Card(
      color: Colors.transparent,
      elevation: 5,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          border: Border.all(color: Colors.black),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (note.title?.isNotEmpty == true)
              Text(
                note.title,
                style: TextStyle(
                  color: Color(0xFF202124),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  height: 19 / 16,
                ),
                maxLines: 2,
              ),
            if (note.title?.isNotEmpty == true)
              const SizedBox(height: 14),
            Flexible(
              child: Text(
                note.content ?? '',
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
              flex: 1,
              fit: this.isGridType ? FlexFit.tight : FlexFit.loose,
            ),
            const SizedBox(height: 8),
            DeleteBtn(note: this.note),
          ],
        ),
      ),
    ),
  );

}
