import 'package:flutter/material.dart';
import 'package:my_app/modules/http.dart';

// Classe représentant la page d'ajout d'utilisateur
class AddUserPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddUserPageState();
  }
}

// État de la page d'ajout d'utilisateur
class AddUserPageState extends State<AddUserPage> {
  // Contrôleur pour le champ de texte du nom d'utilisateur
  TextEditingController nameController = TextEditingController();

  // Variable pour stocker la réponse de la requête HTTP
  String response = "";

  // Fonction pour créer un utilisateur en utilisant une requête HTTP POST
  createUser() async {
    // Effectuer une requête HTTP POST vers le point de terminaison "create-user"
    var result = await http_post("create-user", {
      "name": nameController.text,
    });

    // Si la requête est réussie (result.ok est true), mettre à jour l'état
    // pour afficher la réponse renvoyée par le serveur
    if (result.ok) {
      setState(() {
        response = result.data['status'];
      });
    }
  }

  // Méthode build pour construire l'interface utilisateur de la page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajout User"),
      ),
      body: Column(
        children: <Widget>[
          // Champ de texte pour le nom d'utilisateur
          TextField(
            controller: nameController,
            decoration: InputDecoration(hintText: "Nom"),
          ),

          // Bouton pour créer l'utilisateur
          TextButton(
            child: Text("Créer"),
            onPressed: createUser,
          ),

          // Affichage de la réponse de la requête HTTP
          Text(response),
        ],
      ),
    );
  }
}
