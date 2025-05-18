// lib/widget/search_widget.dart

import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final String hintText;

  SearchWidget({
    required this.controller,
    required this.onChanged,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              controller.clear();
              onChanged('');  // Efface la recherche
            },
          ),
        ),
        onChanged: onChanged,  // Quand l'utilisateur tape, on met à jour le texte de recherche
      ),
    );
  }
}
