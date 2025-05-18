import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  // Base URL de votre API backend. Utilisez l'adresse IP de votre machine si vous êtes sur un appareil physique ou un émulateur.
  final String _baseUrl = 'http://10.0.2.2:8080'; // 10.0.2.2 pour émulateur Android, adresse IP pour un appareil physique.

  // Méthode pour l'inscription
  Future<Map<String, dynamic>> signUpUser(String firstname, String lastname,
      String email, String password) async {
    final url = Uri.parse(
        '$_baseUrl/user/signup'); // URL de l'API d'inscription

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'first_name': firstname,
          'last_name': lastname,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // Si l'inscription réussie, retourne la réponse
        return jsonDecode(response.body);
      } else {
        // Si l'API retourne une erreur, lance une exception
        throw Exception('Échec de l\'inscription: ${response.statusCode}');
      }
    } catch (e) {
      // Si une exception se produit (ex. pas de connexion au backend)
      throw Exception('Erreur de connexion: $e');
    }
  }

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/user/login'),
      // remplace localhost si nécessaire
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return {'success': true, 'message': jsonDecode(response.body)};
    } else {
      return {'success': false, 'message': jsonDecode(response.body)};
    }
  }

  Future<Map<String, dynamic>> signUpAdmin(
      String firstName,
      String lastName,
      int cin,
      String email,
      String phone,
      String password,
      String? address,      // <-- autoriser null
      String? cardNumber,   // <-- autoriser null
      String? localType,    // <-- autoriser null
      ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/administrator/signup'),
        headers: {
          HttpHeaders.contentTypeHeader: "multipart/form-data",
        },

        body: json.encode({
        'adress': address,       // Peut être null
        'card_number': cardNumber,  // Peut être null
        'cin': cin,
        'email': email,

        'first_name': firstName,
        'last_name': lastName,
        'local_type': localType,   // Peut être null
        'password': password,

        'phone_number': phone,
        'connected': 'non',
      }),
    );

    return json.decode(response.body);
  }


  Future<Map<String, dynamic>> loginAdmin(String email, String password) async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/administrator/login'),
      // remplace localhost si nécessaire
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return {'success': true, 'message': jsonDecode(response.body)};
    } else {
      return {'success': false, 'message': jsonDecode(response.body)};
    }
  }
  Future<Map<String, dynamic>> updateEmail( String newEmail) async {
    final url = Uri.parse('$_baseUrl/administrator/update/email/$newEmail'); // URL de l'API de mise à jour de l'email

    try {
      final response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': newEmail,  // Nouvel email
        }),
      );

      if (response.statusCode == 200) {
        // Si la mise à jour réussie, retourne la réponse
        return {'success': true, 'message': jsonDecode(response.body)};
      } else {
        // Si l'API retourne une erreur, lance une exception
        return {'success': false, 'message': 'Échec de la mise à jour de l\'email'};
      }
    } catch (e) {
      // Si une exception se produit (par exemple, pas de connexion au backend)
      return {'success': false, 'message': 'Erreur de connexion: $e'};
    }
  }
// 1. Créer un événement
  Future<Map<String, dynamic>> createEvent(String title, DateTime date) async {
    final url = Uri.parse('$_baseUrl/events');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': title,
          'date': date.toIso8601String(), // Transformer DateTime en String ISO
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'message': jsonDecode(response.body)};
      } else {
        return {'success': false, 'message': 'Erreur lors de la création de l\'événement'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Erreur de connexion: $e'};
    }
  }

// 2. Récupérer tous les événements
  Future<List<dynamic>> fetchEvents() async {
    final url = Uri.parse('$_baseUrl/events');

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Erreur lors du chargement des événements');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

// 3. Supprimer un événement
  Future<Map<String, dynamic>> deleteEvent(int eventId) async {
    final url = Uri.parse('$_baseUrl/events/$eventId');

    try {
      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Événement supprimé'};
      } else {
        return {'success': false, 'message': 'Échec de la suppression de l\'événement'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Erreur de connexion: $e'};
    }
  }

// 4. (Optionnel) Mettre à jour un événement
  Future<Map<String, dynamic>> updateEvent(int eventId, String newTitle, DateTime newDate) async {
    final url = Uri.parse('$_baseUrl/events/$eventId');

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': newTitle,
          'date': newDate.toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': jsonDecode(response.body)};
      } else {
        return {'success': false, 'message': 'Échec de la mise à jour de l\'événement'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Erreur de connexion: $e'};
    }
  }
  static Future<String> sendMessageToChatbot(String text) async {
    final url = Uri.parse('http://10.0.2.2:5000/chatbot?langue=fr'); // Vérifie ton adresse IP si tu es sur un vrai téléphone
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({"message": text}),
    );

    print("Status Code: ${response.statusCode}");  // Imprime le status code
    print("Response Body: ${response.body}");  // Imprime la réponse brute

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse["message"];  // Vérifie si le message existe
    } else {
      throw Exception('Erreur serveur (${response.statusCode})');
    }
  }
  }




