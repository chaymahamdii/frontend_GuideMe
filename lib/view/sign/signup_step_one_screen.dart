import 'package:flutter/material.dart';
import 'signup_step_two_screen.dart';
import '../../services/api_service.dart';

class SignupStepOneScreen extends StatefulWidget {
  @override
  _SignupStepOneScreenState createState() => _SignupStepOneScreenState();
}

class _SignupStepOneScreenState extends State<SignupStepOneScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();

  final ApiService apiService = ApiService();

  Future<void> _handleSignUp() async {
    if (_passwordController.text != _confirmpasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Les mots de passe ne correspondent pas')),
      );
      return;
    }

    try {
      final response = await apiService.signUpUser(
        _firstNameController.text,
        _lastNameController.text,
        _emailController.text,
        _passwordController.text,
      );

      if (mounted) {
        final message = response['message'] ?? '';
        print('Message reçu: $message');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );

        if (message.toLowerCase().contains('successfully') ||
            message.toLowerCase().contains('réussie')) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => SignupStepTwoScreen()),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/image/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SingleChildScrollView(
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 10,
                  color: Colors.white.withOpacity(0.9),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Text("Create Account", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                          SizedBox(height: 20),
                          buildTextField("First Name", _firstNameController),
                          SizedBox(height: 10),
                          buildTextField("Last Name", _lastNameController),
                          SizedBox(height: 10),
                          buildTextField("Email", _emailController),
                          SizedBox(height: 10),
                          buildTextField("Password", _passwordController, isPassword: true),
                          SizedBox(height: 10),
                          buildTextField("Confirm Password", _confirmpasswordController, isPassword: true),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await _handleSignUp();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              minimumSize: Size(double.infinity, 50),
                            ),
                            child: Text("Next"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      ),
      validator: (value) => value == null || value.isEmpty ? "Champ requis" : null,
    );
  }
}
