import 'package:flutter/material.dart';

class CodePage extends StatefulWidget {
  final int randomIdParkour;
  final int idParty;

  const CodePage(
      {super.key, required this.randomIdParkour, required this.idParty});

  @override
  _CodePageState createState() => _CodePageState();
}

class _CodePageState extends State<CodePage> {
  List<String> code = [
    "",
    "",
    "",
    ""
  ]; // Liste pour stocker les entrées du code
  int currentIndex = 0; // Index actuel pour la saisie du code

  void addDigit(String digit) {
    setState(() {
      if (currentIndex < 4) {
        code[currentIndex] = digit;
        currentIndex++;
      }
    });
  }

  void removeDigit() {
    setState(() {
      if (currentIndex > 0) {
        currentIndex--;
        code[currentIndex] = "";
      }
    });
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
              '../../../assets/images/welcome/wallpaper.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: screenHeight * 0.04,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                '../../../assets/images/home/homeparkour/bar.png',
                width: screenWidth * 0.4,
                height: screenHeight * 0.2,
                fit: BoxFit.contain,
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
                      const SizedBox(height: 20),
                      const Text(
                        "Récupérez votre code",
                        style: TextStyle(
                          color: Color(0xFFEB622B),
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Outfit',
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(4, (index) {
                          return Container(
                            width: 50,
                            height: 50,
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
                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50.0), // Padding pour taille bouton
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
                              child: const Icon(
                                Icons.backspace,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
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

class DigitButton extends StatefulWidget {
  final String digit;
  final VoidCallback onPressed;

  const DigitButton({
    Key? key,
    required this.digit,
    required this.onPressed,
  }) : super(key: key);

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
