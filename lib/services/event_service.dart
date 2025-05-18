// lib/services/event_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/event.dart';

class EventService {
  final String baseUrl = 'http://10.0.2.2:8080/events'; // Remplacez par votre URL

  Future<List<Event>> getEvents(DateTime start, DateTime end) async {
    final response = await http.get(Uri.parse(
        '$baseUrl?start=${start.toIso8601String()}&end=${end.toIso8601String()}'));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => Event.fromJson(e)).toList();
    } else {
      throw Exception('Erreur lors du chargement des événements');
    }
  }

  Future<Event> createEvent(Event event) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(event.toJson()),
    );

    if (response.statusCode == 201) {
      return Event.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create event: ${response.body}');
    }
  }

  Future<void> deleteEvent(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete event');
    }
  }
}