import 'package:flutter/material.dart';
import 'package:pcd_projet/view/category_view.dart';
import 'package:pcd_projet/view/settings_screen.dart';
import 'package:pcd_projet/widget/catalogue_widget.dart';
import '/view/home_page.dart';

import '/view/settings_screen.dart';

import '/view/sign/welcome_page.dart';


class navbar extends StatelessWidget {
  final int selectedIndex;
  final Color backgroundColor;

  navbar({
    required this.selectedIndex,
    required this.backgroundColor,
  });

  void _navigateToScreen(BuildContext context, int index) {
    Widget nextScreen;

    switch (index) {
      case 0:
        nextScreen = HomePage();
        break;
      case 1:
        nextScreen = CategoryView();
        break;
      case 2:
        nextScreen = WelcomePage();
        break;
      case 3:
        nextScreen = SettingsScreen(
          role: "Admin",  // Par exemple, rôle de l'utilisateur
          profileImage: "https://example.com/image.jpg",  // L'image du profil
          userEmail: "johndoe@example.com",  // Email de l'utilisateur
        );
        break;
      default:
        nextScreen = HomePage();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.home, color: selectedIndex == 0 ? Colors.white : Colors.grey),
            onPressed: () => _navigateToScreen(context, 0),
          ),
          IconButton(
            icon: Icon(Icons.category, color: selectedIndex == 1 ? Colors.white : Colors.grey),
            onPressed: () => _navigateToScreen(context, 1),
          ),
          IconButton(
            icon: Icon(Icons.login, color: selectedIndex == 2 ? Colors.white : Colors.grey),
            onPressed: () => _navigateToScreen(context, 2),
          ),
          IconButton(
            icon: Icon(Icons.settings, color: selectedIndex == 3 ? Colors.white : Colors.grey),
            onPressed: () => _navigateToScreen(context, 3),
          ),
        ],
      ),
    );
  }
}
