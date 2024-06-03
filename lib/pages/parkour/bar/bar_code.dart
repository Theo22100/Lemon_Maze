import 'package:flutter/material.dart';
import 'package:LemonMaze/modules/http.dart';
import 'package:LemonMaze/pages/parkour/bar/bar_arrive.dart';
import 'package:LemonMaze/pages/parkour/bar/question/enigme1_page.dart';
import 'package:logger/logger.dart';

import '../../home/home.dart';

final Logger logger = Logger();

class CodePage extends StatefulWidget {
  final int randomIdParkour;
  final int idParty;

  const CodePage(
      {super.key, required this.randomIdParkour, required this.idParty});

  @override
  _CodePageState createState() => _CodePageState();
}

class _CodePageState extends State<CodePage> {
  List<String> code = ["", "", "", ""]; // code en haut
  int currentIndex = 0; // Index actuel pour code
  int etat = 0;
  int bonCode = 0;
  String lieu = '';

  @override
  void initState() {
    super.initState();
    getCodeEtat();
  }



  //Ajout chiffre dans le code
  void addDigit(String digit) {
    setState(() {
      if (currentIndex < 4) {
        code[currentIndex] = digit;
        currentIndex++;
      }
    });
  }

  //Supprimer avec la barre dans le code
  void removeDigit() {
    setState(() {
      if (currentIndex > 0) {
        currentIndex--;
        code[currentIndex] = "";
      }
    });
  }

  Future<void> getCodeEtat() async {
    try {
      var result = await http_get("party/getcodewithetat/${widget.idParty}");
      if (result.ok) {
        var data = result.data['data'];
        if (data != null) {
          setState(() {
            etat = data['etat'];
            bonCode = data['code'];
            logger.i('bon code $bonCode');
          });
        } else {
          logger.e("La réponse 'data' ou la clé 'etat' est nulle");
        }
      } else {
        logger.e("Échec de la récupération des données de la partie");
      }
    } catch (error) {
      logger.e("Erreur lors de l'appel HTTP : $error");
    }
  }

  //Fonction pour savoir si bon code
  void checkCode() {
    String enteredCode = code.join();
    if (enteredCode == bonCode.toString()) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EnigmePage1(
                randomIdParkour: widget.randomIdParkour,
                idParty: widget.idParty)),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Mauvais Code"),
            content: const Text("Le code que vous avez entré est incorrect."),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
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
            Positioned(
              top: screenHeight * 0.02,
              left: 32,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BarArrive(
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
            // Conteneur beige
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
                      children: [
                        const Text(
                          "Récupérez votre code",
                          style: TextStyle(
                            color: Color(0xFFEB622B),
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Outfit',
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Center(
                          child: Text(
                            "Félicitations pour avoir déniché le code secret de l'établissement !\nVeuillez le saisir :)",
                            style: TextStyle(
                              color: Color(0xFFEB622B),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Outfit',
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(4, (index) {
                            return Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFBBA2C),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                code[index],
                                style: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 5),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenHeight /
                                  11), // Padding pour taille bouton
                          child: GridView.count(
                            crossAxisCount: 3,
                            shrinkWrap: true,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20,
                            childAspectRatio: 1, //forme carré
                            children: [
                              for (int i = 1; i <= 9; i++)
                                _buildDigitButton(i.toString(), 60.0, 60.0),
                              const SizedBox.shrink(),
                              _buildDigitButton('0', 60.0, 60.0),
                              ElevatedButton(
                                onPressed: removeDigit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFBBA2C),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  fixedSize: const Size(60, 60),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.backspace,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: checkCode,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEB622B),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 16.0,
                              horizontal: 32.0,
                            ),
                          ),
                          child: const Text(
                            "Envoyer",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
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

  Widget _buildDigitButton(String digit, double width, double height) {
    return DigitButton(
      digit: digit,
      onPressed: () => addDigit(digit),
    );
  }
}

//bouton code
class DigitButton extends StatefulWidget {
  final String digit;
  final VoidCallback onPressed;

  const DigitButton({
    super.key,
    required this.digit,
    required this.onPressed,
  });

  @override
  _DigitButtonState createState() => _DigitButtonState();
}

class _DigitButtonState extends State<DigitButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          isPressed = false;
        });
        widget.onPressed();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        decoration: BoxDecoration(
          color: isPressed ? const Color(0xFFEB622B) : const Color(0xFFFBBA2C),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            widget.digit,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ),
    );
  }
}
