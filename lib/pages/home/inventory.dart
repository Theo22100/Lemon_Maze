import 'package:flutter/material.dart';
import 'package:LemonMaze/modules/http.dart'; // Assurez-vous que ce package existe et contient les fonctions http_get et http_delete
import 'package:LemonMaze/pages/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

import 'package:logger/logger.dart';

var logger = Logger();

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  List<dynamic> recompenses = [];
  bool isLoading = false;
  String response = "";
  String responsealert = "";
  String code = "";

  @override
  void initState() {
    super.initState();
    _fetchRecompensesUsers();
  }

  Future<void> navigateToInventory() async {
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const InventoryPage()),
    );
  }

  // Récupération des récompenses de l'utilisateur
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
          response = "Pas de récompenses :(";
        });
      }
    } catch (error) {
      logger.e("Erreur lors de la récupération des récompenses: $error");
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
    return WillPopScope(
      onWillPop: () async {
        // Retourner false pour bloquer la touche retour
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/welcome/wallpaper.png',
                fit: BoxFit.cover,
              ),
            ),
            _buildHeader(context),
            _buildRecompenseList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Align(
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
    );
  }

  Widget _buildRecompenseList() {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: Container(
          color: const Color(0xFFFAF6D0),
          height: screenHeight / 1.30,
          width: screenWidth,
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
              if (response.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(bottom: screenHeight / 1.8),
                  child: Text(
                    response,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.w400,
                      fontSize: 24,
                      color: Color(0xFFEB622B),
                    ),
                  ),
                ),
            ],
          ),
        ),
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
    int idRecompenseUser = recompense['id_recompense_user'] ?? 0;

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
        getCode(idRecompenseUser);
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
                    future: _fetchLieuName(idLieu),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else {
                        if (snapshot.hasError) {
                          return const Text(
                              "Erreur de chargement du nom du lieu");
                        } else {
                          String lieuNom = snapshot.data.toString();
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

  Future<void> getCode(int idrecompense) async {
    try {
      var result = await http_get("recompense_user/getcode/$idrecompense");
      if (result.ok) {
        var data = result.data;
        if (data != null) {
          setState(() {
            code = result.data['code'];
          });
          _showCodeDialog(code, idrecompense);
        } else {
          logger.e("La réponse 'data' ou la clé 'code' est nulle");
        }
      } else {
        logger.e("Échec de la récupération des données de la partie");
      }
    } catch (error) {
      logger.e("Erreur lors de l'appel HTTP : $error");
    }
  }

  void _showCodeDialog(String code, int idRecompenseUser) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color(0xFFFAF6D0),
          content: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Code de la récompense",
                    style: TextStyle(
                      fontFamily: 'Gustavo',
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                      color: Color(0xFFEB622B),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: Text(
                      code,
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                        color: Color(0xFFEB622B),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Center(
                    child: Text(
                      "Veuillez faire valider ce code auprès de l'établissement concerné pour obtenir votre récompense.\nLorsque cela est fait et que l'établissement vous l'autorise, veuillez valider !\n\nAucun remboursement, en cas d'erreur.\nVoir conditions d'utilisation",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.w300,
                        fontSize: 16,
                        color: Color(0xFFEB622B),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFBBA2C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      deleteRecompenseUser(idRecompenseUser);
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "Valider",
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.w400,
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                right: 0,
                top: 0,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  color: Colors.black,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> deleteRecompenseUser(int idRecompenseUser) async {
    var route = "recompense_user/delete-recompense_user/$idRecompenseUser";
    var result = await http_delete(route);

    if (result.ok) {
      if (result.data['success'] == true) {
        setState(() {
          recompenses.removeWhere((recompense) =>
              recompense['id_recompense_user'] == idRecompenseUser);
          if (recompenses.isEmpty) {
            response = "Pas de récompenses :(";
          }
        });
      } else {
        setState(() {
          responsealert = result.data['message'];
        });
      }
    }
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
