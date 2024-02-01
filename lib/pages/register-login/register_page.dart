import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:my_app/modules/http.dart';

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

  String response = "";

  Future<void> createUser() async {
    try {
      // Validation des champs
      if (pseudoController.text.isEmpty ||
          mailController.text.isEmpty ||
          passwordController.text.isEmpty) {
        // Afficher un message d'erreur ou effectuer une action appropriée
        return;
      }

      // Hashage du mot de passe
      String hashedPassword =
          sha256.convert(utf8.encode(passwordController.text)).toString();

      // Effectuer une requête HTTP POST vers le point de terminaison "create-user"
      var result = await http_post("create-user", {
        "pseudo": pseudoController.text,
        "mail": mailController.text,
        "password": hashedPassword, // Utilisez le mot de passe hashé
      });

      // Si la requête est réussie, mettre à jour l'interface utilisateur de manière asynchrone
      if (result.ok) {
        setState(() {
          response = result.data['status'];
        });
      } else {
        // Gérer les erreurs
      }
    } catch (error) {
      // Gérer les erreurs inattendues
      print("Error: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inscription"),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: pseudoController,
            decoration: const InputDecoration(hintText: "Pseudo"),
          ),
          TextField(
            controller: mailController,
            decoration: const InputDecoration(hintText: "Mail"),
          ),
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(hintText: "Mot de passe"),
          ),
          TextButton(
            onPressed: createUser,
            child: const Text("Créer"),
          ),
          Text(response),
        ],
      ),
    );
  }
}
