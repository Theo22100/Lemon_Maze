import 'dart:math';
import 'package:flutter/material.dart';
import 'package:LemonMaze/modules/http.dart';
import 'package:LemonMaze/pages/boutique/boutique.dart';
import 'package:LemonMaze/pages/boutique/succes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

var logger = Logger();
Map<String, dynamic> response = {};

class ConfirmPage extends StatefulWidget {
  final int idRecompense;
  const ConfirmPage({super.key, required this.idRecompense});

  @override
  // ignore: library_private_types_in_public_api
  _ConfirmPageState createState() => _ConfirmPageState();
}

class _ConfirmPageState extends State<ConfirmPage> {
  bool isLoading = false;
  int citron = 0;
  String route = '';
  dynamic recompense;
  String responsemsg = '';

  @override
  void initState() {
    super.initState();
    _fetchOneRecompense(); // Appel de la fonction pour récupérer les récompenses
  }

  // Fonction pour récupérer les récompenses en fonction de l'ID de type
  Future<void> _fetchOneRecompense() async {
    setState(() {
      isLoading = true; // Définir l'indicateur de chargement sur vrai
    });

    try {
      // Appel de l'API pour récupérer les récompenses
      int idRecompense = widget.idRecompense;
      final result = await http_get("recompense/getrecompense/$idRecompense");

      if (result.data['success']) {
        setState(() {
          response = result.data['data']; // Mettre à jour la réponse
          recompense = response; // Mettre à jour la récompense
        });
      } else {
        setState(() {
          response =
              result.data['message']; // Mettre à jour le message d'erreur
        });
      }
    } catch (error) {
      logger.e("Error: $error");
      setState(() {
        response = {
          'message': "Erreur lors de la récupération des récompenses"
        }; // Mettre à jour le message d'erreur
      });
    } finally {
      setState(() {
        isLoading =
            false; // Définir l'indicateur de chargement sur faux une fois terminé
      });
    }
  }

  Future<String> _fetchLieuName(int idLieu) async {
    try {
      final result = await http_get("lieu/getnomlieu/$idLieu");
      if (result.data['success']) {
        return result.data['data']['nom'];
      } else {
        throw Exception("Lieu non trouvé"); // Lancer une exception
      }
    } catch (error) {
      logger.e("Erreur lors de la récupération du nom du lieu: $error");
      return "Erreur de chargement du nom du lieu";
    }
  }

  Map<int, dynamic> typeData = {
    1: {
      'imagePath': 'assets/images/boutique/bar.png',
      'citronColor': Colors.red,
      'citronText': 'citronRouge',
      'route': 'remove-citron-rouge'
    },
    2: {
      'imagePath': 'assets/images/boutique/restaurant.png',
      'citronColor': Colors.yellow,
      'citronText': 'citronJaune',
      'route': 'remove-citron-jaune'
    },
    3: {
      'imagePath': 'assets/images/boutique/musee.png',
      'citronColor': Colors.blue,
      'citronText': 'citronBleu',
      'route': 'remove-citron-bleu'
    },
    4: {
      'imagePath': 'assets/images/boutique/bibliotheque.png',
      'citronColor': Colors.green,
      'citronText': 'citronVert',
      'route': 'remove-citron-vert'
    }
  };

