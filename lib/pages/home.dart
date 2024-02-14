import 'package:flutter/material.dart';
import 'package:my_app/pages/register-login/account.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AccountPage(
                    isLoggedIn: true,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {},
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Handle bar button press
              },
              child: const Text('Bars'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle restaurants button press
              },
              child: const Text('Restaurants'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle parcs button press
              },
              child: const Text('Parcs'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle musée button press
              },
              child: const Text('Musée'),
            ),
          ],
        ),
      ),
    );
  }
}
