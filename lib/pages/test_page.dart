import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:my_app/modules/http.dart';
import 'package:my_app/pages/register-login/login_page.dart';
import 'package:my_app/pages/register-login/registerPage.dart';

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
  String age;
  String ville;
  User(this.id, this.pseudo, this.mail, this.password, this.age, this.ville);
}

// État de la page principale
class TestPageState extends State<TestPage> {
  // Liste pour stocker les utilisateurs récupérés
  List<User> users = [];

  Future<void> refreshUsers() async {
    logger.i("Actualisation des utilisateurs...");

    // Récupérer la liste des utilisateurs
    var response = await http_get('user/users');

    if (response != null && response.ok) {
      // Si la réponse n'est pas nulle et que la requête est réussie
      setState(() {
        users.clear();
        var responseData = response.data;

        // Vérifiez si la réponse contient une clé 'data' et si sa valeur est une liste
        if (responseData != null && responseData['success'] == true) {
          var userDataList = responseData['data'];

          // Assurez-vous que userDataList est une liste
          if (userDataList is List) {
            for (var userData in userDataList) {
              users.add(User(
                userData['id'].toString(),
                userData['pseudo'] ??
                    '', // Vérifiez si 'pseudo' est nul, sinon utilisez une chaîne vide
                userData['mail'] ??
                    '', // Vérifiez si 'mail' est nul, sinon utilisez une chaîne vide
                userData['password'] ??
                    '', // Vérifiez si 'password' est nul, sinon utilisez une chaîne vide
                userData['age']?.toString() ??
                    '', // Vérifiez si 'age' est nul, sinon utilisez une chaîne vide
                userData['ville'] ??
                    '', // Vérifiez si 'ville' est nul, sinon utilisez une chaîne vide
              ));
            }
          } else {
            logger.e("Données de réponse invalides : $userDataList");
          }
        } else {
          logger.e("Réponse de l'API invalide : $responseData");
        }

        logger.i("Utilisateurs mis à jour : $users");
      });
    } else {
      // Si la réponse est nulle ou si la requête a échoué
      logger.e(
          "Impossible d'actualiser les utilisateurs. Erreur : ${response?.data['error']}");
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
                "${users[i].pseudo} ${users[i].mail} ${users[i].password} ${users[i].age} ${users[i].ville}"),
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
