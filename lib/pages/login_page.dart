import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

import 'package:flutter/material.dart';
import 'package:my_app/modules/http.dart';

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

  Future<void> loginUser() async {
    try {
      // Validation des champs
      if (pseudoController.text.isEmpty || passwordController.text.isEmpty) {
        // Afficher un message d'erreur ou effectuer une action appropriée
        print("Pseudo et mot de passe sont obligatoires.");
        return;
      }

      // Hash du mot de passe (vous devez avoir ajouté la dépendance 'crypto')
      String hashedPassword = hashPassword(passwordController.text);

      // Effectuer une requête HTTP POST vers le point de terminaison "login"
      var result = await http_post("login", {
        "pseudo": pseudoController.text,
        "password": hashedPassword,
      });

      // Si la requête est réussie, mettre à jour l'interface utilisateur de manière asynchrone
      if (result.ok) {
        setState(() {
          print("Response from server: ${result.data}");
          response = result.data['status'];
        });
      } else {
        // Gérer les erreurs de connexion
        setState(() {
          print("Error response from server: ${result.data}");
          response =
              "Échec de la connexion. Vérifiez vos informations d'identification.";
        });
      }
    } catch (error) {
      // Gérer les erreurs inattendues
      print("Pseudo");
      print(pseudoController.text);
      print("Mot de passe");
      print(passwordController.text);
      print("Réponse");
      print(response);
      print("Error: $error");
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
            obscureText: true, // Cacher le texte du mot de passe
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
