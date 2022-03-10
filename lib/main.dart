import 'package:flutter/material.dart';
import 'package:groseri/screens/fam_mem_details.dart';
import 'package:groseri/screens/fam_members.dart';
import 'package:groseri/screens/grocery_list.dart';
import 'package:groseri/screens/home.dart';

import 'package:groseri/widgets/navdrawer.dart';
import 'package:groseri/screens/grocery_trips.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('grocery_list');
  await Hive.openBox('grocery_trip');
  await Hive.openBox('family_members');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(),
        '/fam-members': (context) => FamilyMembers(),
        '/grocery-trips': (context) => GroceryTrips(),
        //'/grocery-list': (context) => GroceryList(),
        '/home': (context) => HomePage(),
      },
    );
    //home: MyHomePage(),
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('Groseri'),
      ),
      body: Center(
        child: HomePage(),
      ),
    );
  }
}
