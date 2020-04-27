import 'package:flutter/material.dart';
import '../model/note.dart';

class NoteItem extends StatelessWidget {
  const NoteItem({
    Key key,
    this.note,
  }) : super(key: key);

  final Note note;

  @override
  Widget build(BuildContext context) => Hero(
        tag: 'NoteItem${note.id}',
        child: DefaultTextStyle(
          style: TextStyle(
            color: Color(0xFF202124),
            fontSize: 16,
            height: 1.3125,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: note.color,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              border: note.color.value == 0xFFFFFFFF
                  ? Border.all(color: Color(0xFFDADCE0))
                  : null,
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
                      fontSize: 16,
                      height: 19 / 16,
                    ),
                    maxLines: 1,
                  ),
                if (note.title?.isNotEmpty == true) const SizedBox(height: 14),
                Flexible(
                  flex: 1,
                  child: Text(note.content ??
                      ''), // wrapping using a Flexible to avoid overflow
                ),
              ],
            ),
          ),
        ),
      );
}
