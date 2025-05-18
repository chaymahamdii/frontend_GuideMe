import 'package:flutter/material.dart';

class PlaceCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final double rating;
  final int reviews;
  final double distance;
  final String? price; // Optionnel pour les hôtels

  const PlaceCard({
    required this.imageUrl,
    required this.title,
    required this.rating,
    required this.reviews,
    required this.distance,
    this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.asset(imageUrl, height: 120, width: double.infinity, fit: BoxFit.cover),
              ),
              if (price != null)
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    color: Colors.black54,
                    child: Text("$price per night", style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.orange, size: 16),
                    Text("$rating ($reviews)", style: TextStyle(fontSize: 12)),
                  ],
                ),
                Text("${distance.toStringAsFixed(2)} Km", style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
