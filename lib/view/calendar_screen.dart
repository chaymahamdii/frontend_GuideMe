import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../model/Event.dart';
import '../services/event_service.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  bool isAdmin = false;
  final EventService _eventService = EventService();
  // Contrôleurs pour le formulaire
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _lieuController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _dateDebut;
  DateTime? _dateFin;
  List<Event> _events = [];

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
    _dateDebut = _focusedDay;
    _dateFin = _focusedDay;
    _checkAdminStatus();
    _fetchEventsFromBackend(); // ⬅️ appel du backend
  }

  Future<void> _fetchEventsFromBackend() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8080/events?start=2025-01-01T00:00:00&end=2025-12-31T23:59:59'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _events = data.map((json) => Event.fromJson(json)).toList();
        });
      } else {
        print('Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur de chargement des événements: $e');
    }
  }

  List<Event> get _eventsForSelectedDay {
    return _events.where((event) {
      return event.startDate.year == _selectedDay!.year &&
          event.startDate.month == _selectedDay!.month &&
          event.startDate.day == _selectedDay!.day;
    }).toList();
  }

  Future<void> _checkAdminStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isAdmin = prefs.getString('userType') == 'admin';
    });
  }

  void _openEventForm() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Ajouter un événement'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _nomController,
                    decoration: InputDecoration(
                      labelText: 'Nom de l\'événement',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _lieuController,
                    decoration: InputDecoration(
                      labelText: 'Lieu',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  ListTile(
                    title: Text('Date de début: ${_dateDebut != null ? DateFormat('dd/MM/yyyy').format(_dateDebut!) : 'Non définie'}'),
                    trailing: Icon(Icons.calendar_today),
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _dateDebut ?? DateTime.now(),
                        firstDate: DateTime(2025),
                        lastDate: DateTime(2026),
                      );
                      if (picked != null && picked != _dateDebut) {
                        setState(() => _dateDebut = picked);
                      }
                    },
                  ),
                  ListTile(
                    title: Text('Date de fin: ${_dateFin != null ? DateFormat('dd/MM/yyyy').format(_dateFin!) : 'Non définie'}'),
                    trailing: Icon(Icons.calendar_today),
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _dateFin ?? DateTime.now(),
                        firstDate: DateTime(2025),
                        lastDate: DateTime(2026),
                      );
                      if (picked != null && picked != _dateFin) {
                        setState(() => _dateFin = picked);
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Annuler'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_validateForm()) {
                    _addEvent();
                    Navigator.pop(context);
                  }
                },
                child: Text('Enregistrer'),
              ),
            ],
          );
        },
      ),
    );
  }

  bool _validateForm() {
    if (_nomController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez entrer un nom pour l\'événement')),
      );
      return false;
    }
    if (_dateDebut == null || _dateFin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez sélectionner les dates')),
      );
      return false;
    }
    if (_dateDebut!.isAfter(_dateFin!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('La date de fin doit être après la date de début')),
      );
      return false;
    }
    return true;
  }

  Future<void> _addEvent() async {
    try {
      // Vérifier que les dates sont valides
      if (_dateDebut == null || _dateFin == null) {
        throw Exception('Les dates doivent être définies');
      }

      // Créer l'objet Event pour l'API
      final newEvent = {
        'title': _nomController.text,  // Utilisez 'title' au lieu de 'nom' pour correspondre à votre modèle Spring
        'location': _lieuController.text, // 'location' au lieu de 'lieu'
        'description': _descriptionController.text,
        'startDate': _dateDebut!.toIso8601String(), // Format ISO 8601
        'endDate': _dateFin!.toIso8601String(),
      };

      // Appel à l'API pour ajouter l'événement
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/events'), // Remplacez par votre URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(newEvent),
      );

      if (response.statusCode == 201) {
        // Succès
        final createdEvent = jsonDecode(response.body);
        print('Événement créé: $createdEvent');

        // Appeler _fetchEventsFromBackend pour récupérer la liste des événements mise à jour
        await _fetchEventsFromBackend();

        // Afficher un message de succès
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Événement créé avec succès!')),
        );
      } else {
        // Erreur serveur
        throw Exception('Erreur ${response.statusCode}: ${response.body}');
      }

      // Réinitialiser les champs du formulaire
      _nomController.clear();
      _lieuController.clear();
      _descriptionController.clear();
      _dateDebut = _focusedDay;
      _dateFin = _focusedDay;
    } catch (e) {
      print('Erreur lors de la création: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Échec de la création: ${e.toString()}')),
      );
    }
  }


  @override
  void dispose() {
    _nomController.dispose();
    _lieuController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calendrier 2025"),
        backgroundColor: Colors.blueAccent,
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
        onPressed: _openEventForm,
        child: Icon(Icons.add),
        tooltip: 'Ajouter un événement',
      )
          : null,
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2025, 1, 1),
            lastDay: DateTime(2025, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            headerStyle: HeaderStyle(
              formatButtonVisible: true,
              titleCentered: true,
            ),
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Événements pour ${DateFormat('dd/MM/yyyy').format(_selectedDay!)}',
            style: TextStyle(fontSize: 18),
          ),
          Expanded(
            child: _eventsForSelectedDay.isEmpty
                ? Center(child: Text("Aucun événement pour ce jour."))
                : ListView.builder(
              itemCount: _eventsForSelectedDay.length,
              itemBuilder: (context, index) {
                final event = _eventsForSelectedDay[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(event.title),
                    subtitle: Text(
                        '${DateFormat('HH:mm').format(event.startDate)} - ${event.location}'
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
