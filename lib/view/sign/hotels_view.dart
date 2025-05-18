import 'package:flutter/material.dart';

class HotelsView extends StatefulWidget {
  @override
  _HotelsViewState createState() => _HotelsViewState();
}

class _HotelsViewState extends State<HotelsView> {
  final List<Map<String, dynamic>> hotels = [
    {
      "title": "The Résidence Tunis",
      "image": "assets/image/residence_tunis.jpg",
      "rating": 4.7,
      "reviews": 321,
      "distance": 1450.3,
      "price": "\$140",
    },
    {
      "title": "La Badira – Hammamet",
      "image": "assets/image/badira_hammemt.jpg",
      "rating": 4.6,
      "reviews": 220,
      "distance": 2053.2,
      "price": "\$180",
    },
    {
      "title": "Hasdrubal Thalassa – Djerba",
      "image": "assets/image/hasdrubal_djerba.jpg",
      "rating": 4.8,
      "reviews": 310,
      "distance": 3053.5,
      "price": "\$200",
    },
    {
      "title": "Four Seasons – Tunis",
      "image": "assets/image/four_seasons_tunis.jpg",
      "rating": 4.9,
      "reviews": 500,
      "distance": 1050.7,
      "price": "\$270",
    },
    {
      "title": "Mövenpick – Sousse",
      "image": "assets/image/movenpick_sousse.jpg",
      "rating": 4.5,
      "reviews": 410,
      "distance": 2650.2,
      "price": "\$160",
    },
    {
      "title": "Dar El Jeld – Tunis",
      "image": "assets/image/dar_el_jeld.jpg",
      "rating": 4.7,
      "reviews": 178,
      "distance": 750.4,
      "price": "\$130",
    },
    {
      "title": "Royal Garden – Djerba",
      "image": "assets/image/royal_garden_djerba.jpg",
      "rating": 4.4,
      "reviews": 212,
      "distance": 3250.9,
      "price": "\$110",
    },
    {
      "title": "El Mouradi Palace – Kantaoui",
      "image": "assets/image/el_mouradi_palace.jpg",
      "rating": 4.1,
      "reviews": 290,
      "distance": 2450.6,
      "price": "\$95",
    },
    {
      "title": "Iberostar – Kantaoui Bay",
      "image": "assets/image/iberostar_kantaoui.jpg",
      "rating": 4.6,
      "reviews": 348,
      "distance": 2600.0,
      "price": "\$150",
    },
    {
      "title": "Laico – Tunis",
      "image": "assets/image/laico_tunis.jpg",
      "rating": 4.3,
      "reviews": 198,
      "distance": 890.2,
      "price": "\$110",
    },
    {
      "title": "Radisson Blu – Djerba",
      "image": "assets/image/radisson_djerba.jpg",
      "rating": 4.5,
      "reviews": 250,
      "distance": 3150.0,
      "price": "\$175",
    },
    {
      "title": "El Mouradi – Gammarth",
      "image": "assets/image/el_mouradi_gammarth.jpg",
      "rating": 4.2,
      "reviews": 185,
      "distance": 980.0,
      "price": "\$100",
    },
    {
      "title": "Marhaba Royal Salem – Sousse",
      "image": "assets/image/marhaba_sousse.jpg",
      "rating": 4.3,
      "reviews": 320,
      "distance": 2700.0,
      "price": "\$120",
    },
    {
      "title": "Les Berges du Lac – Tunis",
      "image": "assets/image/berges_du_lac.jpg",
      "rating": 4.4,
      "reviews": 162,
      "distance": 1150.0,
      "price": "\$130",
    },
    {
      "title": "Orangers Garden – Hammamet",
      "image": "assets/image/orangers_garden.jpg",
      "rating": 4.7,
      "reviews": 190,
      "distance": 2100.0,
      "price": "\$170",
    },
    {
      "title": "Seabel Alhambra – Kantaoui",
      "image": "assets/image/seabel_alhambra.jpg",
      "rating": 4.4,
      "reviews": 210,
      "distance": 2400.0,
      "price": "\$105",
    },
    {
      "title": "Royal Thalassa – Monastir",
      "image": "assets/image/thalassa_monastir.jpg",
      "rating": 4.5,
      "reviews": 267,
      "distance": 2900.0,
      "price": "\$125",
    },
    {
      "title": "Golden Tulip – Gammarth",
      "image": "assets/image/golden_tulip.jpg",
      "rating": 4.3,
      "reviews": 143,
      "distance": 950.0,
      "price": "\$145",
    },
    {
      "title": "Palm Beach – Tozeur",
      "image": "assets/image/palm_beach_tozeur.jpg",
      "rating": 4.6,
      "reviews": 98,
      "distance": 4000.0,
      "price": "\$130",
    },
    {
      "title": "Laico – Hammamet",
      "image": "assets/image/laico_hammamet.jpg",
      "rating": 4.2,
      "reviews": 177,
      "distance": 2150.0,
      "price": "\$115",
    },
  ];

  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hôtels en Tunisie"),
        backgroundColor: Colors.blue,
        leading: Icon(Icons.hotel),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              onChanged: (value) => setState(() => searchQuery = value.toLowerCase()),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Rechercher un hôtel...",
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
              itemCount: hotels.length,
              itemBuilder: (context, index) {
                if (searchQuery.isNotEmpty &&
                    !hotels[index]["title"].toLowerCase().contains(searchQuery)) {
                  return Container();
                }
                return HotelCard(
                  imageUrl: hotels[index]["image"],
                  title: hotels[index]["title"],
                  rating: hotels[index]["rating"],
                  reviews: hotels[index]["reviews"],
                  distance: hotels[index]["distance"],
                  price: hotels[index]["price"],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class HotelCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final double rating;
  final int reviews;
  final double distance;
  final String price;

  HotelCard({
    required this.imageUrl,
    required this.title,
    required this.rating,
    required this.reviews,
    required this.distance,
    required this.price,
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
              child: Image.asset(imageUrl, fit: BoxFit.cover, width: double.infinity),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('$rating ★ ($reviews avis)'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('${distance.toStringAsFixed(0)} m • $price', style: TextStyle(color: Colors.grey[700])),
          ),
        ],
      ),
    );
  }
}
