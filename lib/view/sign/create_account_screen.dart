import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'local_info_screen.dart'; // Assure-toi que ce fichier existe bien
import '../home_page.dart';

class CreateAccountScreen extends StatefulWidget {
  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();

  final _phoneController = TextEditingController();
  final _CINController = TextEditingController();

  Map<String, String> formData = {};

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _CINController.dispose();
    _confirmpasswordController.dispose();
    super.dispose();
  }

  void saveData() {
    formData['firstName'] = _firstNameController.text.trim();  // updated to camel case
    formData['lastName'] = _lastNameController.text.trim();    // updated to camel case
    formData['email'] = _emailController.text.trim();
    formData['password'] = _passwordController.text;
    formData['phone'] = _phoneController.text.trim();  // updated to match 'phone'
    formData['cin'] = _CINController.text.trim();

    print('FormData saved: $formData');  // <-- ici le log dans la console Flutter
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Card(
                  color: Colors.white.withOpacity(0.9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Text(
                            "Admin Information",
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          buildTextField(_firstNameController, 'FirstName', validate: true),
                          buildTextField(_lastNameController, 'LastName', validate: true),
                          buildTextField(_CINController, 'CIN', validate: true),
                          buildTextField(_emailController, 'Email', validate: true),
                          buildTextField(_phoneController, 'PhoneNumber'),
                          buildTextField(_passwordController, 'Password', obscure: true, validate: true),
                          buildTextField(_confirmpasswordController, 'Confirm Password', obscure: true, validate: true),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                saveData();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => LocalInfoScreen(formData: formData)),
                                );
                              }
                            },
                            child: Text("Create Account & Continue"),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50),
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
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

  Widget buildTextField(TextEditingController controller, String label, {bool obscure = false, bool validate = false, bool isEmail = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
        validator: (value) {
          if (validate && (value == null || value.isEmpty)) {
            return '$label is required';
          }
          if (isEmail && (value == null || !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$").hasMatch(value))) {
            return 'Please enter a valid email address';
          }
          if (label == 'Confirm Password' && value != _passwordController.text) {
            return 'Passwords do not match';
          }
          return null;
        },
      ),
    );
  }
}
