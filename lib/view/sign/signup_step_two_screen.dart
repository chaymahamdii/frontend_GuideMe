import 'package:flutter/material.dart';

class SignupStepTwoScreen extends StatefulWidget {
  @override
  _SignupStepTwoScreenState createState() => _SignupStepTwoScreenState();
}

class _SignupStepTwoScreenState extends State<SignupStepTwoScreen> {
  final TextEditingController addressController = TextEditingController();
  final List<String> interests = [
    "Hôtels", "Restaurants", "Sites Historiques", "Parcs", "Shopping", "Musées", "Activités Nature"
  ];
  final Set<String> selectedInterests = {};

  void toggleInterest(String interest) {
    setState(() {
      if (selectedInterests.contains(interest)) {
        selectedInterests.remove(interest);
      } else {
        selectedInterests.add(interest);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🎨 Background Image
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 10,
                  color: Colors.white.withOpacity(0.95),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Parlez-nous de vos intérêts 💡",
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        SizedBox(height: 20),

                        // 🌟 Interests Buttons
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: interests.map((interest) {
                            final isSelected = selectedInterests.contains(interest);
                            return ChoiceChip(
                              label: Text(interest),
                              selected: isSelected,
                              onSelected: (_) => toggleInterest(interest),
                              selectedColor: Colors.blueAccent,
                              backgroundColor: Colors.grey[200],
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            );
                          }).toList(),
                        ),

                        SizedBox(height: 30),
                        Text("Entrez votre adresse 📍",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: addressController,
                          decoration: InputDecoration(
                            hintText: "Ex: Avenue Habib Bourguiba, Tunis",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20),

                        // 📍 Localisation Button (à intégrer plus tard avec permission)
                        ElevatedButton.icon(
                          onPressed: () {
                            // Logique de localisation à intégrer ici si tu veux
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Localisation activée (non intégrée pour l’instant)")),
                            );
                          },
                          icon: Icon(Icons.location_on),
                          label: Text("Activer la localisation"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                        SizedBox(height: 30),

                        // ✅ Finish Button
                        ElevatedButton(
                          onPressed: () {
                            // Logique de validation
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text("Compte créé"),
                                content: Text("Merci pour votre inscription !"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("OK"),
                                  ),
                                ],
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            minimumSize: Size(double.infinity, 50),
                          ),
                          child: Text("Terminer"),
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
}
