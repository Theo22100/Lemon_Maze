// home.dart
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bienvenue"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Bonjour, choisissez un des 4 parcours",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Naviguer vers le parcours "Musée"
              },
              child: const Text("Musée"),
            ),
            ElevatedButton(
              onPressed: () {
                // Naviguer vers le parcours "Bars"
              },
              child: const Text("Bars"),
            ),
            ElevatedButton(
              onPressed: () {
                // Naviguer vers le parcours "Restaurants"
              },
              child: const Text("Restaurants"),
            ),
            ElevatedButton(
              onPressed: () {
                // Naviguer vers le parcours "Parcs"
              },
              child: const Text("Parcs"),
            ),
          ],
        ),
      ),
    );
  }
}
