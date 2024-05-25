import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_app/modules/http.dart';
import 'package:my_app/pages/boutique/boutique.dart';
import 'package:my_app/pages/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:logger/logger.dart';

var logger = Logger();
Map<String, dynamic> response = {};

class SuccesPage extends StatefulWidget {
  final int idRecompense;

  const SuccesPage({super.key, required this.idRecompense});

  @override
  _SuccesPageState createState() => _SuccesPageState();
}

class _SuccesPageState extends State<SuccesPage> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchOneRecompense(); // Appel de la fonction pour récupérer les récompenses
  }

  // Fonction pour récupérer les récompenses en fonction de l'ID de type
  Future<void> _fetchOneRecompense() async {
    setState(() {
      isLoading = true; // Définir l'indicateur de chargement sur vrai
    });
    final int idRecompense = (widget.idRecompense);
    try {
      // Appel de l'API pour récupérer les récompenses
      final result = await http_get("recompense/getrecompense/$idRecompense");

      if (result.data['success']) {
        setState(() {
          response =
              result.data['data']; // Mettre à jour la liste des récompenses
        });
      } else {
        setState(() {
          response =
              result.data['message']; // Mettre à jour le message d'erreur
        });
      }
    } catch (error) {
      logger.e("Error: $error");
      setState(() {
        response = {
          'message': "Erreur lors de la récupération des récompenses"
        }; // Mettre à jour le message d'erreur
      });
    } finally {
      setState(() {
        isLoading =
            false; // Définir l'indicateur de chargement sur faux une fois terminé
      });
    }
  }

  Future<String> _fetchLieuName(int id_lieu) async {
    try {
      final result = await http_get("lieu/getnomlieu/$id_lieu");
      if (result.data['success']) {
        return result.data['data']['nom'];
      } else {
        throw Exception("Lieu non trouvé"); // Lancer une exception
      }
    } catch (error) {
      logger.e("Erreur lors de la récupération du nom du lieu: $error");
      return "Erreur de chargement du nom du lieu";
    }
  }

// Fonction pour construire la boîte de récompense  // Fonction pour construire la boîte de récompense
  Widget _buildRecompenseBox(dynamic recompense) {
    String nom = recompense['nom'] ?? 'Nom inconnu';
    String info = recompense['info'] ?? 'Info indisponible';
    String citronVert = (recompense['citronVert'] ?? 0).toString();
    String citronJaune = (recompense['citronJaune'] ?? 0).toString();
    String citronRouge = (recompense['citronRouge'] ?? 0).toString();
    String citronBleu = (recompense['citronBleu'] ?? 0).toString();
    int id_lieu = recompense['id_lieu'] ?? 0;
    int id_type = recompense['id_type'] ?? 0;
    int idrecompense =
        recompense['idrecompense'] ?? 0; // Ajout d'une valeur par défaut

    // Vérifiez que id_recompense n'est pas null
    if (idrecompense == 0) {
      return const SizedBox
          .shrink(); // Retournez un widget vide ou un message d'erreur
    }

    String imagePath = ''; // Chemin de l'image en fonction de l'ID de type
    Color citronColor;
    String citronText;

    // Assigner le chemin de l'image et les valeurs de la boîte en fonction de l'ID de type
    switch (id_type) {
      case 1:
        imagePath = '../../assets/images/boutique/bar.png';
        citronColor = Colors.red;
        citronText = '$citronRouge PTS';
        break;
      case 2:
        imagePath = '../../assets/images/boutique/restaurant.png';
        citronColor = Colors.yellow;
        citronText = '$citronJaune PTS';
        break;
      case 3:
        imagePath = '../../assets/images/boutique/musee.png';
        citronColor = Colors.blue;
        citronText = '$citronBleu PTS';
        break;
      case 4:
        imagePath = '../../assets/images/boutique/bibliotheque.png';
        citronColor = Colors.green;
        citronText = '$citronVert PTS';
        break;
      default:
        imagePath = '';
        citronColor = Colors.transparent;
        citronText = '';
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF09B796),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Centrer verticalement l'image
          Stack(
            children: [
              Center(
                child: Image.asset(
                  imagePath,
                  width: 80,
                  height: 80,
                ),
              ),
              Positioned(
                top: 0,
                right: 15,
                child: Transform.rotate(
                  angle: -pi / 9, // Rotation
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    color: const Color(0xFFFAF6D0),
                    child: Text(
                      citronText,
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        color: citronColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nom,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFFFAF6D0),
                  ),
                ),
                const SizedBox(height: 5),
                FutureBuilder(
                  future: _fetchLieuName(id_lieu), // Récupérer le nom du lieu
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(); // indicateur de chargement si la connexion est en attente
                    } else {
                      if (snapshot.hasError) {
                        return const Text(
                            "Erreur de chargement du nom du lieu"); // Afficher message d'erreur
                      } else {
                        String lieuNom = snapshot.data
                            .toString(); // Récupérer le nom du lieu depuis le snapshot
                        return Text(
                          lieuNom,
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color(0xFFFAF6D0),
                          ),
                        );
                      }
                    }
                  },
                ),
                const SizedBox(height: 5),
                Text(
                  info,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color(0xFFFAF6D0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Avoir taille ecran pour image
    final screenSize = MediaQuery.of(context).size;

    final imageWidth = screenSize.width * 0.4;
    final imageHeight = screenSize.height * 0.2;

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              '../../assets/images/welcome/wallpaper.png',
              fit: BoxFit.cover,
            ),
          ),
          // Back button at the top left
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BoutiquePage()),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      '../../assets/images/boutique/backhomecitron.png',
                      width: 50,
                      height: 50,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Commande réglée, succès !",
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.w500,
                        fontSize: 40,
                        color: Color(0xFFFAF6D0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: Container(
                    color: const Color(0xFFFAF6D0),
                    height: MediaQuery.of(context).size.height / 1.30,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),
                          const Text(
                            'Validation de ma commande',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.w600,
                              fontSize: 22,
                              color: Color(0xFFEB622B),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildRecompenseBox(response),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              // Logique pour confirmer la demande
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFFE9581B), // Couleur du fond
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(20), // Bords arrondis
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 16), // Taille du bouton
                            ),
                            child: const Text(
                              //InventoryPage
                              'Voir inventaire',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white, // Couleur du texte
                                fontSize: 18, // Taille de la police
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
