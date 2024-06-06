import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../modules/http.dart';
import '../home/home.dart';

final Logger logger = Logger();

Future<void> abandonParty(BuildContext context, int idParty) async {
  try {
    final body = {};
    final result = await http_put('party/abandon/$idParty', body);

    if (result.data['success']) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      logger.e('Erreur pour abandonner une partie');
    }
  } catch (error) {
    logger.e('Erreur interne: $error');
  }
}

Future<bool?> showExitConfirmationDialog(BuildContext context, int idParty) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Êtes-vous sûr de vouloir quitter la partie ?',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontFamily: 'Outfit',
          )),
      content: const Text('Vous allez être renvoyé à l\'accueil.',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontFamily: 'Outfit',
          )),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop(); // Close the dialog first
            await abandonParty(context, idParty);
          },
          child: const Text('OUI',
              style: TextStyle(
                color: Colors.green,
                fontSize: 18,
                fontWeight: FontWeight.w400,
                fontFamily: 'Outfit',
              )),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context)
                .pop(false); // Pass false to the calling function
          },
          child: const Text('NON',
              style: TextStyle(
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
