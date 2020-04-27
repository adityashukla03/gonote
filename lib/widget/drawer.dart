import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:provider/provider.dart';
import '../model/user.dart' show CurrentUser;

class AppDrawer extends StatelessWidget {

  Future _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Widget buildListTile(String title, IconData icon, Function tapHandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: tapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider
        .of<CurrentUser>(context)
        ?.data;
    final displayName = user?.displayName;
    final email = user?.email;
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            height: 150,
            child: UserAccountsDrawerHeader(
              accountName: Text(displayName),
              accountEmail: Text(email),
            ),
          ),

          buildListTile("Notes", Icons.history, () {
            Navigator.of(context).pop();
          }),

          Divider(height: 10, color: Colors.red),
          buildListTile("Logout", Icons.settings, () async {
            Navigator.of(context).pop();
            _signOut();
          }),
        ],
      ),
    );
  }
}
