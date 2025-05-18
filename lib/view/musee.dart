import 'package:flutter/material.dart';

class MuseumsView extends StatefulWidget {
  @override
  _MuseumsViewState createState() => _MuseumsViewState();
}

class _MuseumsViewState extends State<MuseumsView> {
  final List<Map<String, dynamic>> museums = [
    {
      "name": "Musée de Mahdia",
      "address": "Mahdia",
      "image": "assets/image/mahdia.jpg",
    },
    {
      "name": "Musée de Nabeul",
      "address": "Nabeul",
      "image": "assets/image/nabeul.jpg",
    },
    {
      "name": "Musée archéologique d'El Jem",
      "address": "El Jem",
      "image": "assets/image/ljam.jpg",
    },
    {
      "name": "Musée de Sfax",
      "address": "Sfax",
      "image": "assets/image/sfax.jpg",
    },
    {
      "name": "Musée d'art moderne de Tunis",
      "address": "Tunis",
      "image": "assets/image/tunis.jpg",
    },
    {
      "name": "Musée de Djerba",
      "address": "Djerba",
      "image": "assets/image/djerba.jpg",
    },
  ];

  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Musées en Tunisie"),
        backgroundColor: Colors.deepOrange,
        leading: Icon(Icons.museum),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              onChanged: (value) => setState(() => searchQuery = value.toLowerCase()),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Rechercher un musée...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.8,
              ),
              itemCount: museums.length,
              itemBuilder: (context, index) {
                if (searchQuery.isNotEmpty &&
                    !museums[index]["name"].toLowerCase().contains(searchQuery)) {
                  return Container();
                }
                return MuseumCard(
                  imageAsset: museums[index]["image"],
                  name: museums[index]["name"],
                  address: museums[index]["address"],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MuseumCard extends StatelessWidget {
  final String imageAsset;
  final String name;
  final String address;

  const MuseumCard({
    required this.imageAsset,
    required this.name,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                imageAsset,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(address, style: TextStyle(color: Colors.grey[700])),
          ),
        ],
      ),
    );
  }
}
