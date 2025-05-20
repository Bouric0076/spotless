import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Spotless Home")),
      body: Center(child: Text("Welcome to Spotless!")),
    );
  }
}
