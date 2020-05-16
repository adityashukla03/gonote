import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gonote/model/filter.dart';
import 'package:gonote/model/note.dart';
import 'package:gonote/widget/notes_grid.dart';
import 'package:gonote/widget/notes_list.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../model/user.dart' show CurrentUser;
import '../widget/drawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _gridView = true; // `true` to show a Grid, otherwise a List.
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) => SafeArea(
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark.copyWith(
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => NoteFilter(), // watching the note filter
              ),
              Consumer<NoteFilter>(
                builder: (context, filter, child) => StreamProvider.value(
                  value: _createNoteStream(context, filter),
                  child: child,
                ),
              ),
            ],
            child: Consumer2<NoteFilter, List<Note>>(
              builder: (context, filter, notes, child) {
                return Scaffold(
                  key: _scaffoldKey,
                  body: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints.tightFor(width: 720),
                      child: CustomScrollView(
                        slivers: <Widget>[
                          _appBar(context),
                          const SliverToBoxAdapter(
                            child: SizedBox(height: 24),
                          ),
                          ..._buildNotesView(context, notes),
                          const SliverToBoxAdapter(
                            child: SizedBox(height: 80.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  drawer: AppDrawer(),
                  floatingActionButton: _floatingButton(context),
                  floatingActionButtonLocation: _gridView
                      ? FloatingActionButtonLocation.centerDocked
                      : FloatingActionButtonLocation.endDocked,
                  extendBody: true,
                );
              },
            ),
          ),
        ),
      );

  Widget _appBar(BuildContext context) => SliverAppBar(
        floating: true,
        snap: true,
        title: _topActions(context),
        automaticallyImplyLeading: false,
        centerTitle: true,
        titleSpacing: 0,
        backgroundColor: Colors.white,
        elevation: 20,
      );

  Widget _topActions(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Card(
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: <Widget>[
                const SizedBox(width: 20),
                InkWell(
                  child: Icon(
                    Icons.menu,
                    color: Colors.black,
                  ),
                  onTap: () => _scaffoldKey.currentState?.openDrawer(),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Center(
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          color: Color(0xFF61656A),
                          fontSize: 24,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 2,
                        ),
                        children: [
                          const TextSpan(
                            text: '\u{1F58D} Go',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const TextSpan(
                            text: 'Note',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  child: Icon(_gridView ? Icons.view_list : Icons.view_module,
                      color: Colors.black54),
                  onTap: () => setState(
                    () {
                      _gridView =
                          !_gridView; // switch between list and grid style
                    },
                  ),
                ),
                const SizedBox(width: 18),
                _buildAvatar(context),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ),
      );

  Widget _floatingButton(BuildContext context) => Padding(
        padding: const EdgeInsets.all(4.0),
        child: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, '/create');
          },
        ),
      );

  Widget _buildAvatar(BuildContext context) {
    final url = Provider.of<CurrentUser>(context)?.data?.photoUrl;
    return CircleAvatar(
      backgroundImage: url != null ? NetworkImage(url) : null,
      child: url == null ? const Icon(Icons.face) : null,
      radius: 17,
    );
  }

  List<Widget> _buildNotesView(BuildContext context, List<Note> notes) {
    final asGrid = _gridView;

    final factory = asGrid ? NotesGrid.create : NotesList.create;

    final partition = _partitionNotes(notes);

    return [
      factory(notes: partition.item2, onTap: _onNoteTap),
    ];
  }

  void _onNoteTap(Note note) {
    Navigator.pushNamed(context, '/note', arguments: {'note': note});
  }

  Stream<List<Note>> _createNoteStream(
      BuildContext context, NoteFilter filter) {
    final user = Provider.of<CurrentUser>(context)?.data;
    final uid = user?.uid;
    return Firestore.instance
        .collection("notes")
        .where('uid', isEqualTo: uid)
        .snapshots()
        .handleError((e) => print('query notes failed: $e'))
        .map((snapshot) => Note.fromQuery(snapshot));
  }

  Tuple2<List<Note>, List<Note>> _partitionNotes(List<Note> notes) {
    if (notes?.isNotEmpty != true) {
      return Tuple2([], []);
    }

    final indexUnpinned = notes?.indexWhere((n) => !n.pinned);
    return indexUnpinned > -1
        ? Tuple2(notes.sublist(0, indexUnpinned), notes.sublist(indexUnpinned))
        : Tuple2(notes, []);
  }
}
