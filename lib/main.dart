import 'package:flutter/material.dart';
import 'package:LemonMaze/pages/home/home.dart';
import 'package:LemonMaze/pages/welcome/page1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  // Initialiser variables d'environnement
  WidgetsFlutterBinding.ensureInitialized();

  // Charger variables d'environnement
  await dotenv.load(fileName: "assets/.env");

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
      home: FutureBuilder<bool>(
        // Vérifiez si user connecté en vérif token dans SP
        future: isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Affichez indication de chargement
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            // Si user est connecté redirige vers page home
            if (snapshot.data == true) {
              return const HomePage();
            } else {
              // Sinon page début
              return const Welcome1Page();
            }
          }
        },
      ),
    );
  }

  // Fonction pour vérif si user est connecté en vérif token SP
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    // Si token existe, user est connecté
    return token != null;
  }
}
