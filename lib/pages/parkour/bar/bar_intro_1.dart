import 'package:flutter/material.dart';
import 'package:my_app/pages/parkour/bar/bar_intro_2.dart';

class BarIntro1 extends StatelessWidget {
  final int randomIdParkour;
  final int idParty;

  const BarIntro1(
      {super.key, required this.randomIdParkour, required this.idParty});

  @override
  Widget build(BuildContext context) {
    // Obtenir dimensions écran pour responsive
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Image arrière-plan
          Positioned.fill(
            child: Image.asset(
              'assets/images/welcome/wallpaper.png',
              fit: BoxFit.cover,
            ),
          ),
          // Image bar.png en haut et alignée au centre
          Positioned(
            top: screenHeight * 0.04,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/images/home/homeparkour/bar.png',
                width: screenWidth * 0.4,
                height: screenHeight * 0.2, //responsive
                fit: BoxFit.contain,
              ),
            ),
          ),
          // Conteneur avec couleur et forme arrondie en bas
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              child: Container(
                color: const Color(0xFFFAF6D0),
                height: screenHeight / 1.35,
                width: screenWidth,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20), // Espace pour l'image
                      const Text(
                        'Bienvenue a toi, jeune aventurier !',
                        style: TextStyle(
                          color: Color(0xFFEB622B),
                          fontSize: 34,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Gustavo',
                          height: 1.5,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Bienvenue à Rennes, une ville où chaque rue murmure des histoires anciennes et des mystères cachés. Vous incarnez une équipe d'explorateurs intrépides, recrutés par une mystérieuse organisation secrète de citrons appelée <<Les Gardiens de l'Histoire>>. \n\nVotre mission : percer les secrets les mieux gardés de Rennes et protéger son patrimoine culturel.",
                        style: TextStyle(
                          color: Color(0xFFEB622B),
                          fontFamily: 'Outfit',
                          fontSize: 19,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            'assets/images/parkour/index_3.png',
                            width: 80,
                            height: 80,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BarIntro2(
                                    randomIdParkour: randomIdParkour,
                                    idParty: idParty,
                                  ),
                                ),
                              );
                            },
                            child: Image.asset(
                              'assets/images/parkour/button.png',
                              width: 50,
                              height: 50,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
