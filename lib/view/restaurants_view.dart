import 'package:flutter/material.dart';

class RestaurantsView extends StatefulWidget {
  @override
  _RestaurantsViewState createState() => _RestaurantsViewState();
}

class _RestaurantsViewState extends State<RestaurantsView> {
  final List<Map<String, String>> allRestaurants = [
    {
      "name": "Dar Zarrouk",
      "address": "Sidi Bou Said, Tunis",
      "image": "assets/image/Darzarrouk.jpg",
    {

  ];

  List<Map<String, String>> filteredRestaurants = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredRestaurants = allRestaurants;
    searchController.addListener(_filterRestaurants);
  }

  void _filterRestaurants() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredRestaurants = allRestaurants.where((restaurant) {
        final name = restaurant["name"]!.toLowerCase();
        final address = restaurant["address"]!.toLowerCase();
        return name.contains(query) || address.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Restaurants en Tunisie"),
        backgroundColor: Colors.deepOrange,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Rechercher un restaurant...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredRestaurants.length,
              padding: EdgeInsets.symmetric(horizontal: 10),
              itemBuilder: (context, index) {
                final restaurant = filteredRestaurants[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                        child: Image.network(
                          restaurant["image"]!,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      ListTile(
                        title: Text(restaurant["name"]!, style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(restaurant["address"]!),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                                SizedBox(width: 4),
                                Text("Ouvert : 09h00 - 00h00", style: TextStyle(fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
