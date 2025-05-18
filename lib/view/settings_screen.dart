import 'package:flutter/material.dart';
import 'package:pcd_projet/view/chatbot_screen.dart';
import '../services/api_service.dart';
import '../widget/navbar.dart';
import '/widget/chatbot.dart';
import 'home_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Page pour modifier le profil
class EditProfilePage extends StatefulWidget {
  final String userEmail; // L'email de l'utilisateur à partir du login

  EditProfilePage({required this.userEmail});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _emailController = TextEditingController();
  bool isLoading = false;
  String userEmail = ""; // L'email de l'utilisateur actuel
  Map<String, dynamic> userProfile = {}; // Pour stocker les informations utilisateur

  // Fonction pour récupérer les informations de l'utilisateur
  Future<void> _fetchUserDetails() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Appel API pour récupérer les détails de l'utilisateur
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/users?email=${widget.userEmail}'), // Remplacer avec votre URL d'API
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          userProfile = data; // Assurez-vous que la réponse est sous forme de map
          _emailController.text = data['email'] ?? ""; // Exemple de champ
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la récupération des informations de l\'utilisateur')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de connexion: $e')),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  // Fonction pour changer l'email
  Future<void> _changeEmail() async {
    String newEmail = _emailController.text.trim();

    if (newEmail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Veuillez entrer un nouvel email")));
      return;
    }

    setState(() {
      isLoading = true;
    });

    // Appel de la méthode API pour mettre à jour l'email
    Map<String, dynamic> result = await ApiService().updateEmail(newEmail);

    setState(() {
      isLoading = false;
    });

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Email mis à jour avec succès")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'])));
    }
  }

  @override
  void initState() {
    super.initState();
    userEmail = widget.userEmail; // Récupérer l'email à partir du widget
    _fetchUserDetails(); // Appel pour charger les informations utilisateur à l'initialisation
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Changer l'email"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            isLoading
                ? Center(child: CircularProgressIndicator()) // Indicateur de chargement
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Email actuel: ${userProfile['email'] ?? 'Non disponible'}"),
                SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Nouvel email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _changeEmail,
                  child: Text("Mettre à jour l'email"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Page pour changer le mot de passe
class ChangePasswordPage extends StatelessWidget {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Changer le mot de passe'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _currentPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Mot de passe actuel'),
            ),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Nouveau mot de passe'),
            ),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Confirmer le mot de passe'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_newPasswordController.text == _confirmPasswordController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Mot de passe modifié avec succès')),
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Les mots de passe ne correspondent pas')),
                  );
                }
              },
              child: Text('Confirmer'),
            ),
          ],
        ),
      ),
    );
  }
}

// Page d'aide
class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aide'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Bienvenue sur la page d\'aide de l\'application.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Si vous avez besoin d\'assistance, veuillez contacter notre support technique.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatbotScreen()),
                );
              },
              child: Text('Ouvrir le Chatbot'),
            ),
          ],
        ),
      ),
    );
  }
}

// Page "À propos"
class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F4FF),
      appBar: AppBar(
        title: Text('À propos de l\'application'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Card(
          margin: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Guide Me',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                SizedBox(height: 20),
                Text(
                  'Guide Me est une application innovante qui aide les utilisateurs à naviguer et interagir avec différents services de manière immersive.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Text(
                  'Elle offre des fonctionnalités comme la cartographie, la réalité augmentée, un chatbot pour aider les utilisateurs, et un calendrier pour mieux organiser leurs activités.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Text(
                  'Avec Guide Me, vous pouvez trouver des itinéraires, obtenir des informations en temps réel et interagir avec des assistants virtuels pour améliorer votre expérience.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Écran des paramètres (Settings)
class SettingsScreen extends StatelessWidget {
  final String role;
  final String profileImage;
  final String userEmail;

  SettingsScreen({
    required this.role,
    required this.profileImage,
    required this.userEmail,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> settingsItems = [
      {
        "icon": Icons.person,
        "title": "Modifier le profil",
        "page": EditProfilePage(userEmail: userEmail),
      },
      {
        "icon": Icons.lock,
        "title": "Changer le mot de passe",
        "page": ChangePasswordPage(),
      },
      {
        "icon": Icons.help_outline,
        "title": "Aide",
        "page": HelpPage(),
      },
      {
        "icon": Icons.info_outline,
        "title": "À propos",
        "page": AboutPage(),
      },
    ];

    return Scaffold(
      backgroundColor: Color(0xFFF0F4FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: Text(
          "Mon compte",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
          children: [
      Container(
      padding: EdgeInsets.symmetric(vertical: 40),
      color: Colors.blue[300],
      child: Column(
        children: [
          CircleAvatar(
            radius: 45,
            backgroundImage: NetworkImage(profileImage),
            backgroundColor: Colors.white,
          ),
          SizedBox(height: 10),
          Text(
            userEmail, // Affiche l'email de l'utilisateur à la place du username
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 5),
          Text(
            role,
            style: TextStyle(fontSize: 14, color: Colors.white70),
          ),
        ],
      ),
    ),
    SizedBox(height: 20),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: settingsItems.map((item) {
                  return Column(
                    children: [
                      ListTile(
                        leading: Icon(item['icon'], color: Colors.blue),
                        title: Text(item['title'], style: TextStyle(fontSize: 16)),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => item['page']),
                          );
                        },
                      ),
                      Divider(height: 1),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
      ),
      bottomNavigationBar: navbar(selectedIndex: 3, backgroundColor: Colors.white),
    );
  }
}
