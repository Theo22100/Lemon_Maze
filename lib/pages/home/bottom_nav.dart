import 'package:flutter/material.dart';
import 'package:LemonMaze/pages/boutique/citron.dart';
import 'package:LemonMaze/pages/home/account.dart';
import 'package:LemonMaze/pages/home/inventory.dart';

import 'home.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Material(
          color: const Color(0xFFFAF6D0),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFEB622B),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            height: constraints.maxWidth * 0.18,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(
                  context,
                  icon: Icons.home,
                  label: 'Accueil',
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                ),
                _buildNavItem(
                  context,
                  icon: Icons.shopping_bag,
                  label: 'Boutique',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CitronPage()),
                    );
                  },
                ),
                _buildNavItem(
                  context,
                  icon: Icons.archive,
                  label: 'Inventaire',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const InventoryPage()),
                    );
                  },
                ),
                _buildNavItem(
                  context,
                  icon: Icons.person,
                  label: 'Profil',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AccountPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onPressed}) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, size: screenHeight * 0.029),
          onPressed: onPressed,
          color: const Color(0xFFFAF6D0),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFFAF6D0),
            fontSize: 13.0,
            fontWeight: FontWeight.w400,
            fontFamily: 'Outfit',
          ),
        ),
      ],
    );
  }
}