  // Fonction pour construire la boîte de récompense
  Widget _buildRecompenseBox(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    if (recompense == null) {
      return const Center(
        child: Text(
          'Aucune récompense trouvée.',
          style: TextStyle(color: Colors.red, fontSize: 16),
        ),
      );
    }

    String nom = recompense['nom'] ?? 'Nom inconnu';
    String info = recompense['info'] ?? 'Info indisponible';
    int idLieu = recompense['id_lieu'] ?? 0;
    int idType = recompense['id_type'] ?? 0;

    var selectedType = typeData[idType] ?? {};

    String imagePath = selectedType['imagePath'] ?? '';
    Color citronColor = selectedType['citronColor'] ?? Colors.transparent;
    String citronText = '${recompense[selectedType['citronText']] ?? 0} PTS';
    setState(() {
      citron = recompense[selectedType['citronText']] ?? 0;
      route = selectedType['route'] ?? '';
    });

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFAB92C),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Centrer verticalement l'image
          Stack(
            children: [
              Center(
                child: Image.asset(
                  imagePath,
                  width: screenHeight*0.1,
                  height: screenWidth*0.3,
                ),
              ),
              Positioned(
                top: screenHeight*0.015,
                right: screenWidth*0.04,
                child: Transform.rotate(
                  angle: -pi / 9, // Rotation
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth*0.02, vertical: screenHeight*0.005),
                    color: const Color(0xFFFAF6D0),
                    child: Text(
                      citronText,
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        color: citronColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nom,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFFFAF6D0),
                  ),
                ),
                const SizedBox(height: 5),
                FutureBuilder<String>(
                  future: _fetchLieuName(idLieu), // Récupérer le nom du lieu
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(); // Indicateur de chargement
                    } else if (snapshot.hasError) {
                      return const Text("Erreur de chargement du nom du lieu");
                    } else {
                      return Text(
                        snapshot.data ?? '',
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color(0xFFFAF6D0),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 5),
                Text(
                  info,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color(0xFFFAF6D0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // // Avoir taille ecran pour image
    // final screenSize = MediaQuery.of(context).size;

    // final imageWidth = screenSize.width * 0.4;
    // final imageHeight = screenSize.height * 0.2;
    return WillPopScope(
      onWillPop: () async {
        // Retourner false pour bloquer la touche retour
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Background
            Positioned.fill(
              child: Image.asset(
                'assets/images/welcome/wallpaper.png',
                fit: BoxFit.cover,
              ),
            ),
            // Back button at the top left
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BoutiquePage()),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/images/boutique/backhomecitron.png',
                        width: 50,
                        height: 50,
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        "Je veux regler ma commande...",
                        style: TextStyle(
                          fontFamily: 'Gustavo',
                          fontWeight: FontWeight.w500,
                          fontSize: 32,
                          color: Color(0xFFFAF6D0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    child: Container(
                      color: const Color(0xFFFAF6D0),
                      //Taille zone beige
                      height: MediaQuery.of(context).size.height / 1.30,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 10),
                            const Text(
                              //Texte titre
                              'Achat de ma commande',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontWeight: FontWeight.w600,
                                fontSize: 22,
                                color: Color(0xFFEB622B),
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildRecompenseBox(context),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () async {
                                _removeCitron(citron);
                              },
                              //Bouton achete
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE9581B),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40,
                                    vertical: 16), // Taille bouton
                              ),
                              child: const Text(
                                'J\'achète',
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              textAlign: TextAlign.center,
                              responsemsg,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.red,
                                fontFamily: 'Outfit',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "Attention, après avoir cliqué sur \"J’achète\", aucun retour ou remboursement ne sera possible. \nVoir conditions d'utilisation.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFEB622B),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              textAlign: TextAlign.center,
                              responsemsg,
                              style: const TextStyle(
                                fontFamily: 'Outfit',
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xFFFAF6D0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Image.asset(
                      'assets/images/boutique/shop-bot.png',
                      fit: BoxFit.cover,
                      alignment: Alignment.bottomCenter,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _removeCitron(int citron) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('id');

      if (userId == null || userId.isEmpty) {
        logger.e('User ID est null ou vide');
        setState(() {
          responsemsg = 'Erreur: ID utilisateur non trouvé';
        });
        return;
      }
      final body = {
        'userId': userId,
        'nombre':
            citron, // Assurez-vous que 'nombre' est une chaîne de caractères
      };

      final result = await http_put(route, body);

      if (result.data['success']) {
        _addRecompense();
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SuccesPage(idRecompense: widget.idRecompense),
          ),
        );
      } else {
        setState(() {
          responsemsg = result.data['message'];
        });
      }
    } catch (error) {
      logger.e('Erreur en enlevant les citrons: $error');
      setState(() {
        responsemsg = 'Erreur interne lors de la suppression des citrons';
      });
    }
  }

  Future<void> _addRecompense() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('id');

      // Validation userId
      if (userId == null || userId.isEmpty) {
        logger.e('User ID est null ou vide');
        setState(() {
          responsemsg = 'Erreur: ID utilisateur non trouvé';
        });
        return;
      }

      var result3 = await http_post("recompense_user/create_recompense_user",
          {"id_user": userId, "id_recompense": widget.idRecompense});

      if (result3.ok) {
        setState(() {
          if (result3.data['success'] == true) {
            responsemsg = 'Récompense ajoutée avec succès';
          } else {
            responsemsg = result3.data['message'];
            logger.e("Erreur : ${result3.data['message']}");
          }
        });
      } else {
        setState(() {
          responsemsg = 'Erreur de connexion avec le serveur';
        });
        logger.e('Erreur de connexion avec le serveur');
      }
    } catch (error) {
      setState(() {
        responsemsg = 'Erreur inattendue: $error';
      });
      logger.e("Erreur inattendue: $error");
    }
  }
}
