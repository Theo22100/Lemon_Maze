import 'package:flutter/material.dart';
import 'package:LemonMaze/modules/http.dart';
import 'package:LemonMaze/pages/home/home.dart';
import 'package:LemonMaze/pages/register-login/login_signup_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

import 'bottom_nav.dart';

var logger = Logger();
String response = "";

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
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

  //recup dans shared
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

    var route = "user/delete-user/$userId";

    // Envoyerrequête HTTP DELETE
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
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              'assets/images/welcome/wallpaper.png',
              fit: BoxFit.cover,
            ),
          ),
          // Bouton retour
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
                'assets/images/account/backhomeprofil.png',
                width: 40,
                height: 40,
              ),
            ),
          ),
          // Profile
          Positioned(
            top: screenHeight * 0.04,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/images/account/picture.png',
                width: screenWidth * 0.4,
                height: screenHeight * 0.2,
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
                height: MediaQuery.of(context).size.height / 1.55,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    // Added SingleChildScrollView
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          'Mon profil',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Gustavo',
                            color: Color(0xFFFBBA2C),
                          ),
                        ),
                        const SizedBox(height: 40),
                        _buildInfoBox(Icons.person, 'Pseudo',
                            pseudo ?? 'Chargement...', context),
                        const SizedBox(height: 10),
                        _buildInfoBox(Icons.email, 'Email',
                            email ?? 'Chargement...', context),
                        const SizedBox(height: 10),
                        _buildInfoBox(Icons.location_city, 'Ville',
                            ville ?? 'Chargement...', context),
                        const SizedBox(height: 10),
                        _buildInfoBox(
                            Icons.cake,
                            'Age',
                            age != null ? '$age ans' : 'Chargement...',
                            context),
                        const SizedBox(height: 30),
                        _buildDeleteButton(context),
                        Text(
                          textAlign: TextAlign.center,
                          response,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                            fontFamily: 'Outfit',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavigationBarWidget(),
    );
  }

  Widget _buildInfoBox(
      IconData icon, String title, String info, BuildContext context) {
    //final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFBBA2C),
        borderRadius: BorderRadius.circular(30),
      ),
      padding: EdgeInsets.all(screenHeight * 0.02),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$title: $info',
              style: const TextStyle(
                fontSize: 13,
                color: Colors.white,
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    //final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
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
            fontSize: 14,
            color: Colors.white,
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w400,
          ),
        ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(
              horizontal: screenHeight * 0.05, vertical: 20),
          backgroundColor: const Color(0xFFFB512C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  //Bouton dialogue apres suppression
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontFamily: 'Outfit',
              )),
          content:
              const Text("Êtes-vous sûr de vouloir supprimer votre compte ?",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Outfit',
                  )),
          actions: [
            TextButton(
              onPressed: () {
                deleteUser();
              },
              child: const Text("Supprimer",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Outfit',
                  )),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Annuler",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Outfit',
                  )),
            ),
          ],
        );
      },
    );
  }
}
