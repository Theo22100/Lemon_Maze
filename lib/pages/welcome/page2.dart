import 'package:flutter/material.dart';
import 'package:LemonMaze/pages/welcome/page3.dart';

class Welcome2Page extends StatelessWidget {
  const Welcome2Page({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        color: const Color(0xFFFAF6D0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 20), // Espace supplémentaire en haut
              child: Image.asset(
                'assets/images/welcome/welcome-2.png',
                width: double.infinity, // Prend toute la largeur
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      child: Image.asset(
                        'assets/images/welcome/wallpaper.png',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: screenHeight / 2.5,
                      ),
                    ),
                    Positioned(
                      top: 16,
                      left: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Amuse-toi avec tes amis',
                              style: TextStyle(
                                  color: Color(0xFFFAF6D0),
                                  fontSize: 32,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Gustavo'),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: screenHeight * 0.02,
                            ), // Espacement entre les deux textes
                            const Text(
                              'Rejoins des jeux de piste exclusifs pour passer du bon temps avec tous tes amis.',
                              style: TextStyle(
                                color: Color(0xFFFAF6D0),
                                fontFamily: 'Inter',
                                fontSize: 19,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: screenHeight * 0.03,
                      left: 16,
                      child: Image.asset(
                        'assets/images/welcome/index_page2.png',
                        height: screenHeight * 0.01,
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 16,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Welcome3Page()),
                          );
                        },
                        child: Image.asset(
                          'assets/images/welcome/circle_arrow.png',
                          height: screenHeight * 0.06,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
