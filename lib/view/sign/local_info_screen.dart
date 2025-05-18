import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../services/api_service.dart';
import 'upload_signed_contract_screen.dart';

class LocalInfoScreen extends StatefulWidget {
  final Map<String, String> formData;

  LocalInfoScreen({required this.formData});

  @override
  _LocalInfoScreenState createState() => _LocalInfoScreenState();
}

class _LocalInfoScreenState extends State<LocalInfoScreen> {
  String? selectedType;
  final _formKey = GlobalKey<FormState>();

  final _addressController = TextEditingController();
  final _cardNumberController = TextEditingController();

  final List<String> localTypes = [
    'Restaurant',
    'Hotel',
    'Museum',
    'Other',
  ];

  Future<void> sendFormDataToServer(Map<String, String> formData) async {
    final url = Uri.parse('https://tonserveur.com/api/save-form'); // Remplace par ton URL

    // Log the form data before sending to server
    print('Sending form data to server: $formData');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(formData),
    );

    if (response.statusCode != 200) {
      print('Failed to save data: ${response.statusCode}');
      throw Exception('Failed to save data');
    }

    print('Form data successfully sent to server.');
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
                  color: Colors.white.withOpacity(0.95),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 15,
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "Local Information",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal[800],
                            ),
                          ),
                        ),
                        SizedBox(height: 25),

                        Text("Local Type", style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.teal),
                            color: Colors.teal.shade50,
                          ),
                          child: DropdownButton<String>(
                            value: selectedType,
                            hint: Text("Select type"),
                            isExpanded: true,
                            underline: SizedBox(),
                            items: localTypes.map((String type) {
                              return DropdownMenuItem<String>(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                selectedType = value;
                                // Log when the local type is changed
                                print('Selected Local Type: $selectedType');
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 20),

                        buildTextField(
                          controller: _addressController,
                          label: "Address",
                          icon: Icons.location_on,
                        ),
                        buildTextField(
                          controller: _cardNumberController,
                          label: "Card Number",
                          icon: Icons.credit_card,
                          inputType: TextInputType.number,
                        ),
                        SizedBox(height: 25),

                        ElevatedButton.icon(
                          onPressed: () async {
                            // Log form data before sending
                            widget.formData['localType'] = selectedType ?? '';
                            widget.formData['address'] = _addressController.text;
                            widget.formData['cardNumber'] = _cardNumberController.text;

                            print('FormData before sending: ${widget.formData}');

                            try {
                              final apiService = ApiService();
                              await apiService.signUpAdmin(
                                widget.formData['firstName'] ?? '',
                                widget.formData['lastName'] ?? '',
                                int.parse(widget.formData['cin'] ?? '0'),  // si cin absent, mettre 0
                                widget.formData['email'] ?? '',
                                widget.formData['phone'] ?? '',
                                widget.formData['password'] ?? '',
                                widget.formData['address']?.isNotEmpty == true ? widget.formData['address'] : null,
                                widget.formData['cardNumber']?.isNotEmpty == true ? widget.formData['cardNumber'] : null,
                                widget.formData['localType']?.isNotEmpty == true ? widget.formData['localType'] : null,
                              );

                              // Log success and navigate to the next screen
                              print('Successfully sent form data to API');

                              // Succès -> passer à la page suivante
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UploadSignedContractScreen(
                                    localType: selectedType ?? '',
                                    address: _addressController.text,
                                    cardNumber: _cardNumberController.text,
                                  ),
                                ),
                              );
                            } catch (e) {
                              // Log error
                              print('Error sending form data: $e');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Erreur d'envoi au serveur : $e")),
                              );
                            }
                          },
                          icon: Icon(Icons.email),
                          label: Text("Send Contract by Email"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
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
        ],
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType inputType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.teal),
          filled: true,
          fillColor: Colors.teal.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
