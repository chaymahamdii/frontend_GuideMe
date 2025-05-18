import 'package:flutter/material.dart';

class BeachesView extends StatelessWidget {
  final List<String> beaches = [
    "Plage de Cancun",
    "Baie des Anges",
    "Maldives",
    "Plage de Bora Bora",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Plages"),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        itemCount: beaches.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.beach_access, color: Colors.orange),
            title: Text(beaches[index]),
          );
        },
      ),
    );
  }
}
