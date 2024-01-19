import 'package:flutter/material.dart';
import 'package:my_app/modules/http.dart';
import 'package:my_app/pages/login_page.dart';
import 'package:my_app/pages/register_page.dart';

// Classe représentant la page principale
class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  }
}

// Classe Utilisateur
class User {
  String id;
  String pseudo;
  String mail;
  String name;
  String surname;
  String password;
  User(this.id, this.pseudo, this.mail, this.name, this.surname, this.password);
}

// État de la page principale
class MainPageState extends State<MainPage> {
  // Liste pour stocker les utilisateurs récupérés
  List<User> users = [];

  // Fonction asynchrone pour rafraîchir la liste des utilisateurs
  Future<void> refreshUsers() async {
    print("Refreshing users...");

    // Récupérer la liste des utilisateurs
    var result = await http_get('users');

    if (result.ok) {
      // Si la requête est réussie, mettre à jour l'état pour refléter la nouvelle liste d'utilisateurs
      setState(() {
        users.clear();
        var in_users = result.data as List<dynamic>;
        in_users.forEach((in_user) {
          users.add(User(
              in_user['id'].toString(),
              in_user['pseudo'],
              in_user['mail'],
              in_user['name'],
              in_user['surname'],
              in_user['password']));
        });

        print("Users updated: $users");
      });
    } else {
      // Erreur
      print("Failed to refresh users. Error: ${result.data['error']}");
    }
  }

  // Méthode Construire l'interface utilisateur
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
        actions: <Widget>[
          // Bouton de rafraîchissement des utilisateurs
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: refreshUsers,
          ),
          // Bouton d'ajout d'utilisateur
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Naviguer vers la page d'ajout d'utilisateur
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return AddUserPage();
              }));
            },
          ),
          IconButton(
            icon: Icon(Icons.login),
            onPressed: () {
              // Naviguer vers la page d'ajout d'utilisateur
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return LoginPage();
              }));
            },
          ),
        ],
      ),
      // Utilisation de RefreshIndicator pour rafraîchissement
      body: RefreshIndicator(
        onRefresh: refreshUsers,
        // Liste déroulante utilisateur
        child: ListView.separated(
          itemCount: users.length,
          itemBuilder: (context, i) => ListTile(
            leading: Icon(Icons.person),
            title: Text(
                "${users[i].pseudo} ${users[i].mail} ${users[i].name} ${users[i].surname} ${users[i].password}"),
          ),
          separatorBuilder: (context, i) => Divider(),
        ),
      ),
    );
  }
}

// Fonction Flutter
void main() {
  runApp(MaterialApp(
    home: MainPage(),
  ));
}
