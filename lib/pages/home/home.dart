import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_app/modules/http.dart';
import 'package:my_app/pages/boutique/citron.dart';
import 'package:my_app/pages/home/account.dart';
import 'package:my_app/pages/home/inventory.dart';
import 'package:my_app/pages/parkour/bar/bar_intro_1.dart';
import 'package:my_app/pages/register-login/login_signup_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> images = [
    'assets/images/home/announce/announce1.png',
    'assets/images/home/announce/announce2.png',
    'assets/images/home/announce/announce3.png'
  ];

  int _currentIndex = 0;

  void _clearSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    width: MediaQuery.of(context).size.width * 0.4,
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  SizedBox(
                    height: 200,
                    child: Stack(
                      children: [
                        PageView.builder(
                          itemCount: images.length,
                          controller: PageController(initialPage: 0),
                          onPageChanged: (index) {
                            setState(() {
                              _currentIndex = index;
                              logger.i(_currentIndex);
                            });
                          },
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Image.asset(
                                images[_currentIndex],
                                fit: BoxFit.fitHeight,
                              ),
                            );
                          },
                        ),
                        if (_currentIndex > 0)
                          Positioned(
                            top: 70,
                            left: 0,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  _currentIndex--;
                                  logger.i(_currentIndex);
                                });
                              },
                              icon: const Icon(Icons.arrow_back),
                            ),
                          ),
                        if (_currentIndex < images.length - 1)
                          Positioned(
                            top: 70,
                            right: 0,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  _currentIndex++;
                                  logger.i(_currentIndex);
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
    );
  }

  Widget _buildClickableImage(BuildContext context,
      {required String image, required VoidCallback onTap}) {
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
            logger.i('randomidparkour $randomIdParkour');
            // Appeler la route pour créer une partie
            final RequestResult createPartyResult =
                await http_post('party/create-party', {
              'id_parkour': randomIdParkour,
              'id_user': userId,
            });
            logger.i("createParty ${createPartyResult.data['idparty']}");
            if (createPartyResult.ok) {
              // Gérer la réussite de la création de la partie
              logger.i('Party created: ${createPartyResult.data}');
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
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.height * 0.2,
      ),
    );
  }

// Vous devez implémenter la fonction getUserId() pour récupérer l'ID de l'utilisateur
  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('id');

    // Retourner userId ou null en fonction de sa présence dans les préférences partagées
    return userId;
  }

  Widget _buildUnavailableImage(BuildContext context, String image) {
    return GestureDetector(
      onTap: () {
        _showUnavailableAlert(context);
      },
      child: Image.asset(
        'assets/images/home/homeparkour/$image',
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.height * 0.2,
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

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
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
                    MaterialPageRoute(builder: (context) => const CitronPage()),
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
        );
      },
    );
  }

  Widget _buildNavItem(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onPressed}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, size: MediaQuery.of(context).size.width * 0.08),
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
