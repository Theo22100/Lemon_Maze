import 'package:flutter/material.dart';
import 'package:my_app/pages/parkour/bar/barMap.dart';

class BarIntro2 extends StatelessWidget {
  final int randomIdParkour;

  const BarIntro2({super.key, required this.randomIdParkour});

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
                        'Votre carte secrète...',
                        style: TextStyle(
                          color: Color(0xFFEB622B),
                          fontSize: 40,
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
                        'Avec notre itinéraire soigneusement sélectionné, vous aurez l'
                        'occasion de déguster des boissons locales, de rencontrer des habitants et de vous immerger dans la culture nocturne rennaise. ',
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
                                  builder: (context) =>
                                      BarMap(randomIdParkour: randomIdParkour),
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
