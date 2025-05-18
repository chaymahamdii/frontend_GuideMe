import 'package:flutter/material.dart';
import 'package:pcd_projet/view/home_page.dart';
import 'package:pcd_projet/view/musee.dart';
import 'category_item.dart';
import 'hotels_view.dart';
import 'restaurants_view.dart';

class CategoryView extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {"title": "HOTELS", "image": "assets/image/hotel.jpg", "route": HotelsView()},
    {"title": "MUSEUMS", "image": "assets/image/musee.jpg", "route":  MuseumsView()},
    {"title": "RESTAURANTS", "image": "assets/image/beach.jpg", "route": RestaurantsView()},
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Categories"),
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Account'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => categories[index]["route"]),
              );
            },
            child: Container(
              width: screenWidth * 0.9,
              height: screenHeight * 0.25,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: AssetImage(categories[index]["image"]),
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                categories[index]["title"],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  backgroundColor: Colors.black54,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}