import 'package:flutter/material.dart';
import 'package:LemonMaze/pages/parkour/bar/bar_map.dart';
import '../../../modules/http.dart';
import '../../home/home.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();

class BarIntro2 extends StatelessWidget {
  final int randomIdParkour;
  final int idParty;

  const BarIntro2({
    super.key,
    required this.randomIdParkour,
    required this.idParty
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;



    return WillPopScope(
      onWillPop: () async {
        return await _showExitConfirmationDialog(context) ?? false;
      },
      child: Scaffold(
        body: Stack(
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
                        const SizedBox(height: 16),
                        const Text(
                          'Avec notre itinéraire soigneusement sélectionné, vous aurez l\'occasion de déguster des boissons locales, de rencontrer des habitants et de vous immerger dans la culture nocturne rennaise.',
                          style: TextStyle(
                            color: Color(0xFFEB622B),
                            fontFamily: 'Outfit',
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            height: 1.32,
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
