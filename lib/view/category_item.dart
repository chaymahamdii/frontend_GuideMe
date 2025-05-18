import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final String title;
  final String image;
  final VoidCallback onTap;

  CategoryItem({required this.title, required this.image, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Expanded(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(image),
              fit: BoxFit.cover,
            ),
          ),
          alignment: Alignment.center,
          child: Container(
            color: Colors.black54,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
