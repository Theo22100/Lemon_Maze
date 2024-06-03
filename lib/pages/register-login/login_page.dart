import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:LemonMaze/modules/http.dart';
import 'package:LemonMaze/pages/home/home.dart';
import 'package:LemonMaze/pages/home/home_welcome.dart';
import 'package:LemonMaze/pages/register-login/login_signup_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

var logger = Logger();

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
    var hashedBytes = sha256.convert(utf8.encode(password));
    var hashedPassword = hex.encode(hashedBytes.bytes);
    return hashedPassword;
  }

  // Méthode pour gérer la navigation
  void navigateToHomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  // Méthode pour gérer la navigation
  void navigateToFirstLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeHomePage()),
    );
  }

  // enregistrer isFirstLogin dans SharedPreferences
  Future<void> setFirstLoginDone() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool result = await prefs.setBool('isFirstLogin', false);
    } catch (e) {
      logger.e('Erreur: $e');
    }
  }

  Future<void> loginUser() async {
    try {
      // Validation des champs
      if (pseudoController.text.isEmpty || passwordController.text.isEmpty) {
        setState(() {
          response = "Veuillez remplir tous les champs !";
        });
        showSnackBar(response);
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
          //Permet de stocker les informations utilisateur dans SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', result.data['token']);
          await prefs.setString('pseudo', result.data['pseudo']);
          await prefs.setString('mail', result.data['mail']);
          await prefs.setString('age', result.data['age'].toString());
          await prefs.setString('ville', result.data['ville']);
          await prefs.setString('id', result.data['id'].toString());

          bool isFirstLogin = prefs.getBool('isFirstLogin') ?? true;

          // Naviguer vers la page appropriée après l'attente
          if (isFirstLogin) {
            await setFirstLoginDone();
            navigateToFirstLogin();
          } else {
            navigateToHomePage();
          }
        } else {
          // erreur
          setState(() {
            response = result.data['status'];
          });
          showSnackBar(response);
        }
      } else {
        // Gérer erreurs de connexion
        setState(() {
          response = result.data['status'];
        });
        showSnackBar(response);
      }
    } catch (error) {
      setState(() {
        response = "Vérifiez vos informations d'identification.";
      });
      showSnackBar(response);
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFFE9581B),
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFFFAF6D0),
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w500,
          ),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
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
                  'assets/images/welcome/wallpaper.png',
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
              'assets/images/login_signup/login-bot.png',
              fit: BoxFit.cover,
              alignment: Alignment.bottomCenter,
            ),
          ),
          // Contenu centré
          Positioned.fill(
            child: SingleChildScrollView(
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
                          fontFamily: 'Gustavo',
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                          prefixIcon:
                              Icon(Icons.person, color: Color(0xFFE9581B)),
                          labelStyle: TextStyle(
                            color: Color(0xFFE9581B),
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Outfit',
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xFFE9581B), width: 2.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xFFE9581B), width: 2.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                          prefixIcon:
                              Icon(Icons.lock, color: Color(0xFFE9581B)),
                          labelStyle: TextStyle(
                            color: Color(0xFFE9581B),
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Outfit',
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xFFE9581B), width: 2.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xFFE9581B), width: 2.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                        ),
                        obscureText: true, // Pour masquer le mot de passe
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
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFFAF6D0),
                              fontFamily: 'Outfit',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
