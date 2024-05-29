import 'package:flutter/material.dart';
import 'package:my_app/modules/http.dart';
import 'package:my_app/pages/parkour/bar/bar_lieu.dart';

class BarMap extends StatefulWidget {
  final int randomIdParkour;
  final int idParty;

  const BarMap(
      {super.key, required this.randomIdParkour, required this.idParty});

  @override
  _BarMapState createState() => _BarMapState();
}

class _BarMapState extends State<BarMap> {
  List<String> lieux = [];
  int etat = 0;

  @override
  void initState() {
    super.initState();
    fetchLieux();
    getEtatParty();
  }

  Future<void> fetchLieux() async {
    var result =
        await http_get("parkour/getparkour/nomslieu/${widget.randomIdParkour}");
    if (result.ok) {
      var data = result.data['data'];
      if (data != null && data['lieux'] != null) {
        setState(() {
          lieux = List<String>.from(data['lieux']);
        });
      } else {
        //mettre msg erreur
        logger.e("The response data or 'lieux' key is null");
      }
    } else {
      // Handle error
      logger.e("Failed to fetch parkour data");
    }
  }

  Future<void> getEtatParty() async {
    var result = await http_get("party/getpartyetat/${widget.idParty}");
    if (result.ok) {
      var data = result.data['data'];
      if (data != null && data['etat'] != null) {
        setState(() {
          etat = data['etat'];
        });
      } else {
        //mettre msg erreur
        logger.e("The response data or 'etat' key is null");
      }
    } else {
      // Handle error
      logger.e("Failed to fetch parkour data");
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
                color: const Color(0xFFFAF6D0),
                height: screenHeight / 1.35,
                width: screenWidth,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: CustomPaint(
                          painter: SnakePainter(lieux, etat),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 20,
                      right: 20,
                      child: Image.asset(
                        'assets/images/parkour/start.png',
                        width: 100,
                        height: 100,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: screenWidth / 8,
                      child: Image.asset(
                        'assets/images/parkour/finish.png',
                        width: 105,
                        height: 105,
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
                              builder: (context) => BarLieu(
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

class SnakePainter extends CustomPainter {
  final List<String> lieux;
  final int etat;
  SnakePainter(this.lieux, this.etat);
  @override
  void paint(Canvas canvas, Size size) {
    const Color couleurOrange = Color(0xFFEB632B);
    const Color couleurVerte = Color(0xFFA1CD91);
    Color couleurFinale;
    Paint paint = Paint()
      //Permet d'avoir un dégradé
      ..shader = const LinearGradient(
        colors: [
          Color(0xFFA1CD91),
          Color(0xFFA8CB89),
          Color(0xFFBBC773),
          Color(0xFFDBC04F),
          Color(0xFFFBBA2C),
        ],
        stops: [0.0, 0.17, 0.42, 0.73, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = 8.0 //Épaisseur du trait
      ..style = PaintingStyle.stroke;

    Path path = Path();
    path.moveTo(size.width - 50, 72); //Départ
    //Positionnement points
    double stepX = size.width / 5.8;
    double stepY = size.height / 5;
    //cr
    for (int i = 0; i < 5; i++) {
      double controlPointX = (i % 2 == 0)
          ? size.width - stepX * (i - 0.2) /*start à image1*/
          : size.width - stepX * (i + 1.5);
      double controlPointY = (i % 2 == 0) ? stepY * (i + 1) : stepY * (i);
      double endPointX = size.width - stepX * (i + 1);
      double endPointY = stepY * (i + 1);

      path.quadraticBezierTo(
          controlPointX, controlPointY, endPointX, endPointY); //Ligne
    }

    canvas.drawPath(path, paint);

    for (int i = 1; i < 5; i++) {
      double circleX = size.width - stepX * i;
      double circleY = stepY * i;
      //Choix couleur cercle en fonction etat
      if ((etat + 2) <= i) {
        couleurFinale = couleurOrange;
      } else {
        couleurFinale = couleurVerte;
      }

      Paint circlePaint = Paint()
        ..color = couleurFinale
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(circleX, circleY), 15, circlePaint);
      //Affichage des lieux
      if (i - 1 < lieux.length) {
        TextSpan span = TextSpan(
          style: TextStyle(
            color: couleurFinale,
            fontSize: 14,
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w500,
          ),
          text: lieux[i - 1],
        );

        TextPainter tp = TextPainter(
          text: span,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
        );
        //MISE EN PLACE TEXTS
        tp.layout();
        if (i == 1 || i == 2) {
          tp.paint(canvas, Offset(circleX - 100, circleY - 30));
        } else {
          tp.paint(canvas, Offset(circleX + 16, circleY + 12));
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
