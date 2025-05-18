import 'package:flutter/material.dart';
import '../widget/navbar.dart';

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Favoris")),
      body: Center(
        child: Text("Page des favoris", style: TextStyle(fontSize: 24)),
      ),
      bottomNavigationBar: navbar(selectedIndex: 1, backgroundColor: Colors.blue),
    );
  }
}
