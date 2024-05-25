import 'package:flutter/material.dart';

class EnigmePage2 extends StatefulWidget {
  final int randomIdParkour;
  final int idParty;

  const EnigmePage2(
      {super.key, required this.randomIdParkour, required this.idParty});

  @override
  _EnigmePage2State createState() => _EnigmePage2State();
}

class _EnigmePage2State extends State<EnigmePage2> {
  int etat = 0;
  @override
  void initState() {
    super.initState();
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

          // Conteneur orange avec zone jaune en bas
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              child: Container(
                color: const Color(0xFFEB622B),
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
                        color: const Color(0xFFECE450),
                        height: (screenHeight / 1.35) / 4,
                        width: screenWidth,
                      ),
                    ),

                    // Image enigme.png chevauchant la zone orange
                    Positioned(
                      bottom: screenHeight / 8,
                      top: 0,
                      child: Image.asset(
                        'assets/images/parkour/enigme.png',
                        width:
                            screenWidth, // Ajuster la largeur de l'image selon les besoins
                        height:
                            screenHeight, // Ajuster la hauteur de l'image selon les besoins
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
                              builder: (context) => EnigmePage2(
                                randomIdParkour: widget.randomIdParkour,
                                idParty: widget.idParty,
                              ),
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
