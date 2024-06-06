import 'package:flutter/material.dart';
import 'package:LemonMaze/pages/parkour/bar/bar_intro_2.dart';

import '../dialog_abandon.dart';

class BarIntro1 extends StatelessWidget {
  final int randomIdParkour;
  final int idParty;

  const BarIntro1(
      {super.key, required this.randomIdParkour, required this.idParty});

  @override
  Widget build(BuildContext context) {
    // Obtain screen dimensions for responsive design
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return PopScope(
      onPopInvoked: (popIntent) async {
        final exitConfirmed =
            await showExitConfirmationDialog(context, idParty);
        if (exitConfirmed ?? false) {
          Navigator.of(context).pop(true);
        }
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
                    padding: const EdgeInsets.all(24),
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
                            fontSize: 16,
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
                              height: screenHeight * 0.01,
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
                                height: screenHeight * 0.06,
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
