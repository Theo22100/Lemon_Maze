import 'package:flutter/material.dart';
import 'package:LemonMaze/modules/http.dart';
import 'package:logger/logger.dart';
import 'package:LemonMaze/pages/parkour/bar/question/bonne_reponse.dart';
import 'package:LemonMaze/pages/parkour/bar/question/mauvaise_reponse.dart';

import '../../../home/home.dart';

final Logger logger = Logger();

class EnigmePage2 extends StatefulWidget {
  final int randomIdParkour;
  final int idParty;

  const EnigmePage2({
    super.key,
    required this.randomIdParkour,
    required this.idParty,
  });

  @override
  _EnigmePage2State createState() => _EnigmePage2State();
}

class _EnigmePage2State extends State<EnigmePage2> {
  int etat = 0;
  int currentGoodAnswer = 0;
  List<dynamic> questions = [];
  Map<String, dynamic>? currentQuestion;
  bool buttonsDisabled = false;
  int selectedAnswer = -1;

  // préparation de la page
  @override
  void initState() {
    super.initState();
    getEtatParty();
    getQuestion();
  }

  // récupération de la question+réponse
  Future<void> getQuestion() async {
    try {
      var result = await http_get("partyquestion/${widget.idParty}");
      if (result.ok) {
        var data = result.data['data'];
        if (data != null && data is List) {
          setState(() {
            questions = data;
            if (etat >= 0 && etat < questions.length) {
              currentQuestion = questions[etat];
            }
          });
        } else {
          logger.e("La réponse 'data' ou la clé 'questions' est nulle");
        }
      } else {
        logger.e("Échec extraction des données relatives aux questions");
      }
    } catch (error) {
      logger.e("Error fetching questions: $error");
    }
  }

  // récupération de l'état de la partie
  Future<void> getEtatParty() async {
    try {
      var result = await http_get("party/getpartyetat/${widget.idParty}");
      if (result.ok) {
        var data = result.data['data'];
        if (data != null && data['etat'] != null) {
          setState(() {
            etat = data['etat'];
            if (questions.isNotEmpty && etat >= 0) {
              currentQuestion = questions[etat];
            }
          });
        } else {
          logger.e("La réponse 'data' ou la clé 'etat' est nulle");
        }
      } else {
        logger.e("Échec extraction des données relatives à l'état");
      }
    } catch (error) {
      logger.e("Error fetching party state: $error");
    }
  }

  // gestion de la réponse
  void handleAnswer(int answerIndex) {
    if (buttonsDisabled) return;

    setState(() {
      buttonsDisabled = true;
      selectedAnswer = answerIndex;
    });

    // Délai pour montrer la réponse
    Future.delayed(const Duration(seconds: 1), () {
      if (selectedAnswer == currentQuestion!['bonnereponse']) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => GoodAnswerPage(
                    randomIdParkour: widget.randomIdParkour,
                    idParty: widget.idParty,
                  )),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BadAnswerPage(
                    randomIdParkour: widget.randomIdParkour,
                    idParty: widget.idParty,
                  )),
        );
      }
    });
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
                  color: const Color(0xFFFAF6D0),
                  height: screenHeight / 1.35,
                  width: screenWidth,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 5),
                        const Text(
                          'Trouve la bonne reponse !',
                          style: TextStyle(
                            color: Color(0xFFEB622B),
                            fontSize: 28,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Gustavo',
                            height: 1.5,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Center(
                          child: currentQuestion == null
                              ? const CircularProgressIndicator(
                                  color: Color(0xFFEB622B),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      currentQuestion!['question'],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Outfit',
                                          color: Color(0xFFEB622B)),
                                    ),
                                    const SizedBox(height: 30),
                                    ...List.generate(4, (index) {
                                      String answerKey = 'reponse${index + 1}';
                                      Color buttonColor =
                                          const Color(0xFFFBBA2C);
                                      if (buttonsDisabled) {
                                        if (selectedAnswer == index + 1) {
                                          buttonColor = (selectedAnswer ==
                                                  currentQuestion![
                                                      'bonnereponse'])
                                              ? const Color(0xFF17A489)
                                              : const Color(0xFFEB622B);
                                        }
                                      }
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 12.0),
                                        child: Center(
                                          child: ElevatedButton(
                                            onPressed: buttonsDisabled
                                                ? null
                                                : () => handleAnswer(index + 1),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: buttonColor,
                                              minimumSize: const Size(
                                                  double.infinity, 50),
                                            ),
                                            child: Text(
                                              currentQuestion![answerKey],
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w300,
                                                  fontFamily: 'Outfit',
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ],
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
