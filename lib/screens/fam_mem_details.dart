import 'package:flutter/material.dart';

class FamMemberDetails extends StatelessWidget {
  final String name;
  final String email;

  FamMemberDetails({required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Container(
          child: ListTile(
        title: Text(name),
        subtitle: Text(email),
      )),
    );
  }
}
