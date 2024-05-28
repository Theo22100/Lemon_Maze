import 'package:flutter/material.dart';
import 'package:my_app/pages/welcome/page3.dart';

class Welcome2Page extends StatelessWidget {
  const Welcome2Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFFAF6D0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 20), // Espace supplémentaire en haut
              child: Image.asset(
                'assets/images/welcome/welcome-2.png',
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      child: Image.asset(
                        'assets/images/welcome/wallpaper.png',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 2.5,
                      ),
                    ),
                    Positioned(
                      top: 16,
                      left: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Amuse-toi avec tes amis',
                              style: TextStyle(
                                  color: Color(0xFFFAF6D0),
                                  fontSize: 40,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Gustavo'),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 16,
                            ), // Espacement entre les deux textes
                            Text(
                              'Rejoins des jeux de piste exclusifs pour passer du bon temps avec tous tes amis.',
                              style: TextStyle(
                                color: Color(0xFFFAF6D0),
                                fontFamily: 'Inter',
                                fontSize: 19,
                                fontWeight: FontWeight.w400,
                                height: 25 / 19, // Calculer le line-height
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 1,
                      left: 16,
                      child: Image.asset(
                        'assets/images/welcome/index_page2.png',
                        width: 80,
                        height: 80,
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 16,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Welcome3Page()),
                          );
                        },
                        child: Image.asset(
                          'assets/images/welcome/circle_arrow.png',
                          width: 50,
                          height: 50,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
