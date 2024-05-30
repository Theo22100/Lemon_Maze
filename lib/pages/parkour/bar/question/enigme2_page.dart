import 'package:flutter/material.dart';
import 'package:my_app/modules/http.dart';
import 'package:my_app/pages/parkour/bar/bar_intro_2.dart';
import 'package:logger/logger.dart';
import 'package:my_app/pages/parkour/bar/question/bonne_reponse.dart';
import 'package:my_app/pages/parkour/bar/question/mauvaise_reponse.dart';

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
//preparation page
  @override
  void initState() {
    super.initState();
    getEtatParty();
    getQuestion();
  }

  //recuperation de la question+reponse
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
          logger.e("The response data or 'questions' key is null");
        }
      } else {
        logger.e("Failed to fetch questions data");
      }
    } catch (error) {
      logger.e("Error fetching questions: $error");
    }
  }

  //recuperation etat
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
          logger.e("The response data or 'etat' key is null");
        }
      } else {
        logger.e("Failed to fetch party state data");
      }
    } catch (error) {
      logger.e("Error fetching party state: $error");
    }
  }

  //recuperation reponse
  void handleAnswer(int answerIndex) {
    if (buttonsDisabled) return;

    setState(() {
      buttonsDisabled = true;
      selectedAnswer = answerIndex;
    });
    // Délai pour montrer la répone
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
                          fontSize: 34,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Gustavo',
                          height: 1.5,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      if (currentQuestion != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                              child: Text(
                                currentQuestion!['question'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: 'Outfit',
                                    color: Color(0xFFEB622B)),
                              ),
                            ),
                            const SizedBox(height: 30),
                            ...List.generate(4, (index) {
                              String answerKey = 'reponse${index + 1}';
                              Color buttonColor = const Color(0xFFFBBA2C);
                              if (buttonsDisabled) {
                                if (selectedAnswer == index + 1) {
                                  buttonColor = (selectedAnswer ==
                                          currentQuestion!['bonnereponse'])
                                      ? const Color(0xFF17A489)
                                      : const Color(0xFFEB622B);
                                }
                              }
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Center(
                                  child: ElevatedButton(
                                    onPressed: buttonsDisabled
                                        ? null
                                        : () => handleAnswer(index + 1),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: buttonColor,
                                      minimumSize:
                                          const Size(double.infinity, 50),
                                    ),
                                    child: Text(
                                      currentQuestion![answerKey],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w200,
                                          fontFamily: 'Outfit',
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              );
                            }),
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
