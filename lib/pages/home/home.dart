import 'dart:math';

import 'package:flutter/material.dart';
import 'package:LemonMaze/modules/http.dart';
import 'package:LemonMaze/pages/boutique/citron.dart';
import 'package:LemonMaze/pages/home/account.dart';
import 'package:LemonMaze/pages/home/inventory.dart';
import 'package:LemonMaze/pages/parkour/bar/bar_intro_1.dart';
import 'package:LemonMaze/pages/register-login/login_signup_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

//annonce list
class _HomePageState extends State<HomePage> {
  final List<String> images = [
    'assets/images/home/announce/announce1.png',
    'assets/images/home/announce/announce2.png',
    'assets/images/home/announce/announce3.png'
  ];
  //annonce
  int _currentIndex = 0;
  //fonction deconnexion
  void _clearSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    bool isFirstLogin = prefs.getBool('isFirstLogin') ?? false;
    prefs.clear();
    await prefs.setBool('isFirstLogin', isFirstLogin);
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('id');
    return userId;
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
            Container(
              color: const Color(0xFFFAF6D0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 28,
                    ),
                    Image.asset(
                      'assets/images/home/titre.png',
                      width: screenWidth * 0.4,
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    SizedBox(
                      height: 200,
                      child: Stack(
                        children: [
                          //carrousel d'annonce
                          PageView.builder(
                            itemCount: images.length,
                            controller: PageController(initialPage: 0),
                            onPageChanged: (index) {
                              setState(() {
                                _currentIndex = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              return Image.asset(
                                images[_currentIndex],
                                fit: BoxFit.fitHeight,
                              );
                            },
                          ),
                          if (_currentIndex > 0)
                            Positioned(
                              top: 70,
                              left: screenHeight * 0.02,
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _currentIndex--;
                                  });
                                },
                                icon: const Icon(Icons.arrow_back),
                              ),
                            ),
                          if (_currentIndex < images.length - 1)
                            Positioned(
                              top: 70,
                              right: screenHeight * 0.02,
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _currentIndex++;
                                  });
                                },
                                icon: const Icon(Icons.arrow_forward),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    //carré des 4 choix
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            _buildClickableImage(
                              context,
                              image: 'bar.png',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const CitronPage()),
                                );
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
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 30,
              right: 20,
              child: IconButton(
                onPressed: () {
                  _showLogoutDialog(context);
                },
                icon: const Icon(
                  Icons.logout,
                  color: Color(0xFFEB622B),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: const BottomNavigationBarWidget(),
      ),
    );
  }

  Widget _buildClickableImage(BuildContext context,
      {required String image, required VoidCallback onTap}) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () async {
        try {
          // Récupérer l'ID de l'utilisateur
          final String? userId = await getUserId();
          if (userId == null || userId.isEmpty) {
            logger.e('User ID is null or empty');
            return;
          }

          // Appeler la route pour obtenir la liste des idparkour
          final RequestResult parkourIdsResult =
              await http_get('parkour/parkoursidbar');
          if (parkourIdsResult.ok) {
            final List<int> idParkours = List<int>.from(
                parkourIdsResult.data.map((item) => item['idparkour'] as int));

            // Choisir un idparkour aléatoire
            final Random random = Random();
            final int randomIdParkour =
                idParkours[random.nextInt(idParkours.length)];
            // Appeler la route pour créer une partie
            final RequestResult createPartyResult =
                await http_post('party/create-party', {
              'id_parkour': randomIdParkour,
              'id_user': userId,
            });
            if (createPartyResult.ok) {
              // Gérer la réussite de la création de la partie
              // ignore: use_build_context_synchronously
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BarIntro1(
                    randomIdParkour: randomIdParkour,
                    idParty: createPartyResult.data['idparty'],
                  ),
                ),
              );
            } else {
              // Gérer l'échec de la création de la partie
              logger.e('Failed to create party: ${createPartyResult.data}');
            }
          } else {
            // Gérer l'échec de l'obtention des idparkour
            logger.e('Failed to fetch parkour ids: ${parkourIdsResult.data}');
          }
        } catch (e) {
          // Gérer les erreurs
          logger.e('Error while processing request: $e');
        }
      },
      child: Image.asset(
        'assets/images/home/homeparkour/$image',
        width: screenWidth * 0.4,
        height: screenHeight * 0.2,
      ),
    );
  }

  //Resto Musee Biblio
  Widget _buildUnavailableImage(BuildContext context, String image) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        _showUnavailableAlert(context);
      },
      child: Image.asset(
        'assets/images/home/homeparkour/$image',
        width: screenWidth * 0.4,
        height: screenHeight * 0.2,
      ),
    );
  }

  void _showUnavailableAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Non disponible pour le moment'),
          content:
              const Text('Cette fonctionnalité n\'est pas encore disponible.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  //Confirmation deconnexion
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmer la déconnexion'),
          content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                _clearSharedPreferences();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginSignUpPage(),
                  ),
                );
              },
              child: const Text('Déconnexion'),
            ),
          ],
        );
      },
    );
  }
}

//Bouton en bas de l'écran
class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Material(
          color:
              const Color(0xFFFAF6D0), // Set the desired background color here
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFEB622B),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            height: constraints.maxWidth * 0.18,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(
                  context,
                  icon: Icons.home,
                  label: 'Accueil',
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                ),
                _buildNavItem(
                  context,
                  icon: Icons.shopping_bag,
                  label: 'Boutique',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CitronPage()),
                    );
                  },
                ),
                _buildNavItem(
                  context,
                  icon: Icons.archive,
                  label: 'Inventaire',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const InventoryPage()),
                    );
                  },
                ),
                _buildNavItem(
                  context,
                  icon: Icons.person,
                  label: 'Profil',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AccountPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

// Creation de barre nav
  Widget _buildNavItem(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onPressed}) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, size: screenWidth * 0.08),
          onPressed: onPressed,
          color: const Color(0xFFFAF6D0),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFFAF6D0),
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            fontFamily: 'Outfit',
          ),
        ),
      ],
    );
  }
}
