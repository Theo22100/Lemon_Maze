import 'package:flutter/material.dart';
import 'package:my_app/modules/http.dart';
import 'package:my_app/pages/boutique/citron.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();

class FinalParkourPage extends StatefulWidget {
  const FinalParkourPage({super.key});

  @override
  _FinalParkourPageState createState() => _FinalParkourPageState();
}

class _FinalParkourPageState extends State<FinalParkourPage> {
  List<String> lieux = [];
  int etat = 0;
  String? responsemsg;

  @override
  void initState() {
    super.initState();
    _addCitron(100);
  }

  //Ajout 100 citrons
  Future<void> _addCitron(int citron) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('id');

      if (userId == null || userId.isEmpty) {
        setState(() {
          responsemsg = 'Erreur: ID utilisateur non trouvé';
        });
        return;
      }

      final body = {
        'userId': userId,
        'nombre': citron,
      };
      final result = await http_put('add-citron-rouge', body);

      if (result.data['success']) {
        setState(() {
          responsemsg = "+ $citron Citrons Bar !";
        });
      } else {
        setState(() {
          responsemsg = result.data['message'];
        });
        logger.e('Erreur pour ajouter Citrons: ${result.data}');
      }
    } catch (error) {
      logger.e('Erreur pour ajouter Citrons: $error');
      setState(() {
        responsemsg = 'Erreur interne lors de la suppression des citrons';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                        color: const Color(0xFF10A488),
                        height: screenHeight / 10,
                        width: screenWidth,
                      ),
                    ),
                    Positioned(
                      bottom: screenHeight / 18,
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Image.asset(
                        'assets/images/parkour/bravo.png',
                        width: screenWidth,
                        height: screenHeight,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 20,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CitronPage(),
                            ),
                          );
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
                        bottom: screenHeight / 2.3,
                        left: 0,
                        right: 0,
                        child: Text(
                          responsemsg!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFFE9622A),
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
}
