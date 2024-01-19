import 'package:flutter/material.dart';
import 'package:my_app/modules/http.dart';

class LoginPage extends StatefulWidget {
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
          response = result.data['status'];
        });
      } else {
        // Gérer les erreurs de connexion
        setState(() {
          response =
              "Échec de la connexion. Vérifiez vos informations d'identification.";
        });
      }
    } catch (error) {
      // Gérer les erreurs inattendues
      print("Error: $error");
    }
  }

  // Fonction pour hash le mot de passe (utilisez la bibliothèque crypto)
  String hashPassword(String password) {
    // À implémenter : Utilisez la bibliothèque crypto pour hasher le mot de passe
    // Veuillez vous référer à la documentation de la bibliothèque crypto pour plus de détails.
    return password;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Page de Connexion"),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: pseudoController,
            decoration: InputDecoration(hintText: "Pseudo"),
          ),
          TextField(
            controller: passwordController,
            obscureText: true, // Cacher le texte du mot de passe
            decoration: InputDecoration(hintText: "Mot de passe"),
          ),
          TextButton(
            child: Text("Se Connecter"),
            onPressed: loginUser,
          ),
          Text(response),
        ],
      ),
    );
  }
}
