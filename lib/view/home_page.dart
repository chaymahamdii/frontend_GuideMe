import 'package:flutter/material.dart';
import '/widget/navbar.dart';
import '/widget/MapWidget.dart';
import '/widget/AR.dart';
import '/widget/calendar.dart';
import '/widget/chatbot.dart';
import 'calendar_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🌄 Image de fond sur tout l’écran
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/waw.png'), // ton image
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 🔹 Contenu en overlay
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: 100),
                Center(
                  child: Text(
                    'Guide Me',
                    style: TextStyle(
                      fontSize: 42,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 10,
                          color: Colors.black54,
                          offset: Offset(2, 2),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 50),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: GridView.count(
                      crossAxisCount: 2, // Deux éléments par ligne
                      crossAxisSpacing: 16, // Espacement horizontal entre les carreaux
                      mainAxisSpacing: 16,  // Espacement vertical entre les lignes
                      padding: EdgeInsets.symmetric(vertical: 40, horizontal: 12), // Padding autour de la grille
                      shrinkWrap: true, // Empêche le débordement de la grille
                      physics: NeverScrollableScrollPhysics(), // Désactive le défilement pour cette grille
                      children: [
                        buildTransparentCard(MapWidget(), 'Carte'),
                        buildTransparentCard(chatbot(), 'Réalité Augmentée'),
                        buildTransparentCard(chatbot(), 'Chatbot'),
                        buildTransparentCard(calendar(), 'Calendrier'),
                      ],
                    ),

                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: navbar(
        selectedIndex: _selectedIndex,
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget buildTransparentCard(Widget child, String title) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2), // Légère transparence
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white70, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Padding(padding: const EdgeInsets.all(8), child: child)),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [Shadow(blurRadius: 4, color: Colors.black45)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
