import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:gonote/model/note.dart';
import 'package:gonote/widget/notes_grid.dart';
import 'package:gonote/widget/notes_list.dart';
import '../model/user.dart' show CurrentUser;
import '../widget/drawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _gridView = true; // `true` to show a Grid, otherwise a List.

  @override
  Widget build(BuildContext context) => StreamProvider.value(
        value: _createNoteStream(context),
        child: Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
              _appBar(context),
              const SliverToBoxAdapter(
                child: SizedBox(height: 24),
              ),
              _buildNotesView(context),
              const SliverToBoxAdapter(
                child: SizedBox(height: 80.0),
              ),
            ],
          ),
          drawer: AppDrawer(),
          floatingActionButton: _floatingButton(context),
          bottomNavigationBar: _bottomActions(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          extendBody: true,
        ),
      );

  Widget _appBar(BuildContext context) => SliverAppBar(
        floating: true,
        snap: true,
        title: _topActions(context),
        automaticallyImplyLeading: false,
        centerTitle: true,
        titleSpacing: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
      );

  Widget _topActions(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: <Widget>[
                const SizedBox(width: 20),
                const Icon(Icons.menu, color: Colors.black54),
                const SizedBox(width: 20),
                const Expanded(
                  child: Text('Search your notes', softWrap: false),
                ),
                InkWell(
                  child: Icon(_gridView ? Icons.view_list : Icons.view_module,
                      color: Colors.black54),
                  onTap: () => setState(() {
                    _gridView =
                        !_gridView; // switch between list and grid style
                  }),
                ),
                const SizedBox(width: 18),
                _buildAvatar(context),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ),
      );

  Widget _bottomActions() => BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(
          height: 56.0,
          padding: const EdgeInsets.symmetric(horizontal: 17),
          child: Row(
            children: <Widget>[
              const Icon(Icons.check_box, size: 26, color: Colors.black54),
              const SizedBox(width: 30),
              const Icon(Icons.brush, size: 26, color: Colors.black54),
              const SizedBox(width: 30),
              const Icon(Icons.mic, size: 26, color: Colors.black54),
            ],
          ),
        ),
      );

  Widget _floatingButton(BuildContext context) => FloatingActionButton(
        child: const Icon(Icons.add_circle),
        onPressed: () {
          Navigator.pushNamed(context, '/note');
        },
      );

  Widget _buildAvatar(BuildContext context) {
    final url = Provider.of<CurrentUser>(context)?.data?.photoUrl;
    return CircleAvatar(
      backgroundImage: url != null ? NetworkImage(url) : null,
      child: url == null ? const Icon(Icons.face) : null,
      radius: 17,
    );
  }

  /// A grid/list view to display notes
  Widget _buildNotesView(BuildContext context) => Consumer<List<Note>>(
        builder: (context, notes, _) {
          if (notes?.isNotEmpty != true) {
            print("Bank View");
            return _buildBlankView();
          }

          final widget = _gridView ? NotesGrid.create : NotesList.create;
          return widget(
              notes: notes,
              onTap: (_) {
                print('Clicked on notes');
              });
        },
      );

  Widget _buildBlankView() => const SliverFillRemaining(
        hasScrollBody: false,
        child: Text(
          'Notes not found',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 14,
          ),
        ),
      );

  void _onNoteTap(Note note) {
    Navigator.pushNamed(context, '/note', arguments: {'note': note});
  }

  Stream<List<Note>> _createNoteStream(BuildContext context) {
    final user = Provider.of<CurrentUser>(context)?.data;
    final uid = user?.uid;
    return Firestore.instance
        .collection("notes")
        .where('uid', isEqualTo: uid)
        .snapshots()
        .handleError((e) => debugPrint('query notes failed: $e'))
        .map((snapshot) => Note.fromQuery(snapshot));
  }
}
