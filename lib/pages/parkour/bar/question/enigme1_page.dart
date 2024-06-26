import 'package:flutter/material.dart';
import 'package:LemonMaze/modules/http.dart';
import 'package:LemonMaze/pages/parkour/bar/question/enigme2_page.dart';
import 'package:logger/logger.dart';

import '../../dialog_abandon.dart';

final Logger logger = Logger();

class EnigmePage1 extends StatefulWidget {
  final int randomIdParkour;
  final int idParty;

  const EnigmePage1({
    super.key,
    required this.randomIdParkour,
    required this.idParty,
  });

  @override
  EnigmePage1State createState() => EnigmePage1State();
}

class EnigmePage1State extends State<EnigmePage1> {
  int etat = 0;
  List<dynamic> questions = [];
  Map<String, dynamic>? currentQuestion;

  // préparation de la page
  @override
  void initState() {
    super.initState();
    getEtatParty();
    getQuestion();
  }

  // récupération de la question
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
          logger.e("La réponse 'questions' ou la clé 'code' est nulle");
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

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        final exitConfirmed =
            await showExitConfirmationDialog(context, widget.idParty);
        return exitConfirmed ?? false;
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
                      Positioned(
                        bottom: screenHeight / 8,
                        top: 0,
                        child: Image.asset(
                          'assets/images/parkour/enigme.png',
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
                      Positioned(
                        bottom: screenHeight / 2.5,
                        left: screenWidth * 0.3,
                        right: screenWidth * 0.1,
                        child: LayoutBuilder(
                          builder: (BuildContext context,
                              BoxConstraints constraints) {
                            return CustomPaint(
                              painter:
                                  OvalBubblePainter(const Color(0xFFFAF6D0)),
                              child: Container(
                                padding: const EdgeInsets.all(16.0),
                                constraints: BoxConstraints(
                                  maxWidth: constraints.maxWidth,
                                  minHeight: 50.0,
                                ),
                                child: Center(
                                  child: currentQuestion == null
                                      ? const CircularProgressIndicator(
                                          color: Color(0xFFEB622B))
                                      : Text(
                                          currentQuestion?['question'],
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xFFEB622B),
                                              fontFamily: 'Outfit'),
                                          textAlign: TextAlign.center,
                                        ),
                                ),
                              ),
                            );
                          },
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

// Forme question
class OvalBubblePainter extends CustomPainter {
  final Color color;

  OvalBubblePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final Path path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(25),
      ));

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
