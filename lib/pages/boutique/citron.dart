import 'package:flutter/material.dart';
import 'package:my_app/modules/http.dart';
import 'package:my_app/pages/boutique/boutique.dart';
import 'package:my_app/pages/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:logger/logger.dart';

var logger = Logger();
String response = "";

class CitronPage extends StatefulWidget {
  const CitronPage({super.key});

  @override
  _CitronPageState createState() => _CitronPageState();
}

class _CitronPageState extends State<CitronPage> {
  String? userId;
  String? pseudo;
  String? citronvert;
  String? citronjaune;
  String? citronrouge;
  String? citronbleu;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('id');

    // Vérifier d'abord si userId est null ou vide
    if (userId == null || userId.isEmpty) {
      // Gérer le cas où userId est null ou vide
      return;
    }

    // Effectuer une requête HTTP GET pour récupérer les données de l'utilisateur
    final response = await http_get("user/getuser/$userId");

    // Vérifier si la requête a réussi
    if (response.data['success']) {
      // Extraire les données de l'utilisateur à partir de la réponse
      final userData = response.data["data"];

      // Extraire le pseudo de l'utilisateur
      final pseudo = userData["pseudo"];
      final citronvert = userData["citronVert"].toString();
      final citronjaune = userData["citronJaune"].toString();
      final citronrouge = userData["citronRouge"].toString();
      final citronbleu = userData["citronBleu"].toString();
      await prefs.setInt('citronRouge', userData['citronRouge']);
      await prefs.setInt('citronJaune', userData['citronJaune']);
      await prefs.setInt('citronVert', userData['citronVert']);
      await prefs.setInt('citronBleu', userData['citronBleu']);

      // Mettre à jour l'état de l'utilisateur avec le pseudo récupéré
      setState(() {
        this.userId = userId;
        this.pseudo = pseudo;
        this.citronvert = citronvert;
        this.citronjaune = citronjaune;
        this.citronrouge = citronrouge;
        this.citronbleu = citronbleu;
      });
    } else {
      // Gérer le cas où la requête a échoué
      logger.e(
          "Erreur lors de la récupération des données de l'utilisateur: ${response.data['message']}");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Avoir taille ecran pour image
    final screenSize = MediaQuery.of(context).size;

    // final imageWidth = screenSize.width * 0.4;
    // final imageHeight = screenSize.height * 0.2;

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
          // Bouton retour
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
                    Text(
                      "Bravo à toi $pseudo !",
                      style: const TextStyle(
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
                          const SizedBox(height: 5),
                          const Text(
                            'Mes bons citrons',
                            style: TextStyle(
                              fontSize: 22,
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFEB622B),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildInfoBox(
                              'assets/images/boutique/citronvert.png',
                              'Citron Bibliothèque',
                              '$citronvert PTS'),
                          const SizedBox(height: 10),
                          _buildInfoBox(
                              'assets/images/boutique/citronbleu.png',
                              'Citron Musée',
                              '$citronbleu PTS'),
                          const SizedBox(height: 10),
                          _buildInfoBox(
                              'assets/images/boutique/citronrouge.png',
                              'Citron Bar',
                              '$citronrouge PTS'),
                          const SizedBox(height: 10),
                          _buildInfoBox(
                              'assets/images/boutique/citronjaune.png',
                              'Citron Restaurant',
                              '$citronjaune PTS'),
                          const SizedBox(height: 40),
                          Text(
                            response,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Image.asset(
                    'assets/images/boutique/shop-bot.png',
                    fit: BoxFit.cover,
                    alignment: Alignment.bottomCenter,
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 90,
                  child: _buildShopButton(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox(
    String imagePath,
    String title,
    String points,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEDE54F),
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Image.asset(
            imagePath,
            width: 48,
            height: 48,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Color(0xFFEB622B),
              ),
            ),
          ),
          _buildPointsBox(points),
        ],
      ),
    );
  }

  Widget _buildPointsBox(String points) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFAF6D0),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(16),
      child: Text(
        points,
        style: const TextStyle(
          fontSize: 16,
          color: Color(0xFFFBBA2C),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildShopButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BoutiquePage()),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric( vertical: 15),
          backgroundColor: const Color(0xFFEB622B).withOpacity(0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text(
          "La boutique",
          style: TextStyle(
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
