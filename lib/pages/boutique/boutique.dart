import 'package:flutter/material.dart';
import 'package:LemonMaze/modules/http.dart';
import 'package:LemonMaze/pages/boutique/citron.dart';
import 'package:LemonMaze/pages/boutique/confirm.dart';
import 'dart:math';

import 'package:logger/logger.dart';

import '../home/bottom_nav.dart';

var logger = Logger();
String response = "";

class BoutiquePage extends StatefulWidget {
  const BoutiquePage({super.key});

  @override
  BoutiquePageState createState() => BoutiquePageState();
}

class BoutiquePageState extends State<BoutiquePage> {
  List<dynamic> recompenses = []; // Liste des récompenses
  bool isLoading = false; // Indicateur de chargement

  @override
  void initState() {
    super.initState();
    _fetchRecompenses(); // Appel de la fonction pour récupérer les récompenses
  }

  // Fonction pour récupérer les récompenses en fonction de l'ID de type
  Future<void> _fetchRecompenses() async {
    setState(() {
      isLoading = true; // Définir l'indicateur de chargement sur vrai
    });

    try {
      // Appel de l'API pour récupérer les récompenses
      final result = await http_get("recompense/recompenses");

      if (result.data['success']) {
        setState(() {
          recompenses =
              result.data['message']; // MAJ liste des récompenses
        });
      } else {
        setState(() {
          response =
              result.data['message']; // MAJ message erreur
        });
      }
    } catch (error) {
      setState(() {
        response =
            "Erreur lors de la récupération des récompenses"; // MAJ lmessage erreur
      });
    } finally {
      setState(() {
        isLoading =
            false; // Définir indicateur de chargement sur faux une fois terminé
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              'assets/images/welcome/wallpaper.png',
              fit: BoxFit.cover,
            ),
          ),
          // Bouton retour à CitronPage
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CitronPage()),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/boutique/backhomecitron.png',
                      width: 50,
                      height: 50,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Ma Boutique !",
                      style: TextStyle(
                        fontFamily: 'Gustavo',
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
          //zone beige

          Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              child: Container(
                color: const Color(0xFFFAF6D0),
                height: MediaQuery.of(context).size.height / 1.45,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Les offres',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                        color: Color(0xFFEB622B),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                              color: Color(0xFFEB622B),
                            ))
                          : ListView.builder(
                              itemCount: recompenses.length,
                              itemBuilder: (BuildContext context, int index) {
                                final recompense = recompenses[index];
                                return _buildRecompenseBox(recompense, context);
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavigationBarWidget(),
    );
  }

  // Fonction pour construire la boîte de récompense
  Widget _buildRecompenseBox(dynamic recompense, BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    String nom = recompense['nom'] ?? 'Nom inconnu';
    String info = recompense['info'] ?? 'Info indisponible';
    String citronVert = (recompense['citronVert'] ?? 0).toString();
    String citronJaune = (recompense['citronJaune'] ?? 0).toString();
    String citronRouge = (recompense['citronRouge'] ?? 0).toString();
    String citronBleu = (recompense['citronBleu'] ?? 0).toString();
    int idLieu = recompense['id_lieu'] ?? 0;
    int idType = recompense['id_type'] ?? 0;
    int idrecompense = recompense['idrecompense'] ?? 0;

    if (idrecompense == 0) {
      return const SizedBox.shrink();
    }

    String imagePath = ''; // Chemin de l'image en fonction de l'ID de type
    Color citronColor;
    String citronText;

    // Assigner le chemin de 'image et les valeurs de la boîte en fonction de l'ID de type
    switch (idType) {
      case 1:
        imagePath = 'assets/images/boutique/bar.png';
        citronColor = Colors.red;
        citronText = '$citronRouge PTS';
        break;
      case 2:
        imagePath = 'assets/images/boutique/restaurant.png';
        citronColor = Colors.yellow;
        citronText = '$citronJaune PTS';
        break;
      case 3:
        imagePath = 'assets/images/boutique/musee.png';
        citronColor = Colors.blue;
        citronText = '$citronBleu PTS';
        break;
      case 4:
        imagePath = 'assets/images/boutique/bibliotheque.png';
        citronColor = Colors.green;
        citronText = '$citronVert PTS';
        break;
      default:
        imagePath = '';
        citronColor = Colors.transparent;
        citronText = '';
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConfirmPage(idRecompense: idrecompense),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFFFAB92C),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Centrer verticalement l'image
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.02,
                      vertical: screenHeight * 0.02),
                  child: Image.asset(
                    imagePath,
                    width: screenWidth * 0.2,
                    height: screenHeight * 0.1,
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.015,
                  right: screenWidth * 0.07,
                  child: Transform.rotate(
                    angle: -pi / 9, // Rotation
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.02,
                          vertical: screenHeight * 0.005),
                      color: const Color(0xFFFAF6D0),
                      child: Text(
                        citronText,
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontWeight: FontWeight.w600,
                          color: citronColor,
                          fontSize: 12,
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
                    future: _fetchLieuName(idLieu), // Récupérer le nom du lieu
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(
                          color: Color(0xFFEB622B),
                        ); // indicateur de chargement si connexion en attente
                      } else {
                        if (snapshot.hasError) {
                          return const Text(
                              "Erreur de chargement du nom du lieu"); // Afficher message erreur
                        } else {
                          String lieuNom = snapshot.data
                              .toString(); // Récupérer nom du lieu depuis snapshot
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
      ),
    );
  }

  // Fonction pour récupérer le nom lieu en fonction de l'ID lieu
  Future<String> _fetchLieuName(int idLieu) async {
    try {
      final result = await http_get("lieu/getnomlieu/$idLieu");
      if (result.data['success']) {
        return result.data['data']['nom'];
      } else {
        throw Exception("Lieu non trouvé"); // Lancer exception
      }
    } catch (error) {
      return "Erreur de chargement du nom du lieu";
    }
  }
}
