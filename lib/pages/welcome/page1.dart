import 'package:flutter/material.dart';
import 'package:LemonMaze/pages/welcome/page2.dart';

class Welcome1Page extends StatelessWidget {
  const Welcome1Page({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Welcome2Page()),
        );
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/welcome/wallpaper.png',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: screenHeight * 0.2,
                    ),
                    Image.asset(
                      'assets/images/welcome/lemonmaze.png',
                      width: screenWidth * 0.6,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                      child: const Text(
                        "Le jeu de piste à Rennes pour s'éclater avec tes amis !",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Outfit',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Image.asset(
                'assets/images/welcome/welcome-1.png',
                fit: BoxFit.cover, // Ajuster image pour couvrir largeur
                alignment:
                    Alignment.bottomCenter, // Aligner image bas de l'écran
              ),
            ),
          ],
        ),
      ),
    );
  }
}
