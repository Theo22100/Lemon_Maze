import 'package:flutter/material.dart';
import 'package:my_app/modules/http.dart';
import 'package:my_app/pages/parkour/bar/bar_map.dart';
import 'package:my_app/pages/parkour/bar/question/fin_parkour.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

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

  // Function to add citron
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
          responsemsg = "+ $citron Citrons Rouges !";
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
      logger
          .i("Result from PUT request: ${result.ok} with data: ${result.data}");

      setState(() {
        if (result.ok) {
          if (result.data['success']) {
            etat = result.data['new_etat'];
            if (etat == 4) {
              logger.i('etat $etat');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FinalParkourPage(
                      /*randomIdParkour: widget.randomIdParkour,
                    idParty: widget.idParty,*/
                      ),
                ),
              );
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

    return Scaffold(
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
                        bottom: screenHeight / 2.03,
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
    );
  }
}
