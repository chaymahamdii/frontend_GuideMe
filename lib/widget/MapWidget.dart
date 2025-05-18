import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../view/full_screen_map_page.dart';

class MapWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Ouvre la carte en plein écran lors d'un clic
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FullScreenMapPage()),
        );
      },
      child: Container(
        height: 180,
        width: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            fit: StackFit.expand, // Permet à la carte d'occuper tout l'espace disponible
            children: [
              // Carte comme arrière-plan
              FlutterMap(
                options: MapOptions(
                  center: LatLng(48.8566, 2.3522), // Paris
                  zoom: 10.0, // Zoom initial
                  interactiveFlags: InteractiveFlag.all, // Désactive l'interaction
                ),
                children: [
                  TileLayer(
                    urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(48.8566, 2.3522),
                        width: 30,
                        height: 30,
                        child: Icon(Icons.location_pin, color: Colors.red, size: 30),
                      ),
                    ],
                  ),
                ],
              ),
              // Autres widgets en avant-plan (comme un bouton ou du texte)
              Positioned(
                top: 10,
                left: 10,
                child: Icon(
                  Icons.zoom_in,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
