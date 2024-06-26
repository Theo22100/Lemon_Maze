import 'package:flutter/material.dart';
import 'package:LemonMaze/pages/home/home.dart';

class WelcomeHomePage extends StatefulWidget {
  const WelcomeHomePage({super.key});

  @override
  WelcomeHomePageState createState() => WelcomeHomePageState();
}

class WelcomeHomePageState extends State<WelcomeHomePage> {
  bool isChecked1 = false;
  bool isChecked2 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: const Color(0xFFFAF6D0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.13,
                    ),
                    Image.asset(
                      'assets/images/welcomehome/lemonmaze-orange.png',
                      height: MediaQuery.of(context).size.width * 0.06,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Image.asset(
                      'assets/images/welcomehome/home-lemonmaze.png',
                      height: MediaQuery.of(context).size.height * 0.2,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Bienvenue dans notre application !",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFE9581B),
                              fontSize: 16,
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          const Text(
                            "Nous sommes ravis de vous accueillir parmi nous. En cochant ces cases, vous acceptez nos conditions d'utilisation.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFE9581B),
                              fontSize: 16,
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          CheckboxListTile(
                            controlAffinity: ListTileControlAffinity
                                .leading, // Alignement à gauche
                            title: const Text(
                              "J’accepte les conditions d’utilisations",
                              style: TextStyle(
                                color: Color(0xFFE9581B),
                                fontSize: 14,
                                fontFamily: 'Outfit',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            value: isChecked1,
                            onChanged: (value) {
                              setState(() {
                                isChecked1 = value!;
                              });
                            },
                            activeColor: const Color(0xFFE9581B),
                          ),
                          CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: const Text(
                              "J’accepte de recevoir du contenu promotionnel par email et mobile",
                              style: TextStyle(
                                color: Color(0xFFE9581B),
                                fontSize: 14,
                                fontFamily: 'Outfit',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            value: isChecked2,
                            onChanged: (value) {
                              setState(() {
                                isChecked2 = value!;
                              });
                            },
                            activeColor: const Color(0xFFE9581B),
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // check pour voir si condition d'utilisation est cochée
                              if (!isChecked1) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Color(0xFFE9581B),
                                    content: Text(
                                      'Vous devez accepter les conditions d\'utilisation pour continuer.',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Outfit',
                                      ),
                                    ),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomePage()),
                                );
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(0xFFE9581B)),
                            ),
                            child: const Text(
                              'Suivant',
                              style: TextStyle(
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                          ),
                        ],
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
