import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:my_app/modules/http.dart';
import 'package:my_app/pages/home.dart';

var logger = Logger();

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  TextEditingController pseudoController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String response = "";

  // Méthode pour gérer la navigation vers la page d'accueil

  void navigateToHomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  Future<void> loginUser() async {
    try {
      // Validation champs
      if (pseudoController.text.isEmpty || passwordController.text.isEmpty) {
        logger.w("Pseudo et mot de passe sont obligatoires.");
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
      logger.e('Pseudo : ${pseudoController.text}');
      logger.e('Mot de passe : ${pseudoController.text}');
      logger.e('Reponse : $response');
      logger.e('Erreur : $error');
    }
  }

  // Fonction pour hash le mot de passe (utilisez la bibliothèque crypto)
  String hashPassword(String password) {
    // Utilisez la fonction sha256 directement
    var hashedBytes = sha256.convert(utf8.encode(password));

    // Convertissez les bytes en une représentation hexadécimale
    var hashedPassword = hex.encode(hashedBytes.bytes);

    return hashedPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Page de Connexion"),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: pseudoController,
            decoration: const InputDecoration(hintText: "Pseudo"),
          ),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(hintText: "Mot de passe"),
          ),
          TextButton(
            onPressed: loginUser,
            child: const Text("Se Connecter"),
          ),
          Text(response),
        ],
      ),
    );
  }
}
