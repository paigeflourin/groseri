import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('HOME')),
      ),
      body: Container(
        child: Center(
          child: Text('HOME PAGE'),
        ),
      ),
    );
  }
}
