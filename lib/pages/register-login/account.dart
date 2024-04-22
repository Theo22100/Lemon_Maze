import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_app/pages/home.dart';

class AccountPage extends StatelessWidget {
  final bool isLoggedIn;

  const AccountPage({
    super.key,
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoggedIn) {
      // Rediriger vers la page d'accueil si non connecté
      return const HomePage();
    }

    return FutureBuilder<Map<String, String>>(
      future: _getUserDataFromPrefs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Erreur de chargement'));
        }
        final userData = snapshot.data ?? {};
        final userEmail = userData['email'] ?? '';
        final userPseudo = userData['pseudo'] ?? '';
        return Scaffold(
          appBar: AppBar(
            title: const Text('Profil'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Email: $userEmail'),
                Text('Pseudo: $userPseudo'),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<Map<String, String>> _getUserDataFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final storedEmail = prefs.getString('userEmail') ?? '';
    final storedPseudo = prefs.getString('userPseudo') ?? '';
    return {'email': storedEmail, 'pseudo': storedPseudo};
  }
}
