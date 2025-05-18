// lib/model/event.dart
class Event {
  final String? id;
  final String title;
  final String location;
  final String description;
  final DateTime startDate;
  final DateTime endDate;

  Event({
    this.id,
    required this.title,
    required this.location,
    required this.description,
    required this.startDate,
    required this.endDate,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id']?.toString(),
      title: json['title'],
      location: json['location'],
      description: json['description'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'location': location,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }
}