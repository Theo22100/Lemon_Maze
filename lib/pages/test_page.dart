import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:my_app/modules/http.dart';
import 'package:my_app/pages/register-login/login_page.dart';
import 'package:my_app/pages/register-login/register_page.dart';

var logger = Logger();

// Classe représentant la page principale
class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return TestPageState();
  }
}

// Classe Utilisateur
class User {
  String id;
  String pseudo;
  String mail;
  String password;
  User(this.id, this.pseudo, this.mail, this.password);
}

// État de la page principale
class TestPageState extends State<TestPage> {
  // Liste pour stocker les utilisateurs récupérés
  List<User> users = [];

  // Fonction asynchrone pour rafraîchir liste utilisateurs
  Future<void> refreshUsers() async {
    logger.i("Refreshing users...");

    // Récupérer la liste des utilisateurs
    var result = await http_get('users');

    if (result.ok) {
      // Si la requête est réussie, mettre à jour l'état pour refléter la nouvelle liste d'utilisateurs
      setState(() {
        users.clear();
        var inUsers = result.data as List<dynamic>;
        for (var inUser in inUsers) {
          users.add(User(inUser['id'].toString(), inUser['pseudo'],
              inUser['mail'], inUser['password']));
        }

        logger.i("Users updated: $users");
      });
    } else {
      // Erreur
      logger.e("Failed to refresh users. Error: ${result.data['error']}");
    }
  }

  // Méthode Construire l'interface utilisateur
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
        actions: <Widget>[
          // Bouton de rafraîchissement des utilisateurs
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: refreshUsers,
          ),
          // Bouton d'ajout d'utilisateur
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Naviguer vers la page d'ajout d'utilisateur
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const RegisterPage();
              }));
            },
          ),
          IconButton(
            icon: const Icon(Icons.login),
            onPressed: () {
              // Naviguer vers la page d'ajout d'utilisateur
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const AuthScreen();
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
            leading: const Icon(Icons.person),
            title: Text(
                "${users[i].pseudo} ${users[i].mail} ${users[i].password}"),
          ),
          separatorBuilder: (context, i) => const Divider(),
        ),
      ),
    );
  }
}

// Fonction Flutter
void main() {
  runApp(const MaterialApp(
    home: TestPage(),
  ));
}
