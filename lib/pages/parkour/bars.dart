import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:my_app/modules/http.dart';

var logger = Logger();

// Classe ParkourBar
class ParkourBar {
  int id_parkour;
  int id_type = 2;
  int id_lieu1;
  int id_lieu2;
  int id_lieu3;
  int id_lieu4;
  ParkourBar(this.id_parkour, this.id_type, this.id_lieu1, this.id_lieu2,
      this.id_lieu3, this.id_lieu4);
}

// Classe représentant la page principale
class ParkourBarPage extends StatefulWidget {
  const ParkourBarPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ParkourBarPageState();
  }
}

// État de la page principale
class ParkourBarPageState extends State<ParkourBarPage> {
  // Liste pour stocker les utilisateurs récupérés
  List<ParkourBar> parkourBars = [];

  // Fonction asynchrone pour rafraîchir liste utilisateurs
  Future<void> refreshParkours() async {
    logger.i("Refreshing parkours...");

    // Récupérer la liste des utilisateurs
    var result = await http_get('parkourBar');

    if (result.ok) {
      // Si la requête est réussie, mettre à jour l'état pour refléter la nouvelle liste d'utilisateurs
      setState(() {
        parkourBars.clear();
        var inParkourBars = result.data as List<dynamic>;
        for (var inParkourBar in inParkourBars) {
          parkourBars.add(ParkourBar(
            inParkourBar['id_parkour'],
            inParkourBar['id_type'],
            inParkourBar['id_lieu1'],
            inParkourBar['id_lieu2'],
            inParkourBar['id_lieu3'],
            inParkourBar['id_lieu4'],
          ));
        }

        logger.i("Parkour updated: $inParkourBars");
      });
    } else {
      // Erreur
      logger.e("Failed to refresh Parkour. Error: ${result.data['error']}");
    }
  }

  // Méthode Construire l'interface utilisateur
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Parkour"),
        actions: <Widget>[
          // Bouton de rafraîchissement des utilisateurs
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: refreshParkours,
          ),
        ],
      ),
    );
  }
}

// Fonction Flutter
void main() {
  runApp(const MaterialApp(
    home: ParkourBarPage(),
    debugShowCheckedModeBanner: false,
  ));
}
