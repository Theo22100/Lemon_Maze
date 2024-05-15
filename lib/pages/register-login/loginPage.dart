import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
//import 'package:logger/logger.dart';
import 'package:my_app/modules/http.dart';
import 'package:my_app/pages/home.dart';
import 'package:my_app/pages/register-login/loginSignupPage.dart';

//var logger = Logger();

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  TextEditingController pseudoController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String response = "";

  // Fonction pour hash le mot de passe
  String hashPassword(String password) {
    // fonction sha256 directement
    var hashedBytes = sha256.convert(utf8.encode(password));
    // Convertir bytes en une représentation hexadécimale
    var hashedPassword = hex.encode(hashedBytes.bytes);
    return hashedPassword;
  }

  // Méthode pour gérer la navigation vers la page d'accueil
  void navigateToHomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  Future<void> loginUser() async {
    try {
      // Validation champs
      if (pseudoController.text.isEmpty || passwordController.text.isEmpty) {
        setState(() {
          response = "Veuillez remplir tous les champs !";
        });
        return;
      }

      // Hash du mot de passe
      String hashedPassword = hashPassword(passwordController.text);

      // requête HTTP POST vers login
      var result = await http_post("login", {
        "pseudo": pseudoController.text,
        "password": hashedPassword,
      });

      // Si la requête est réussie, MAJ interface utilisateur asynchrone
      if (result.ok) {
        if (result.data['success'] == true) {
          setState(() {
            response = "Connexion réussie !";
          });

          // Appeler la fonction asynchrone pour attendre 3 secondes
          await Future.delayed(const Duration(seconds: 3));

          // Mettre à jour l'état dans setState après l'attente
          setState(() {
            navigateToHomePage();
          });
        } else {
          // erreur
          setState(() {
            response = result.data['error'];
          });
        }
      } else {
        // Gérer erreurs de connexion
        setState(() {
          response = "Vérifiez vos informations d'identification.";
        });
      }
    } catch (error) {
      // Gérer erreurs
      // logger.e('Pseudo : ${pseudoController.text}');
      // logger.e('Mot de passe : ${passwordController.text}');
      // logger.e('Reponse : $response');
      // logger.e('Erreur : $error');
      setState(() {
        response = "Vérifiez vos informations d'identification.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE9581B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginSignUpPage()),
            );
          },
          color: const Color(0xFFFAF6D0),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fond d'écran
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  '../../assets/images/welcome/wallpaper.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Image signup-bot au bas
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Image.asset(
              '../../assets/images/login_signup/login-bot.png',
              fit: BoxFit.cover,
              alignment: Alignment.bottomCenter,
            ),
          ),
          // Contenu centré
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40.0),
                  const Padding(
                    padding: EdgeInsets.only(top: 50.0),
                    child: Text(
                      "Se connecter",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFAF6D0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      controller: pseudoController,
                      decoration: const InputDecoration(
                        labelText: 'Pseudo',
                        filled: true,
                        fillColor: Color(0xFFFAF6D0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        prefixIcon:
                            Icon(Icons.person, color: Color(0xFFE9581B)),
                        labelStyle: TextStyle(
                          color: Color(0xFFE9581B),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Mot de passe',
                        filled: true,
                        fillColor: Color(0xFFFAF6D0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        prefixIcon: Icon(Icons.lock, color: Color(0xFFE9581B)),
                        labelStyle: TextStyle(
                          color: Color(0xFFE9581B),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        loginUser();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFFE9581B), // Couleur de fond orange
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20), // Bords arrondis
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "Se connecter",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFAF6D0),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8), // Ajoute espace
                  Text(
                    textAlign: TextAlign.center,
                    response,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFFFAF6D0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
