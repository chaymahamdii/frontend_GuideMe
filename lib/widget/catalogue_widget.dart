import 'package:flutter/material.dart';

class CatalogueWidget extends StatelessWidget {
  final List<Map<String, String>> destinations = [
    {
      'title': 'Paris',
      'image': 'assets/image/images.jpg',
      'description': 'Explorez la ville de l\'amour et ses monuments célèbres.',
    },
    {
      'title': 'New York',
      'image': 'assets/image/images.jpg',
      'description': 'Venez découvrir la ville qui ne dort jamais.',
    },
    {
      'title': 'Tokyo',
      'image': 'assets/image/images.jpg',
      'description': 'Venez explorer la culture moderne et traditionnelle de Tokyo.',
    },
    {
      'title': 'Tunis',
      'image': 'assets/image/images.jpg',
      'description': 'Découvrez la beauté de la Méditerranée et l\'histoire tunisienne.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Popular Destinations',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        // Liste des destinations avec des cartes
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 20/ 9, // Ajuste la hauteur de la carte
          ),
          itemCount: destinations.length,
          itemBuilder: (context, index) {
            final destination = destinations[index];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                height: 250, // 🔹 Ajuste la hauteur ici
                child: Stack(
                  children: [
                    // Image en arrière-plan
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage(destination['image']!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Dégradé sombre pour améliorer la lisibilité du texte
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.3),
                            Colors.black.withOpacity(0.8),
                          ],
                        ),
                      ),
                    ),
                    // Texte superposé
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            destination['title']!,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            destination['description']!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
