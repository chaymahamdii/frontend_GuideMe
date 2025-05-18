import 'dart:convert';

import 'package:http/http.dart' as http;

import '../home_page.dart';
import '../settings_screen.dart';
import 'forget_password_screen.dart'; // Page pour le mot de passe oublié
import 'package:flutter/material.dart';
import 'create_account_screen.dart'; // Page pour la création de compte
import 'package:shared_preferences/shared_preferences.dart';


class AdminLoginScreen extends StatefulWidget {
  @override
  _AdminLoginScreenState createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  Future<void> saveUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userType', 'admin'); // Toujours 'admin' pour ce screen
    await prefs.setString('userEmail', _emailController.text.trim());

  }
  Future<bool> loginAdmin() async {
    final url = Uri.parse('http://10.0.2.2:8080/administrator/login');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": _emailController.text.trim(),
          "password": _passwordController.text.trim(),
        }),
      );

      // Afficher le corps brut de la réponse pour le débogage
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {

        try {
          final responseBody = jsonDecode(response.body);
          final message = responseBody['message'] ?? 'An unknown error occurred';

          if (!mounted) return false;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                message,
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.blue,
            ),
          );

          return true; // Connexion réussie
        } catch (e) {
          print("Error decoding JSON: $e");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Invalid response format from server'),
              backgroundColor: Colors.red,
            ),
          );
          return false; // Erreur de décodage JSON
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
    } catch (e) {
      print("Error during HTTP request: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
      return false; // Erreur de requête HTTP
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Image de fond
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/image/background.jpg"), // Assure-toi que l'image est dans le bon dossier
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Formulaire de connexion
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Titre
                    Text(
                      "Admin Sign In",  // Titre spécifique à la connexion admin
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 30),

                    // Champ Email
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "Admin Email",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Champ Mot de passe
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),

                    // Case "Remember Me" et lien "Forgot Password"
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (val) {
                            setState(() {
                              _rememberMe = val!;
                            });
                          },
                        ),
                        Text("Remember Me", style: TextStyle(color: Colors.black)),
                        Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => ForgetPasswordScreen()),
                            );
                          },
                          child: Text("Forget Password?", style: TextStyle(color: Colors.black)),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Bouton "Log In"
                      ElevatedButton(
                          onPressed: () async {
                          bool isLoggedIn = await loginAdmin();
                          if (isLoggedIn) {
                              await saveUserType(); // Sauvegarde automatique comme admin
                              print('type admin');
                              Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                              builder: (context) => HomePage(),
                          ),
                      );
                      }
                      },
                      child: Text("Log In"),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Lien pour créer un compte
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => CreateAccountScreen()),
                        );
                      },
                      child: Text(
                        "Don't have an account? Create account",
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
