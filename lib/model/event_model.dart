

// import 'package:cloud_firestore/cloud_firestore.dart';

// class EventModel {
//   String? id;
//   String name;
//   String description;
//   String address;
//   String city;
//   final String categoryId;
//   String duration;
//   List<String> ageLimit;
//   List<String> languages;
//   DateTime? date;
//   DateTime? startTime;
//   DateTime? endTime;
//   List<String> images;
//   double ticketPrice; 

//   EventModel({
//     this.id,
//     required this.name,
//     required this.description,
//     required this.address,
//     required this.city,
//     required this.categoryId,
//     required this.duration,
//     required this.ageLimit,
//     required this.languages,
//     this.date,
//     this.startTime,
//     this.endTime,
//     this.images = const [],
//     required this.ticketPrice, 
//   });

//   // Convert to Firestore document
//   Map<String, dynamic> toFirestore() {
//     return {
//       'name': name,
//       'description': description,
//       'address': address,
//       'city': city,
//       'categoryId': categoryId,
//       'duration': duration,
//       'ageLimit': ageLimit,
//       'languages': languages,
//       'date': date?.toIso8601String(),
//       'startTime': startTime?.toIso8601String(),
//       'endTime': endTime?.toIso8601String(),
//       'images': images,
//       'ticketPrice': ticketPrice, 
//       'createdAt': FieldValue.serverTimestamp(),
//     };
//   }

//   // Create from Firestore document
//   factory EventModel.fromFirestore(DocumentSnapshot doc) {
//     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//     return EventModel(
//       id: doc.id,
//       name: data['name'] ?? '',
//       description: data['description'] ?? '',
//       address: data['address'] ?? '',
//       city: data['city'] ?? '',
//       categoryId: data['categoryId'] ?? '',
//       duration: data['duration'] ?? '',
//       ageLimit: List<String>.from(data['ageLimit'] ?? []),
//       languages: List<String>.from(data['languages'] ?? []),
//       date: data['date'] != null ? DateTime.parse(data['date']) : null,
//       startTime: data['startTime'] != null ? DateTime.parse(data['startTime']) : null,
//       endTime: data['endTime'] != null ? DateTime.parse(data['endTime']) : null,
//       images: List<String>.from(data['images'] ?? []),
//       ticketPrice: (data['ticketPrice'] as num?)?.toDouble() ?? 0.0,
//     );
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  String? id;
  String name;
  String organizerName;
  String description;
  String address;
  String city;
  final String categoryId;
  String duration;
  List<String> ageLimit;
  List<String> languages;
  DateTime? date;
  DateTime? startTime;
  DateTime? endTime;
  List<String> images;
  double ticketPrice;

  EventModel({
    this.id,
    required this.name,
    required this.organizerName,
    required this.description,
    required this.address,
    required this.city,
    required this.categoryId,
    required this.duration,
    required this.ageLimit,
    required this.languages,
    this.date,
    this.startTime,
    this.endTime,
    this.images = const [],
    required this.ticketPrice,
  });

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'organizerName': organizerName,
      'description': description,
      'address': address,
      'city': city,
      'categoryId': categoryId,
      'duration': duration,
      'ageLimit': ageLimit,
      'languages': languages,
      'date': date?.toIso8601String(),
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'images': images,
      'ticketPrice': ticketPrice,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  // Create from Firestore document
  factory EventModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return EventModel(
      id: doc.id,
      name: data['name'] ?? '',
      organizerName: data['organizerName'] ?? '',
      description: data['description'] ?? '',
      address: data['address'] ?? '',
      city: data['city'] ?? '',
      categoryId: data['categoryId'] ?? '',
      duration: data['duration'] ?? '',
      ageLimit: List<String>.from(data['ageLimit'] ?? []),
      languages: List<String>.from(data['languages'] ?? []),
      date: data['date'] != null ? DateTime.parse(data['date']) : null,
      startTime: data['startTime'] != null ? DateTime.parse(data['startTime']) : null,
      endTime: data['endTime'] != null ? DateTime.parse(data['endTime']) : null,
      images: List<String>.from(data['images'] ?? []),
      ticketPrice: (data['ticketPrice'] as num?)?.toDouble() ?? 0.0,
    );
  }
}