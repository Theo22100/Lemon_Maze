import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:my_app/modules/http.dart';

var logger = Logger();

class Register2Page extends StatefulWidget {
  const Register2Page({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return RegisterPage2State();
  }
}

class RegisterPage2State extends State<Register2Page> {
  TextEditingController pseudoController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController villeController = TextEditingController();

  String response = "";

  // Fonction pour valider mot de passe
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
          passwordController.text.isEmpty ||
          ageController.text.isEmpty ||
          villeController.text.isEmpty) {
        logger.e("Case vide");
        return;
      }

      // Validation mot de passe
      if (!isPasswordValid(passwordController.text)) {
        setState(() {
          response =
              "Le mot de passe doit contenir au moins 8 caractères avec un chiffre et un caractère spécial.";
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
      logger.i(result.ok);

      if (result.ok) {
        setState(() {
          if (result.data['success'] == true) {
            response = "Inscription réussie !";
          } else {
            // erreur
            response = result.data['error'];
          }
        });
      }
    } catch (error) {
      logger.e("Erreur inattendue: $error");
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
              TextField(
                controller: ageController,
                decoration: const InputDecoration(hintText: "Age"),
              ),
              TextField(
                controller: villeController,
                decoration: const InputDecoration(hintText: "Ville"),
              ),
              const SizedBox(height: 16), // Ajoute espace
              ElevatedButton(
                onPressed: createUser,
                child: const Text("Créer"),
              ),
              const SizedBox(height: 8), // Ajoute espace
              Text(response),
            ],
          ),
        ),
      ),
    );
  }
}
