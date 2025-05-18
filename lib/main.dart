import 'package:flutter/material.dart';
import 'view/splash_screen.dart'; // Import de la splash screen

void main() {
  runApp(MyApp()); // Exécute l'application en lançant la classe MyApp
}

class MyApp extends StatelessWidget {
  @override // Indique que la méthode 'build' surchargera celle de 'StatelessWidget'
  Widget build(BuildContext context) { // La méthode build retourne l'interface utilisateur de l'application
    return MaterialApp(
      debugShowCheckedModeBanner: false,  // Désactive le bandeau "Debug" en haut à droite de l'écran
      title: 'Guide Me',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SplashScreen(), // On démarre avec la Splash Screen
    );
  }
}
