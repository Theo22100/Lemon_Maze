import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:my_app/modules/http.dart';
import 'package:my_app/pages/register-login/login_page.dart';
import 'package:my_app/pages/register-login/login_signup_page.dart';

var logger = Logger();

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return RegisterPageState();
  }
}

class RegisterPageState extends State<RegisterPage> {
  TextEditingController pseudoController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController password2Controller = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController villeController = TextEditingController();

  String response = "";

  // Fonction pour valider mot de passe
  bool isPasswordValid(String password) {
    // mdp 8 carac 1 chiffre 1 carac spe
    final passwordRegex = RegExp(r'^(?=.*[0-9])(?=.*[!@#$%^&*])(.{8,})$');
    return passwordRegex.hasMatch(password);
  }

  Future<void> navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  Future<void> createUser() async {
    try {
      // Validation des champs
      if (pseudoController.text.isEmpty ||
          mailController.text.isEmpty ||
          passwordController.text.isEmpty ||
          password2Controller.text.isEmpty ||
          ageController.text.isEmpty ||
          villeController.text.isEmpty) {
        setState(() {
          response = "Veuillez remplir tous les champs !";
        });
        return;
      }

      // Validation mot de passe
      if (!isPasswordValid(passwordController.text)) {
        setState(() {
          response =
              "Mot de passe doit contenir au moins 8 caractères avec un chiffre et un caractère spécial.";
        });
        return;
      }
      if (passwordController.text != password2Controller.text) {
        setState(() {
          response = "Les mots de passes ne sont pas les mêmes";
        });
        return;
      }

      // Validation longueur du pseudo
      if (!(pseudoController.text.length <= 30)) {
        setState(() {
          response = "Le pseudo ne doit pas dépasser 30 caractères.";
        });
        return;
      }
      if (!(mailController.text.length <= 60)) {
        setState(() {
          response = "Le mail ne doit pas dépasser 60 caractères.";
        });
        return;
      }
      //Valide mail
      // Fonction pour valider format e-mail
      if (!EmailValidator.validate(mailController.text)) {
        setState(() {
          response = "Le mail n'est pas valide.";
        });
        return;
      }

      // Hashage mot de passe
      String hashedPassword =
          sha256.convert(utf8.encode(passwordController.text)).toString();

      var result = await http_post("user/create-user", {
        "pseudo": pseudoController.text,
        "mail": mailController.text,
        "age": ageController.text,
        "ville": villeController.text,
        "password": hashedPassword,
      });
      if (result.ok) {
        if (result.data['success'] == true) {
          setState(() {
            response = "Inscription réussie !";
            navigateToLogin();
          });
        } else {
          // erreur
          setState(() {
            response = result.data['error'];
          });
        }
      }
    } catch (error) {
      logger.e("Erreur inattendue: $error");
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
          color: const Color(0xFFFAF6D0), // Couleur de l'icône
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
              'assets/images/login_signup/signup-bot.png',
              fit: BoxFit.cover,
              alignment: Alignment.bottomCenter,
            ),
          ),
          // Contenu centré
          Positioned.fill(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40.0),
                  const Padding(
                    padding: EdgeInsets.only(top: 50.0),
                    child: Text(
                      "S'inscrire",
                      style: TextStyle(
                        fontFamily: 'Gustavo',
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
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
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Outfit',
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFE9581B), width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFE9581B), width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      controller: mailController,
                      decoration: const InputDecoration(
                        labelText: 'Mail',
                        filled: true,
                        fillColor: Color(0xFFFAF6D0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        prefixIcon: Icon(Icons.email, color: Color(0xFFE9581B)),
                        labelStyle: TextStyle(
                          color: Color(0xFFE9581B),
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Outfit',
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFE9581B), width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFE9581B), width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      controller: ageController,
                      decoration: const InputDecoration(
                        labelText: 'Age',
                        filled: true,
                        fillColor: Color(0xFFFAF6D0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        prefixIcon: Icon(Icons.calendar_today,
                            color: Color(0xFFE9581B)),
                        labelStyle: TextStyle(
                          color: Color(0xFFE9581B),
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Outfit',
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFE9581B), width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFE9581B), width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                      ),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter
                            .digitsOnly, // Permettre uniquement les chiffres
                      ],
                      keyboardType: TextInputType.number, // Clavier numérique
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      controller: villeController,
                      decoration: const InputDecoration(
                        labelText: 'Ville',
                        filled: true,
                        fillColor: Color(0xFFFAF6D0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        prefixIcon:
                            Icon(Icons.location_city, color: Color(0xFFE9581B)),
                        labelStyle: TextStyle(
                          color: Color(0xFFE9581B),
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Outfit',
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFE9581B), width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFE9581B), width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
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
                          fontWeight: FontWeight.w400,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFE9581B), width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFE9581B), width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                      ),
                      obscureText: true, // Masquer le mot de passe
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      controller: password2Controller,
                      decoration: const InputDecoration(
                        labelText: 'Confirmer mot de passe',
                        filled: true,
                        fillColor: Color(0xFFFAF6D0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        prefixIcon: Icon(Icons.lock, color: Color(0xFFE9581B)),
                        labelStyle: TextStyle(
                          color: Color(0xFFE9581B),
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Outfit',
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFE9581B), width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFE9581B), width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                      ),
                      obscureText: true, // Masquer le mot de passe
                    ),
                  ),
                  // Bouton "S'inscrire"
                  const SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        createUser();
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
                          "S'inscrire",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Outfit',
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
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Outfit',
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
