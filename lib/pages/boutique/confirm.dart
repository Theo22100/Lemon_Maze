import 'dart:math';
import 'package:flutter/material.dart';
import 'package:my_app/modules/http.dart';
import 'package:my_app/pages/boutique/boutique.dart';
import 'package:my_app/pages/boutique/succes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

var logger = Logger();
Map<String, dynamic> response = {};

class ConfirmPage extends StatefulWidget {
  final int idRecompense;
  ConfirmPage({Key? key, required this.idRecompense}) : super(key: key);

  @override
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
    int idRecompense = widget.idRecompense;
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

  Future<String> _fetchLieuName(int id_lieu) async {
    try {
      final result = await http_get("lieu/getnomlieu/$id_lieu");
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
      'imagePath': '../../assets/images/boutique/bar.png',
      'citronColor': Colors.red,
      'citronText': 'citronRouge',
      'route': 'remove-citron-rouge'
    },
    2: {
      'imagePath': '../../assets/images/boutique/restaurant.png',
      'citronColor': Colors.yellow,
      'citronText': 'citronJaune',
      'route': 'remove-citron-jaune'
    },
    3: {
      'imagePath': '../../assets/images/boutique/musee.png',
      'citronColor': Colors.blue,
      'citronText': 'citronBleu',
      'route': 'remove-citron-bleu'
    },
    4: {
      'imagePath': '../../assets/images/boutique/bibliotheque.png',
      'citronColor': Colors.green,
      'citronText': 'citronVert',
      'route': 'remove-citron-vert'
    }
  };

  // Fonction pour construire la boîte de récompense
  Widget _buildRecompenseBox() {
    if (recompense == null) {
      return Center(
        child: Text(
          'Aucune récompense trouvée.',
          style: TextStyle(color: Colors.red, fontSize: 16),
        ),
      );
    }

    String nom = recompense['nom'] ?? 'Nom inconnu';
    String info = recompense['info'] ?? 'Info indisponible';
    int id_lieu = recompense['id_lieu'] ?? 0;
    int id_type = recompense['id_type'] ?? 0;

    var selectedType = typeData[id_type] ?? {};

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
                  width: 80,
                  height: 80,
                ),
              ),
              Positioned(
                top: 0,
                right: 15,
                child: Transform.rotate(
                  angle: -pi / 9, // Rotation
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    color: const Color(0xFFFAF6D0),
                    child: Text(
                      citronText,
                      style: TextStyle(
                        fontFamily: 'Poppins',
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
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFFFAF6D0),
                  ),
                ),
                const SizedBox(height: 5),
                FutureBuilder<String>(
                  future: _fetchLieuName(id_lieu), // Récupérer le nom du lieu
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(); // Indicateur de chargement
                    } else if (snapshot.hasError) {
                      return const Text("Erreur de chargement du nom du lieu");
                    } else {
                      return Text(
                        snapshot.data ?? '',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
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
                    fontFamily: 'Poppins',
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
    // Avoir taille ecran pour image
    final screenSize = MediaQuery.of(context).size;
    String response = "";

    final imageWidth = screenSize.width * 0.4;
    final imageHeight = screenSize.height * 0.2;

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              '../../assets/images/welcome/wallpaper.png',
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
                      '../../assets/images/boutique/backhomecitron.png',
                      width: 50,
                      height: 50,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Je veux régler ma commande...",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 40,
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
                    height: MediaQuery.of(context).size.height / 1.30,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),
                          const Text(
                            'Achat de ma commande',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 22,
                              color: Color(0xFFEB622B),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildRecompenseBox(),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () async {
                              _removeCitron(citron);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFFE9581B), // Couleur du fond
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(20), // Bords arrondis
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 16), // Taille du bouton
                            ),
                            child: const Text(
                              'J\'achète',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white, // Couleur du texte
                                fontSize: 18, // Taille de la police
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Attention, après avoir cliqué sur \"J’achète\", aucun retour ou remboursement ne sera possible. \nVoir conditions d'utilisation.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.red,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8), // Ajoute espace
                          Text(
                            textAlign: TextAlign.center,
                            responsemsg,
                            style: const TextStyle(
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
                    '../assets/images/boutique/shop-bot.png',
                    fit: BoxFit.cover,
                    alignment: Alignment.bottomCenter,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _removeCitron(int citron) async {
    logger.i('Citron $citron');
    logger.i('Route $route');
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('id');

      if (userId == null || userId.isEmpty) {
        logger.e('User ID is null or empty');
        setState(() {
          responsemsg = 'Erreur: ID utilisateur non trouvé';
        });
        return;
      }

      final body = {
        'userId': userId,
        'nombre': citron,
      };

      final result =
          await http_put(route, body); // Utilisez la route correcte ici
      logger.i(result);

      if (result.data['success']) {
        logger.i('Successfully removed $citron citron(s)');
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
        logger.e('Failed to remove citron(s): ${result.data}');
      }
    } catch (error) {
      logger.e('Error removing citron(s): $error');
      setState(() {
        responsemsg = 'Erreur interne lors de la suppression des citrons';
      });
    }
  }
}
