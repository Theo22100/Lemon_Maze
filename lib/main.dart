import 'package:flutter/material.dart';
import 'package:my_app/pages/welcome.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Flutter NodeJS",
      home: WelcomePage(),
    );
  }
}

void main() {
  runApp(const App());
}
