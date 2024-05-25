import 'package:flutter/material.dart';
import 'package:my_app/modules/http.dart';
import 'package:my_app/pages/boutique/citron.dart';
import 'package:my_app/pages/boutique/confirm.dart';
import 'package:my_app/pages/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

import 'package:logger/logger.dart';

var logger = Logger();
String response = "";

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  List<dynamic> recompenses = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchRecompensesUsers();
  }

  Future<void> _fetchRecompensesUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('id');

    if (userId == null || userId.isEmpty) {
      setState(() {
        response = "Erreur: ID utilisateur non trouvé";
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final result =
          await http_get("recompense_user/list_user_recompenses/$userId");

      if (result.data['success']) {
        setState(() {
          recompenses = result.data['recompenses'];
        });
      } else {
        setState(() {
          response = result.data['message'];
        });
      }
    } catch (error) {
      setState(() {
        response = "Erreur lors de la récupération des récompenses";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/welcome/wallpaper.png',
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
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
                      "Mon inventaire",
                      style: TextStyle(
                        fontSize: 40,
                        color: Color(0xFFFAF6D0),
                        fontFamily: 'Gustavo',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              child: Container(
                color: const Color(0xFFFAF6D0),
                height: MediaQuery.of(context).size.height / 1.30,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Expanded(
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.builder(
                              itemCount: recompenses.length,
                              itemBuilder: (BuildContext context, int index) {
                                final recompense = recompenses[index];
                                return _buildRecompenseBox(recompense);
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
    );
  }

  Widget _buildRecompenseBox(dynamic recompense) {
    String nom = recompense['nom'] ?? 'Nom inconnu';
    String info = recompense['info'] ?? 'Info indisponible';
    String citronVert = (recompense['citronVert'] ?? 0).toString();
    String citronJaune = (recompense['citronJaune'] ?? 0).toString();
    String citronRouge = (recompense['citronRouge'] ?? 0).toString();
    String citronBleu = (recompense['citronBleu'] ?? 0).toString();
    int idLieu = recompense['id_lieu'] ?? 0;
    int idType = recompense['id_type'] ?? 0;
    int idRecompense = recompense['id_recompense'] ?? 0;

    if (idRecompense == 0) {
      logger.w("Récompense avec id_recompense 0 trouvée : $recompense");
      return const SizedBox.shrink();
    }

    String imagePath;
    Color citronColor;
    String citronText;

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

    if (imagePath.isEmpty) {
      logger.w("Chemin de l'image vide pour la récompense : $recompense");
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConfirmPage(idRecompense: idRecompense),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFFAB92C),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    angle: -pi / 9,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
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
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nom,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Color(0xFFFAF6D0),
                    ),
                  ),
                  const SizedBox(height: 4),
                  FutureBuilder(
                    future: _fetchLieuName(idLieu), // Récupérer le nom du lieu
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
                  const SizedBox(height: 6),
                  Text(
                    info,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.w600,
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

  Future<String> _fetchLieuName(int idLieu) async {
    try {
      final result = await http_get("lieu/getnomlieu/$idLieu");
      if (result.data['success']) {
        return result.data['data']['nom'];
      } else {
        throw Exception("Lieu non trouvé");
      }
    } catch (error) {
      return "Erreur de chargement du nom du lieu";
    }
  }
}
