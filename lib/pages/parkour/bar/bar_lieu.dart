import 'package:flutter/material.dart';
import 'package:LemonMaze/modules/http.dart';
import 'package:LemonMaze/pages/parkour/bar/bar_arrive.dart';
import 'package:LemonMaze/pages/parkour/bar/bar_map.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:logger/logger.dart';

import '../../home/home.dart';

final Logger logger = Logger();

class BarLieu extends StatefulWidget {
  final int randomIdParkour;
  final int idParty;

  const BarLieu({
    super.key,
    required this.randomIdParkour,
    required this.idParty,
  });

  @override
  _BarLieuState createState() => _BarLieuState();
}

class _BarLieuState extends State<BarLieu> {
  List<String> lieux = [];
  List<String> gps = [];
  int etat = 0;

  @override
  void initState() {
    super.initState();
    fetchLieux();
    getEtatParty();
  }


  // Affiche le bon lieu
  Future<void> fetchLieux() async {
    try {
      var result = await http_get(
          "parkour/getparkour/nomsgpslieu/${widget.randomIdParkour}");
      if (result.ok) {
        var data = result.data['data'];
        if (data != null) {
          var lieuxData = data['lieux'];
          if (lieuxData != null) {
            List<String> noms = [];
            List<String> gpsCoords = [];

            for (var lieu in lieuxData) {
              noms.add(lieu['nom']);
              gpsCoords.add(lieu['gps']);
            }

            setState(() {
              lieux = noms;
              gps = gpsCoords;
            });
          } else {
            logger.e("Les données 'lieux' ou 'gps' sont nulles");
          }
        } else {
          logger.e("La réponse 'data' est nulle");
        }
      } else {
        logger.e("Échec de la récupération des données du parcours");
      }
    } catch (error) {
      logger.e("Erreur lors de l'appel HTTP : $error");
    }
  }

  Future<void> getEtatParty() async {
    try {
      var result = await http_get("party/getpartyetat/${widget.idParty}");
      if (result.ok) {
        var data = result.data['data'];
        if (data != null && data['etat'] != null) {
          setState(() {
            etat = data['etat'];
          });
        } else {
          logger.e("clé 'etat' est null");
        }
      } else {
        logger.e("Échec extraction des données relatives au parcours");
      }
    } catch (error) {
      logger.e("Erreur lors de l'appel HTTP : $error");
    }
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Ne peut pas lancer $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    String lieu = 'Erreur';
    String onegps = '';

    if (lieux.isNotEmpty && gps.isNotEmpty) {
      int index = etat;
      if (index >= 0 && index < lieux.length) {
        lieu = lieux[index];
        onegps = gps[index];
      }
    }

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height; //responsive

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
              top: screenHeight * 0.02,
              left: 32,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BarMap(
                        randomIdParkour: widget.randomIdParkour,
                        idParty: widget.idParty,
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
                    child: lieux.isEmpty || gps.isEmpty
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFFEB622B),
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Que l'aventure commence !",
                                style: TextStyle(
                                  color: Color(0xFFEB622B),
                                  fontSize: 30,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Gustavo',
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 14),
                              const Text(
                                "Rendez vous :",
                                style: TextStyle(
                                  color: Color(0xFFEB622B),
                                  fontFamily: 'Outfit',
                                  fontSize: 19,
                                  fontWeight: FontWeight.w400,
                                  height: 25 / 19,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      lieu,
                                      style: const TextStyle(
                                        color: Color(0xFFEB622B),
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Outfit',
                                        height: 1.5,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => _launchURL(onegps),
                                    child: const Icon(
                                      Icons.location_on,
                                      color: Color(0xFFFBBA2C),
                                      size: 48.0,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              const Text(
                                "Préparez-vous à vivre une expérience mémorable dans l'un des établissements les plus appréciés de la ville. \n\nQue la soirée commence !",
                                style: TextStyle(
                                  color: Color(0xFFEB622B),
                                  fontFamily: 'Outfit',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.asset(
                                    'assets/images/parkour/index3_3.png',
                                    width: 80,
                                    height: 80,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BarArrive(
                                            randomIdParkour:
                                                widget.randomIdParkour,
                                            idParty: widget.idParty,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Image.asset(
                                      'assets/images/parkour/button.png',
                                      width: screenWidth * 0.2,
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
