import 'package:flutter/material.dart';
import 'package:LemonMaze/pages/parkour/bar/question/enigme2_page.dart';

import '../../../../modules/http.dart';
import '../../../home/home.dart';
import 'package:logger/logger.dart';
final Logger logger = Logger();

class BadAnswerPage extends StatelessWidget {
  final int randomIdParkour;
  final int idParty;

  const BadAnswerPage(
      {super.key, required this.randomIdParkour, required this.idParty});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    // Fonction pour abandonner la partie
    Future<void> _abandonParty(BuildContext context) async {
      try {
        final body = {};
        final result = await http_put('party/abandon/$idParty', body);

        if (result.data['success']) {
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

    return WillPopScope(
      onWillPop: () async {
        return await _showExitConfirmationDialog(context) ?? false;
      },
      child: Scaffold(
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
      ),
    );
  }
  Future<void> _abandonParty(BuildContext context) async {
    try {
      final body = {};
      final result = await http_put('party/abandon/$idParty', body);

      if (result.data['success']) {
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
