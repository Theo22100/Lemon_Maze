import 'package:flutter/material.dart';
import 'package:my_app/pages/parkour/bar/question/enigme2_page.dart';

class BadAnswerPage extends StatelessWidget {
  final int randomIdParkour;
  final int idParty;

  const BadAnswerPage(
      {super.key, required this.randomIdParkour, required this.idParty});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EnigmePage2(
                  randomIdParkour: randomIdParkour, idParty: idParty),
            ),
          );
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/welcome/wallpaper.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: screenHeight * 0.04,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset(
                  'assets/images/home/homeparkour/bar.png',
                  width: screenWidth * 0.4,
                  height: screenHeight * 0.2,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Conteneur orange avec zone jaune en bas
            Align(
              alignment: Alignment.bottomCenter,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: Container(
                  color: const Color(0xFFEA622B),
                  height: screenHeight / 1.35,
                  width: screenWidth,
                  child: Stack(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Column(
                          children: [],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          color: const Color(0xFFADD18C),
                          height: (screenHeight) / 10,
                          width: screenWidth,
                        ),
                      ),

                      // Image mauvaise rep
                      Positioned(
                        bottom: screenHeight / 18,
                        top: 0,
                        child: Image.asset(
                          'assets/images/parkour/mauvaisereponse.png',
                          width: screenWidth,
                          height: screenHeight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
