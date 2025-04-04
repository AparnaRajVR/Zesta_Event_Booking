import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  String? id;
  String name;
  String description;
  String address;
  String city;
  DateTime? date;
  DateTime? startTime;
  DateTime? endTime;
  List<String> images;

  EventModel({
    this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.city,
    this.date,
    this.startTime,
    this.endTime,
    this.images = const [],
  });

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'address': address,
      'city': city,
      'date': date?.toIso8601String(),
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'images': images,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  // Create from Firestore document
  factory EventModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return EventModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      address: data['address'] ?? '',
      city: data['city'] ?? '',
      date: data['date'] != null ? DateTime.parse(data['date']) : null,
      startTime: data['startTime'] != null ? DateTime.parse(data['startTime']) : null,
      endTime: data['endTime'] != null ? DateTime.parse(data['endTime']) : null,
      images: List<String>.from(data['images'] ?? []),
    );
  }
}