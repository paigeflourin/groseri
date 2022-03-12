import 'package:flutter/material.dart';
import 'package:groseri/screens/grocery_trips.dart';
import 'package:groseri/screens/fam_members.dart';
import 'package:groseri/screens/grocery_list.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Side menu',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(color: Colors.blueAccent),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/home');
            },
          ),
          ListTile(
            leading: Icon(Icons.group),
            title: Text('Family Members'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/fam-members');
            },
          ),
          ListTile(
            leading: Icon(Icons.local_grocery_store),
            title: Text('Grocery Trips'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/grocery-trips');
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.border_color),
          //   title: Text('Grocery List Items'),
          //   onTap: () {
          //     Navigator.pop(context);
          //     Navigator.pushNamed(context, '/grocery-list');
          //   },
          // ),
          // ListTile(
          //   leading: Icon(Icons.exit_to_app),
          //   title: Text('Logout'),
          //   onTap: () => {Navigator.of(context).pop()},
          // ),
        ],
      ),
    );
  }
}
