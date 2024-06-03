import 'package:flutter/material.dart';
import 'package:LemonMaze/pages/parkour/bar/bar_intro_2.dart';
import 'package:logger/logger.dart';

import '../../../modules/http.dart';
import '../../home/home.dart';

final Logger logger = Logger();

class BarIntro1 extends StatelessWidget {
  final int randomIdParkour;
  final int idParty;

  const BarIntro1({super.key, required this.randomIdParkour, required this.idParty});

  // Function to abandon the party
  Future<void> _abandonParty(BuildContext context) async {
    try {
      final body = {};
      logger.i(idParty);
      final result = await http_put('party/abandon/$idParty', body);

      if (result.data['success']) {
        logger.i("Partie abandonnée");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
              (route) => false,
        );
      } else {
        logger.e('Erreur pour abandonner une partie');
      }
    } catch (error) {
      logger.e('Erreur interne: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtain screen dimensions for responsive design
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        return await _showExitConfirmationDialog(context) ?? false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Image.asset(
                'assets/images/welcome/wallpaper.png',
                fit: BoxFit.cover,
              ),
            ),
            // Bar image at the top and centered
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
            // Container with rounded shape at the bottom
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
                        const SizedBox(height: 20),
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
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              'assets/images/parkour/index3_1.png',
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
      ),
    );
  }

  Future<bool?> _showExitConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Êtes-vous sûr de vouloir quitter la partie ?'),
        content: const Text('Vous allez être renvoyé à l\'accueil.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Non'),
          ),
          TextButton(
            onPressed: () {
              _abandonParty(context);
            },
            child: const Text('Oui'),
          ),
        ],
      ),
    );
  }
}
