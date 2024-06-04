import 'package:flutter/material.dart';
import 'package:LemonMaze/pages/register-login/login_signup_page.dart';

class Welcome4Page extends StatelessWidget {
  const Welcome4Page({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        color: const Color(0xFFFAF6D0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Image.asset(
                'assets/images/welcome/welcome-4.png',
                width: double.infinity, // Prend toute la largeur
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
                              'Explore de nouveaux lieux',
                              style: TextStyle(
                                  color: Color(0xFFFAF6D0),
                                  fontSize: 32,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5,
                                  fontFamily: 'Gustavo'),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Text(
                              'Découvre de nouveaux endroits à Rennes et trouve de nouvelles adresses qui deviendront tes favoris.',
                              style: TextStyle(
                                color: Color(0xFFFAF6D0),
                                fontFamily: 'Outfit',
                                fontSize: 19,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: screenHeight * 0.03,
                      left: 16,
                      child: Image.asset(
                        'assets/images/welcome/index_page4.png',
                        height: screenHeight * 0.01,
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
                                builder: (context) => const LoginSignUpPage()),
                          );
                        },
                        child: Image.asset(
                          'assets/images/welcome/circle_arrow.png',
                          height: screenHeight * 0.06,
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
