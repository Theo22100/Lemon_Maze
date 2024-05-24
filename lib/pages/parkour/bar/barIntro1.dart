import 'package:flutter/material.dart';
import 'package:my_app/pages/parkour/bar/barIntro2.dart';

class BarIntro1 extends StatelessWidget {
  final int randomIdParkour;

  const BarIntro1({super.key, required this.randomIdParkour});

  @override
  Widget build(BuildContext context) {
    // Obtenir les dimensions de l'écran
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Image en arrière-plan
          Positioned.fill(
            child: Image.asset(
              '../../../assets/images/welcome/wallpaper.png',
              fit: BoxFit.cover,
            ),
          ),
          // Image bar.png en haut et alignée au centre
          Positioned(
            top: screenHeight *
                0.04, // Ajustez la position verticale selon vos besoins
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                '../../../assets/images/home/homeparkour/bar.png',
                width: screenWidth *
                    0.4, // Ajustez la largeur proportionnelle à l'écran
                height: screenHeight *
                    0.2, // Ajustez la hauteur proportionnelle à l'écran
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
                        'Bienvenue à toi, jeune aventurier !',
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
                      const SizedBox(
                          height: 16), // Espacement entre les deux textes
                      const Text(
                        "Bienvenue à Rennes, une ville où chaque rue murmure des histoires anciennes et des mystères cachés. Vous incarnez une équipe d'explorateurs intrépides, recrutés par une mystérieuse organisation secrète de citrons appelée <<Les Gardiens de l'Histoire>>. \n\nVotre mission : percer les secrets les mieux gardés de Rennes et protéger son patrimoine culturel.",
                        style: TextStyle(
                          color: Color(0xFFEB622B),
                          fontFamily: 'Outfit',
                          fontSize: 19,
                          fontWeight: FontWeight.w400,
                          height: 25 / 19, // Calculer le line-height
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            '../../../assets/images/parkour/index_3.png',
                            width: 80,
                            height: 80,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BarIntro2(
                                      randomIdParkour: randomIdParkour),
                                ),
                              );
                            },
                            child: Image.asset(
                              '../../../assets/images/parkour/button.png',
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