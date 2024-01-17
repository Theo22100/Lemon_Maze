import 'package:flutter/material.dart';
import 'package:my_app/pages/main_page.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter NodeJS",
      home: MainPage(),
    );
  }
}

void main() {
  runApp(App());
}
