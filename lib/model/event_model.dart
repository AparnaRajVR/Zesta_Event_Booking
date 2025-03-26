class EventModel {
  final String id;
  final String name;
  final String description;
  final DateTime date;
  final List<String> images;

  EventModel({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.images,
  });
}
