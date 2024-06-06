import 'dart:math';
import 'package:flutter/material.dart';
import 'package:LemonMaze/modules/http.dart';
import 'package:LemonMaze/pages/parkour/bar/bar_intro_1.dart';
import 'package:LemonMaze/pages/register-login/login_signup_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

import 'bottom_nav.dart';

var logger = Logger();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final List<String> images = [
    'assets/images/home/announce/announce1.png',
    'assets/images/home/announce/announce2.png',
    'assets/images/home/announce/announce3.png'
  ]; // Liste des images pour carrousel annonces

  int _currentIndex = 0; // Index actuel du carrousel annonces
  late PageController
      _pageController; // Contrôleur page pour carrousel annonces

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
        initialPage: _currentIndex); // Initialisation contrôleur la page
  }

  @override
  void dispose() {
    _pageController
        .dispose(); // Dispose contrôleur page lorsqu'il n'est plus utilisé
    super.dispose();
  }

  // Fonction pour effacer SharedPreferences
  void _clearSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    bool isFirstLogin = prefs.getBool('isFirstLogin') ?? false;
    await prefs.clear();
    await prefs.setBool('isFirstLogin', isFirstLogin);
  }

  // Fonction pour obtenir ID user
  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('id');
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth =
        MediaQuery.of(context).size.width; // Largeur écran
    final double screenHeight =
        MediaQuery.of(context).size.height; // Hauteur écran

    return WillPopScope(
      onWillPop: () async => false, // Désactive bouton retour
      child: Scaffold(
        body: Container(
          color: const Color(0xFFFAF6D0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/images/home/titre.png',
                          width: screenWidth * 0.4,
                        ),
                      ),
                      Positioned(
                        right: screenWidth * 0.05,
                        top: 0,
                        child: IconButton(
                          onPressed: () => _showLogoutDialog(context),
                          icon: const Icon(Icons.logout,
                              color: Color(0xFFEB622B)),
                          iconSize: screenHeight * 0.033,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _buildAnnouncementCarousel(
                      screenWidth, screenHeight), // Carrousel annonces
                  const SizedBox(height: 32),
                  _buildChoiceGrid(
                      context, screenWidth, screenHeight), // Grille de choix
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: const BottomNavigationBarWidget(),
      ),
    );
  }

  // Widget pour construire carrousel
  Widget _buildAnnouncementCarousel(double screenWidth, double screenHeight) {
    return SizedBox(
      height: screenHeight * 0.2,
      child: Stack(
        children: [
          PageView.builder(
            itemCount: images.length,
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index; // MAJ index actuel lors changement page
              });
            },
            itemBuilder: (context, index) {
              return SizedBox(
                width: screenWidth * 0.2,
                child: Image.asset(images[index]),
              );
            },
          ),
          if (_currentIndex > 0)
            Positioned(
              top: screenHeight * 0.07,
              left: screenWidth * 0.01,
              child: IconButton(
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ); // Passe à la page précédente
                },
                icon: const Icon(Icons.arrow_back),
                iconSize: screenHeight * 0.036,
              ),
            ),
          if (_currentIndex < images.length - 1)
            Positioned(
              top: screenHeight * 0.07,
              right: screenWidth * 0.01,
              child: IconButton(
                onPressed: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ); // Passe à la page suivante
                },
                icon: const Icon(Icons.arrow_forward),
                iconSize: screenHeight * 0.04,
              ),
            ),
        ],
      ),
    );
  }

  // Widget pour construire grille choix
  Widget _buildChoiceGrid(
      BuildContext context, double screenWidth, double screenHeight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            _buildClickableImage(
              context,
              image: 'bar.png',
              onTap: () async {
                await _navigateToRandomParkour(context);
              },
            ),
            const SizedBox(height: 16),
            _buildUnavailableImage(context, 'bibliotheque.png')
          ],
        ),
        Column(
          children: [
            _buildUnavailableImage(context, 'restaurant.png'),
            const SizedBox(height: 16),
            _buildUnavailableImage(context, 'musee.png'),
          ],
        ),
      ],
    );
  }

  // Fonction pour naviguer vers parkour aléatoire
  Future<void> _navigateToRandomParkour(BuildContext context) async {
    try {
      final String? userId = await getUserId();
      if (userId == null || userId.isEmpty) {
        logger.e('User ID est null ou vide');
        return;
      }

      final RequestResult parkourIdsResult = await http_get(
          'parkour/parkoursidbar'); // Requête HTTP pour obtenir les IDs de parkour
      if (parkourIdsResult.ok) {
        final List<int> idParkours = List<int>.from(
          parkourIdsResult.data.map((item) => item['idparkour'] as int),
        );

        final Random random = Random();
        final int randomIdParkour = idParkours[random.nextInt(
            idParkours.length)]; // Sélectionne un ID de parkour aléatoire

        final RequestResult createPartyResult =
            await http_post('party/create-party', {
          'id_parkour': randomIdParkour,
          'id_user': userId,
        }); // Crée nouvelle partie

        if (createPartyResult.ok) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BarIntro1(
                randomIdParkour: randomIdParkour,
                idParty: createPartyResult.data['idparty'],
              ),
            ),
          ); // Navigue vers la page BarIntro1
        } else {
          logger.e('Fail pour création Party: ${createPartyResult.data}');
        }
      } else {
        logger.e(
            'Échec de la récupération des IDs du parkour: ${parkourIdsResult.data}');
      }
    } catch (e) {
      logger.e('Erreur pendant requête : $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur trouvé: $e')),
      ); // Affiche une notification drreur
    }
  }

  // Widget pour construire image cliquable
  Widget _buildClickableImage(BuildContext context,
      {required String image, required VoidCallback onTap}) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: onTap, // fonction à appeler lors clic
      child: Image.asset(
        'assets/images/home/homeparkour/$image',
        width: screenWidth * 0.4,
        height: screenHeight * 0.2,
      ),
    );
  }

  // Widget pour construire image non disponible
  Widget _buildUnavailableImage(BuildContext context, String image) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () =>
          _showUnavailableAlert(context), // Affiche alerte d'indisponibilité
      child: Image.asset(
        'assets/images/home/homeparkour/$image',
        width: screenWidth * 0.4,
        height: screenHeight * 0.2,
      ),
    );
  }

  // Fonction pour afficher alerte d'indisponibilité
  void _showUnavailableAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Non disponible',
              style:
                  TextStyle(fontWeight: FontWeight.w500, fontFamily: 'Outfit')),
          content: const Text(
              'Cette fonctionnalité n\'est pas encore disponible.',
              style:
                  TextStyle(fontWeight: FontWeight.w400, fontFamily: 'Outfit')),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Outfit',
                      color: Color(0xFFEB622B))),
            ),
          ],
        );
      },
    );
  }

  // Fonction pour afficher déconnexion
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmer la déconnexion',
              style:
                  TextStyle(fontWeight: FontWeight.w500, fontFamily: 'Outfit')),
          content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?',
              style:
                  TextStyle(fontWeight: FontWeight.w400, fontFamily: 'Outfit')),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Ferme
              child: const Text('Non',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Outfit',
                      color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                _clearSharedPreferences(); // Efface SP
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoginSignUpPage()),
                );
              },
              child: const Text('Oui',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Outfit',
                      color: Colors.green)),
            ),
          ],
        );
      },
    );
  }
}
