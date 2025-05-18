import 'dart:async'; // timer
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart'; // animation de texte
import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
// C'est là que se trouve la logique de la page et son apparence dynamique.
class _SplashScreenState extends State<SplashScreen> {
  @override
  // Elle sert à configurer les comportements qui doivent se produire une seule fois lors du démarrage de la page
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue, // Fond bleu
      body: Center(
        child: DefaultTextStyle(
          style: TextStyle(
            fontSize: 28, // Texte plus grand
            fontWeight: FontWeight.w300, // Police fine
            color: Colors.white,
          ),
          child: AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                'Welcome to Guide Me',
                speed: Duration(milliseconds: 100), // Vitesse de l'animation
              ),
            ],
            repeatForever: false, // Ne se répète pas
            totalRepeatCount: 1, // Joue une seule fois
          ),
        ),
      ),
    );
  }
}
