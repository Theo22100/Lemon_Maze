import 'package:flutter/material.dart';
import 'package:my_app/modules/http.dart';
import 'package:my_app/pages/home/home.dart';
import 'package:my_app/pages/register-login/loginSignupPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:logger/logger.dart';

var logger = Logger();
String response = "";

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String? userId;
  String? pseudo;
  String? email;
  String? ville;
  String? age;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('id');
      pseudo = prefs.getString('pseudo');
      email = prefs.getString('mail');
      ville = prefs.getString('ville');
      age = prefs.getString('age');
    });
  }

  Future<void> deleteUser() async {
    // Construire l'URI pour la suppression de l'utilisateur en incluant l'ID dans l'URL

    var route = "user/delete-user/$userId"; // Utilisation de l'ID dans l'URL

    // Envoyer la requête HTTP DELETE pour supprimer l'utilisateur
    var result = await http_delete(route);

    if (result.ok) {
      if (result.data['success'] == true) {
        setState(() {
          _clearSharedPreferences();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginSignUpPage()),
          );
        });
      } else {
        setState(() {
          response = result.data['message'];
        });
      }
    }
  }

  void _clearSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear(); // Supprimer toutes les données des SharedPreferences
  }

  @override
  Widget build(BuildContext context) {
    // Avoir taille ecran pour image
    final screenSize = MediaQuery.of(context).size;

    final imageWidth = screenSize.width * 0.4;
    final imageHeight = screenSize.height * 0.2;

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              '../../assets/images/welcome/wallpaper.png',
              fit: BoxFit.cover,
            ),
          ),
          // Back button at the top left
          Positioned(
            top: 40,
            left: 16,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
              child: Image.asset(
                '../../assets/images/account/backhomeprofil.png',
                width: 40,
                height: 40,
              ),
            ),
          ),
          // Profile
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                '../../assets/images/account/picture.png',
                width: imageWidth,
                height: imageHeight,
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              child: Container(
                color: const Color(0xFFFAF6D0),
                height: MediaQuery.of(context).size.height / 1.35,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      const Text(
                        'Mon profil',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFBBA2C),
                        ),
                      ),
                      const SizedBox(height: 40),
                      _buildInfoBox(
                          Icons.person, 'Pseudo', pseudo ?? 'Chargement...'),
                      const SizedBox(height: 10),
                      _buildInfoBox(
                          Icons.email, 'Email', email ?? 'Chargement...'),
                      const SizedBox(height: 10),
                      _buildInfoBox(Icons.location_city, 'Ville',
                          ville ?? 'Chargement...'),
                      const SizedBox(height: 10),
                      _buildInfoBox(Icons.cake, 'Age',
                          age != null ? '$age ans' : 'Chargement...'),
                      const SizedBox(height: 40),
                      _buildDeleteButton(),
                      Text(
                        textAlign: TextAlign.center,
                        response,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox(
    IconData icon,
    String title,
    String info,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFBBA2C),
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$title: $info',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton.icon(
        onPressed: () {
          _showDeleteConfirmationDialog(context);
        },
        icon: const Icon(Icons.delete, color: Colors.white),
        label: const Text(
          "Supprimer mon compte",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 20),
          backgroundColor: const Color(0xFFFB512C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content:
              const Text("Êtes-vous sûr de vouloir supprimer votre compte ?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () {
                deleteUser();
                // N'oubliez pas de naviguer vers la page d'accueil ou une autre page appropriée après la suppression du compte
                Navigator.of(context).pop();
              },
              child: const Text("Supprimer"),
            ),
          ],
        );
      },
    );
  }
}