import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'signup_step_one_screen.dart'; // Page pour la création de compte
import 'forget_password_screen.dart'; // Page pour le mot de passe oublié
import '../home_page.dart';
import 'package:shared_preferences/shared_preferences.dart'; // à importer en haut
import 'package:shared_preferences/shared_preferences.dart';

class LogInScreen extends StatefulWidget {
  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  Future<void> saveUserType(String userType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userType', userType);
  }

  Future<void> loginUser() async {
    try {
      final url = Uri.parse('http://10.0.2.2:8080/user/login');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": _emailController.text.trim(),
          "password": _passwordController.text.trim(),
        }),
      );

      print("Réponse brute du serveur : ${response.body}");

      if (response.body.isEmpty) {
        throw FormatException("Réponse vide du serveur");
      }

      final responseBody = jsonDecode(response.body);
      print("Réponse décodée : $responseBody");

      final message = responseBody['message'] ?? 'Connexion réussie';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message, style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blue,
        ),
      );

      if (response.statusCode == 200) {
        // 🔥 Ajouter ici: stocker que c'est un "user"
        await saveUserType('user');


        // Rediriger
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    } catch (e) {
      print("Erreur lors de la connexion: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Une erreur s\'est produite lors de la connexion', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
        ),
      );
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
                      "Sign In",
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
                        labelText: "Email",
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

                    // Checkbox "Remember Me" et lien "Forgot Password"
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
                      onPressed: loginUser,

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
                          MaterialPageRoute(builder: (_) => SignupStepOneScreen()),
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
