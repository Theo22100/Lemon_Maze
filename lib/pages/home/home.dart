import 'package:flutter/material.dart';
import 'package:my_app/pages/home/account.dart';
import 'package:my_app/pages/register-login/loginSignupPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> images = [
    '../../assets/images/home/announce/announce1.png',
    '../../assets/images/home/announce/announce1.png',
    '../../assets/images/home/announce/announce1.png'
  ];

  int _currentIndex = 0;

  void _clearSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear(); // Supprimer toutes les données des SharedPreferences
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
                    '../../assets/images/home/titre.png',
                    width: MediaQuery.of(context).size.width * 0.4,
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Container(
                    height: 200, // Hauteur de votre swiper
                    child: Stack(
                      children: [
                        PageView.builder(
                          itemCount: images.length,
                          controller: PageController(initialPage: 0),
                          onPageChanged: (index) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0), // Ajout du padding
                              child: Image.asset(
                                images[index],
                                fit: BoxFit
                                    .fitHeight, // Ajustez la taille de l'image ici
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
                                });
                              },
                              icon: Icon(Icons.arrow_back),
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
                                });
                              },
                              icon: const Icon(Icons.arrow_forward),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Utilisez le pseudo récupéré dans votre interface utilisateur
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
  const BottomNavigationBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double iconSize =
            constraints.maxWidth * 0.16; // Ajustez le facteur selon vos besoins

        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFEB622B),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          height: constraints.maxWidth * 0.28,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                icon: Image.asset(
                  '../../assets/images/home/accueil.png',
                  height: iconSize,
                  width: iconSize,
                ),
              ),
              IconButton(
                onPressed: () {
                  // Action pour la boutique
                },
                icon: Image.asset(
                  '../../assets/images/home/boutique.png',
                  height: iconSize,
                  width: iconSize,
                ),
              ),
              IconButton(
                onPressed: () {
                  // Action pour les notifications
                },
                icon: Image.asset(
                  '../../assets/images/home/notifications.png',
                  height: iconSize * 1.22,
                  width: iconSize * 1.22,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AccountPage()),
                  );
                },
                icon: Image.asset(
                  '../../assets/images/home/profil.png',
                  height: iconSize,
                  width: iconSize,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
