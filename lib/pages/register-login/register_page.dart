import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:my_app/modules/http.dart';

var logger = Logger();

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

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

  // Fonction pour valider le mot de passe
  bool isPasswordValid(String password) {
    // mdp 8 carac 1 chiffre 1 carac spe
    final passwordRegex = RegExp(r'^(?=.*[0-9])(?=.*[!@#$%^&*])(.{8,})$');
    return passwordRegex.hasMatch(password);
  }

  Future<void> createUser() async {
    try {
      // Validation des champs
      if (pseudoController.text.isEmpty ||
          mailController.text.isEmpty ||
          passwordController.text.isEmpty) {
        logger.e("Pseudo/Mail/Password vide");
        return;
      }

      // Validation du mot de passe
      if (!isPasswordValid(passwordController.text)) {
        setState(() {
          response =
              "Le mot de passe doit contenir au moins 8 caractères avec un chiffre et un caractère spécial.";
        });
        return;
      }

      // Validation de la longueur du pseudo
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
      // Fonction pour valider le format de l'e-mail
      if (!EmailValidator.validate(mailController.text)) {
        setState(() {
          response = "Le mail n'est pas valide.";
        });
        return;
      }

      // Hashage du mot de passe
      String hashedPassword =
          sha256.convert(utf8.encode(passwordController.text)).toString();

      // Effectuer une requête HTTP POST vers le point de terminaison "create-user"
      var result = await http_post("create-user", {
        "pseudo": pseudoController.text,
        "mail": mailController.text,
        "password": hashedPassword,
      });

      // Si la requête est réussie, mettre à jour l'interface utilisateur de manière asynchrone
      if (result.ok) {
        setState(() {
          response = result.data['status'];
        });
      }
    } catch (error) {
      // Gérer les erreurs inattendues
      logger.e("Erreur inattendue : $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inscription"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
              const SizedBox(height: 16), // Ajoute un espacement
              ElevatedButton(
                onPressed: createUser,
                child: const Text("Créer"),
              ),
              const SizedBox(height: 8), // Ajoute un espacement
              Text(response),
            ],
          ),
        ),
      ),
    );
  }
}
