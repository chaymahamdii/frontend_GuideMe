import 'package:flutter/material.dart';

class UploadSignedContractScreen extends StatelessWidget {
  final String localType;
  final String address;
  final String cardNumber;

  UploadSignedContractScreen({
    required this.localType,
    required this.address,
    required this.cardNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Contract")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Local Type: $localType", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Address: $address", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Card Number: $cardNumber", style: TextStyle(fontSize: 18)),
            SizedBox(height: 30),

            // Bouton pour envoyer l'email et confirmer l'accès
            ElevatedButton(
              onPressed: () {
                // Logique d'envoi de l'email et confirmation de l'accès
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Email sent and account access confirmed!")),
                );
              },
              child: Text("Send Email and Access Account"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
