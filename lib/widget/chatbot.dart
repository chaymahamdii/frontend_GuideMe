import 'package:flutter/material.dart';
import '/view/chatbot_screen.dart'; // Importer la vue du chatbot

class chatbot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatbotScreen()), // Navigation
        );
      },
      child: Container(
        height: 180,
        width: 160,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Icon(Icons.chat, size: 80, color: Colors.grey[600]),
        ),
      ),
    );
  }
}
