import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:my_app/modules/http.dart';

class AddUserPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddUserPageState();
  }
}

class AddUserPageState extends State<AddUserPage> {
  TextEditingController pseudoController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String response = "";

  Future<void> createUser() async {
    try {
      // Validation des champs
      if (pseudoController.text.isEmpty ||
          mailController.text.isEmpty ||
          nameController.text.isEmpty ||
          surnameController.text.isEmpty ||
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
        "name": nameController.text,
        "surname": surnameController.text,
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
        title: Text("Inscription"),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: pseudoController,
            decoration: InputDecoration(hintText: "Pseudo"),
          ),
          TextField(
            controller: mailController,
            decoration: InputDecoration(hintText: "Mail"),
          ),
          TextField(
            controller: surnameController,
            decoration: InputDecoration(hintText: "Prénom"),
          ),
          TextField(
            controller: nameController,
            decoration: InputDecoration(hintText: "Nom"),
          ),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(hintText: "Mot de passe"),
          ),
          TextButton(
            child: Text("Créer"),
            onPressed: createUser,
          ),
          Text(response),
        ],
      ),
    );
  }
}