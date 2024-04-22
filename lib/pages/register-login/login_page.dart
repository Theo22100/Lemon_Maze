// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:my_app/modules/http.dart';
import 'package:my_app/pages/home.dart';

var logger = Logger();

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController mailController = TextEditingController();
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
      if (mailController.text.isEmpty || passwordController.text.isEmpty) {
        logger.w('Mail : ${mailController.text}');
        logger.w("Password: ${passwordController.text}");
        return;
      }

      // Hash du mot de passe
      String hashedPassword = hashPassword(passwordController.text);

      // requête HTTP POST vers login
      var result = await http_post("login", {
        "mail": mailController.text,
        "password": hashedPassword,
      });

      // Si la requête est réussie, MAJ interface utilisateur asynchrone
      if (result.ok) {
        setState(() {
          logger.i("Response from server: ${result.data}");
          response = result.data['status'];
          // Rediriger vers la page d'accueil
          if (response == "Connecté") {
            navigateToHomePage();
          }
        });
      } else {
        // Gérer erreurs de connexion
        setState(() {
          logger.e("Error response from server: ${result.data}");
          response =
              "Échec de la connexion. Vérifiez vos informations d'identification.";
        });
      }
    } catch (error) {
      // Gérer erreurs
      logger.e('Mail : ${mailController.text}');
      logger.e('Mot de passe : ${passwordController.text}');
      logger.e('Reponse : $response');
      logger.e('Erreur : $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Page de Connexion new"),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              RichText(
                  text: TextSpan(
                text: 'LemonMaze'.toUpperCase(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 50,
                ),
                children: const [],
              )),
              const SizedBox(
                height: 50.0,
              ), //Mettre espace
              Form(
                child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.stretch, //Barre prend toute la page
                    children: [
                      const Text('Entrez votre email'),
                      const SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        controller: mailController,
                        decoration: InputDecoration(
                          hintText: 'Ex: John.Smith@gmail.com',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0.0),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      const Text('Entrez votre Mot de Passe'),
                      const SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          hintText: 'Mot de passe',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0.0),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      ElevatedButton(
                        onPressed: loginUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                        ),
                        child: const Text(
                          'Connexion',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(response),
                    ]),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
