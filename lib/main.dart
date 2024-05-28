import 'package:flutter/material.dart';
import 'package:my_app/pages/home/home.dart';
import 'package:my_app/pages/welcome/page1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  // Assurez-vous que le binding est initialisé
  WidgetsFlutterBinding.ensureInitialized();

  // Charger les variables d'environnement
  await dotenv.load(fileName: ".env");

  // Lancer l'application
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LemonMaze',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<bool>(
        // Vérifiez si l'utilisateur est connecté en vérifiant le token dans SharedPreferences
        future: isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Affichez une indication de chargement pendant que vous vérifiez l'état de connexion
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            // Si l'utilisateur est connecté, redirigez-le vers la page d'accueil
            if (snapshot.data == true) {
              return const HomePage();
            } else {
              // Sinon, redirigez-le vers la page de connexion
              return const Welcome1Page();
            }
          }
        },
      ),
    );
  }

  // Fonction pour vérifier si l'utilisateur est connecté en vérifiant le token dans SharedPreferences
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    // Si le token existe, l'utilisateur est connecté
    return token != null;
  }
}
