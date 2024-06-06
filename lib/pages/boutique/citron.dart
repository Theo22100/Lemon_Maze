import 'package:flutter/material.dart';
import 'package:LemonMaze/modules/http.dart';
import 'package:LemonMaze/pages/boutique/boutique.dart';
import 'package:LemonMaze/pages/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

import '../home/bottom_nav.dart';

var logger = Logger();
String response = "";

class CitronPage extends StatefulWidget {
  const CitronPage({super.key});

  @override
  _CitronPageState createState() => _CitronPageState();
}

class _CitronPageState extends State<CitronPage> {
  String? userId;
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

    // Vérif
    if (userId == null || userId.isEmpty) {
      logger.e("Impossible de récupérer l'ID de l'utilisateur");
      return;
    }

    // requête HTTP GET pour récup données user
    final response = await http_get("user/getuser/$userId");

    // Vérifier sirequête a réussi
    if (response.data['success']) {
      // Extraire données user de la réponse
      final userData = response.data["data"];

      // Extrairecitrons user
      final citronvert = userData["citronVert"].toString();
      final citronjaune = userData["citronJaune"].toString();
      final citronrouge = userData["citronRouge"].toString();
      final citronbleu = userData["citronBleu"].toString();
      await prefs.setInt('citronRouge', userData['citronRouge']);
      await prefs.setInt('citronJaune', userData['citronJaune']);
      await prefs.setInt('citronVert', userData['citronVert']);
      await prefs.setInt('citronBleu', userData['citronBleu']);

      // MAJ état user avec données récupérées
      setState(() {
        this.userId = userId;
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
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        // Retourner false pour bloquer la touche retour
        return false;
      },
      child: Scaffold(
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
                      const Text(
                        "Amuse-toi bien !",
                        style: TextStyle(
                          fontFamily: 'Gustavo',
                          fontWeight: FontWeight.w500,
                          fontSize: 34,
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
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: Container(
                  color: const Color(0xFFFAF6D0),
                  height: screenHeight / 1.45,
                  width: screenWidth,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: screenHeight * 0.02),
                        const Text(
                          'Mes bons citrons',
                          style: TextStyle(
                            fontSize: 25,
                            fontFamily: 'Outfit',
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFEB622B),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        _buildInfoBox('assets/images/boutique/citronvert.png',
                            'Citron Bibliothèque', citronvert, context),
                        const SizedBox(height: 10),
                        _buildInfoBox('assets/images/boutique/citronbleu.png',
                            'Citron Musée', citronbleu, context),
                        const SizedBox(height: 10),
                        _buildInfoBox('assets/images/boutique/citronrouge.png',
                            'Citron Bar', citronrouge, context),
                        const SizedBox(height: 10),
                        _buildInfoBox('assets/images/boutique/citronjaune.png',
                            'Citron Restaurant', citronjaune, context),
                        const SizedBox(height: 10),
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
                        const SizedBox(height: 20),
                        _buildShopButton(context),
                        Image.asset(
                          'assets/images/boutique/shop-bot.png',
                          fit: BoxFit.cover,
                          alignment: Alignment.bottomCenter,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: const BottomNavigationBarWidget(),
      ),
    );
  }

  Widget _buildInfoBox(
      String imagePath, String title, String? points, BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    // final double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEDE54F),
        borderRadius: BorderRadius.circular(30),
      ),
      padding: EdgeInsets.all(screenWidth * 0.025),
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.015),
      child: Row(
        children: [
          Image.asset(
            imagePath,
            width: screenWidth * 0.15,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w400,
                fontSize: 17,
                color: Color(0xFFEB622B),
              ),
            ),
          ),
          points == null
              ? const CircularProgressIndicator(
                  color: Color(0xFFEB622B),
                )
              : _buildPointsBox('$points Pts', context),
        ],
      ),
    );
  }

  Widget _buildPointsBox(String points, BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    //final double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFAF6D0),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.all(screenWidth * 0.03),
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

  Widget _buildShopButton(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.2),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BoutiquePage()),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.02, horizontal: screenWidth * 0.15),
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
