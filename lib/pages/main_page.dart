import 'package:flutter/material.dart';
import 'package:my_app/modules/http.dart';
import 'package:my_app/pages/add_user_page.dart';

// Classe représentant la page principale
class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  }
}

// Classe représentant un utilisateur
class User {
  String id;
  String name;
  User(this.id, this.name);
}

// État de la page principale
class MainPageState extends State<MainPage> {
  // Liste pour stocker les utilisateurs récupérés
  List<User> users = [];

  // Fonction asynchrone pour rafraîchir la liste des utilisateurs
  Future<void> refreshUsers() async {
    // Effectuer une requête HTTP GET pour récupérer la liste des utilisateurs
    var result = await http_get('users');

    // Si la requête est réussie (result.ok est true), mettre à jour l'état
    // pour refléter la nouvelle liste d'utilisateurs
    if (result.ok) {
      setState(() {
        users.clear();
        var in_users = result.data as List<dynamic>;
        in_users.forEach((in_user) {
          users.add(User(in_user['id'].toString(), in_user['name']));
        });
      });
    }
  }

  // Méthode build pour construire l'interface utilisateur de la page principale
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
        // Bouton d'ajout d'utilisateur dans la barre d'applications
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Naviguer vers la page d'ajout d'utilisateur
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return AddUserPage();
              }));
            },
          )
        ],
      ),
      // Utilisation de RefreshIndicator pour permettre le rafraîchissement de la liste
      body: RefreshIndicator(
        onRefresh: refreshUsers,
        // Liste déroulante de type séparateur avec des tuiles représentant chaque utilisateur
        child: ListView.separated(
          itemCount: users.length,
          itemBuilder: (context, i) => ListTile(
            leading: Icon(Icons.person),
            title: Text(users[i].name),
          ),
          separatorBuilder: (context, i) => Divider(),
        ),
      ),
    );
  }
}
