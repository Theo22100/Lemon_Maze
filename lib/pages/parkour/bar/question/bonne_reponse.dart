import 'package:flutter/material.dart';
import 'package:LemonMaze/modules/http.dart';
import 'package:LemonMaze/pages/parkour/bar/bar_map.dart';
import 'package:LemonMaze/pages/parkour/bar/question/fin_parkour.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

import '../../../home/home.dart';

// Initialize the logger
final Logger logger = Logger();

class GoodAnswerPage extends StatefulWidget {
  final int randomIdParkour;
  final int idParty;

  const GoodAnswerPage(
      {super.key, required this.randomIdParkour, required this.idParty});

  @override
  _GoodAnswerPageState createState() => _GoodAnswerPageState();
}

class _GoodAnswerPageState extends State<GoodAnswerPage> {
  String? responsemsg;
  int etat = 0;

  @override
  void initState() {
    super.initState();
    _addCitron(10);
  }

  // Fonction pour ajouter citron
  Future<void> _addCitron(int citron) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('id');

      if (userId == null || userId.isEmpty) {
        logger.e('User ID is null or empty');
        setState(() {
          responsemsg = 'Erreur: ID utilisateur non trouvé';
        });
        return;
      }

      final body = {'userId': userId, 'nombre': citron};
      final result = await http_put('add-citron-rouge', body);

      setState(() {
        if (result.data['success']) {
          responsemsg = "+ $citron Citrons Bar !";
        } else {
          responsemsg = result.data['message'];
          logger.e('Failed to add citron(s): ${result.data}');
        }
      });
    } catch (error) {
      logger.e('Error adding citron(s): $error');
      setState(() {
        responsemsg = 'Erreur interne lors de l\'ajout des citrons';
      });
    }
  }

  // Function to add etat
  Future<void> addEtat() async {
    try {
      String idParty = widget.idParty.toString();

      if (idParty.isEmpty || int.tryParse(idParty) == null) {
        throw Exception("ID de la partie invalide");
      }

      String url = 'party/add-etat/$idParty';
      final result = await http_put(url);

      setState(() {
        if (result.ok) {
          if (result.data['success']) {
            etat = result.data['new_etat'];
            if (etat == 4) {
              _finParty(context);
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BarMap(
                    randomIdParkour: widget.randomIdParkour,
                    idParty: widget.idParty,
                  ),
                ),
              );
            }
          } else {
            etat = 0;
            logger.e('Erreur ajout etat: ${result.data['message']}');
          }
        } else {
          etat = 0;
          logger.e('Erreur HTTP: ${result.data}');
        }
      });
    } catch (error) {
      logger.e('Erreur ajout etat : $error');
      setState(() {
        responsemsg = 'Erreur interne lors de l\'ajout etat';
      });
    }
  }

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
                  color: const Color(0xFFADD18C),
                  height: screenHeight / 1.35,
                  width: screenWidth,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          color: const Color(0xFFEDE54F),
                          height: screenHeight / 10,
                          width: screenWidth,
                        ),
                      ),
                      Positioned(
                        bottom: screenHeight / 18,
                        top: 0,
                        child: Image.asset(
                          'assets/images/parkour/bonnereponse.png',
                          width: screenWidth,
                          height: screenHeight,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 20,
                        child: GestureDetector(
                          onTap: () {
                            addEtat();
                          },
                          child: Image.asset(
                            'assets/images/parkour/button.png',
                            width: screenWidth / 8,
                            height: screenHeight / 8,
                          ),
                        ),
                      ),
                      if (responsemsg != null)
                        Positioned(
                          bottom: screenHeight / 2.05,
                          left: 0,
                          right: 0,
                          child: Text(
                            responsemsg!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF13A388),
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Outfit',
                            ),
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

  Future<void> _abandonParty(BuildContext context) async {
    try {
      final body = {};
      final result = await http_put('party/abandon/${widget.idParty}', body);

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

  Future<void> _finParty(BuildContext context) async {
    try {
      final body = {};
      final result = await http_put('party/fin-party/${widget.idParty}', body);

      if (result.data['success']) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FinalParkourPage(
                /*randomIdParkour: widget.randomIdParkour,
                    idParty: widget.idParty,*/
                ), //TODOV2 AJOUTER INFO PARCOURS
          ),
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
        title: const Text('Êtes-vous sûr de vouloir quitter la partie ?', style: TextStyle(
          fontWeight: FontWeight.w500,
          fontFamily: 'Outfit',
        )),
        content: const Text('Vous allez être renvoyé à l\'accueil.', style: TextStyle(
          fontWeight: FontWeight.w400,
          fontFamily: 'Outfit',
        )),
        actions: <Widget>[

          TextButton(
            onPressed: () {
              _abandonParty(context);
            },
            child: const Text('Oui', style: TextStyle(
              color: Colors.green,
              fontSize: 18,
              fontWeight: FontWeight.w400,
              fontFamily: 'Outfit',
            )),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Non', style: TextStyle(
              color: Colors.red,
              fontSize: 18,
              fontWeight: FontWeight.w400,
              fontFamily: 'Outfit',
            )),
          ),
        ],
      ),
    );
  }
}
