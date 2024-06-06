import 'package:flutter/material.dart';
import 'package:LemonMaze/pages/welcome/page4.dart';

class Welcome3Page extends StatelessWidget {
  const Welcome3Page({super.key});

  @override
  Widget build(BuildContext context) {
    //final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        color: const Color(0xFFFAF6D0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Image.asset(
                'assets/images/welcome/welcome-3.png',
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
                        height: MediaQuery.of(context).size.height / 2.5,
                      ),
                    ),
                    Positioned(
                      top: 16,
                      left: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Gagne de l’argent',
                              style: TextStyle(
                                  color: Color(0xFFFAF6D0),
                                  fontSize: 32,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Gustavo'),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Text(
                              'Découvre de nouveaux endroits à Rennes et trouve de nouvelles adresses qui deviendront tes favoris.',
                              style: TextStyle(
                                color: Color(0xFFFAF6D0),
                                fontFamily: 'Outfit',
                                fontSize: 19,
                                fontWeight: FontWeight.w400,
                                height: 25 / 19, // Calculer le line-height
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
                        'assets/images/welcome/index_page3.png',
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
                                builder: (context) => const Welcome4Page()),
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
