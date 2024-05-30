import 'package:flutter/material.dart';
import 'package:my_app/pages/parkour/bar/bar_map.dart';

class BarIntro2 extends StatelessWidget {
  final int randomIdParkour;
  final int idParty;

  const BarIntro2(
      {super.key, required this.randomIdParkour, required this.idParty});

  @override
  Widget build(BuildContext context) {
    // Obtenir les dimensions écran responsive
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
          // Image en arrière-plan
          Positioned.fill(
            child: Image.asset(
              'assets/images/welcome/wallpaper.png',
              fit: BoxFit.cover,
            ),
          ),
          // Image bar.png en haut et alignée au centre
          Positioned(
            top: screenHeight * 0.04, // responsive
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/images/home/homeparkour/bar.png',
                width: screenWidth * 0.4, // responsive
                height: screenHeight * 0.2, // responsive
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
                        'Votre carte secrete...',
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
                          fontSize: 18,
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
                            'assets/images/parkour/index3_2.png',
                            width: 80,
                            height: 80,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BarMap(
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
    ),
    );
  }
}
