import 'package:flutter/material.dart';
import 'package:my_app/pages/parkour/bar/bar_lieu.dart';
import 'package:my_app/pages/parkour/bar/bar_code.dart';

class BarArrive extends StatelessWidget {
  final int randomIdParkour;
  final int idParty;

  const BarArrive(
      {super.key, required this.randomIdParkour, required this.idParty});

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
              'assets/images/welcome/wallpaper.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: screenHeight * 0.02,
            left: 32,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BarLieu(
                      randomIdParkour: randomIdParkour,
                      idParty: idParty,
                    ),
                  ),
                );
              },
              child: Image.asset(
                'assets/images/parkour/backmap.png',
                width: screenWidth * 0.15,
                height: screenHeight * 0.05,
              ),
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
                        'A la recherche du code cache...',
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
                        "Vous voilà arrivés ! \n\nVotre mission, si vous l'acceptez, consiste à localiser le code soigneusement dissimulé dans l'établissement. N'oubliez pas que ce code est la clé pour résoudre les énigmes et accumuler des points. \n\nBonne chance et que l'aventure continue !",
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
                      Center(
                        // Centrer horizontalement le bouton
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CodePage(
                                  randomIdParkour: randomIdParkour,
                                  idParty: idParty,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFBBA2C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 24),
                            child: Text(
                              "J’ai trouvé où il se cache :)",
                              style: TextStyle(
                                color: Colors.white, // Couleur du texte
                                fontFamily: 'Outfit',
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ),
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
