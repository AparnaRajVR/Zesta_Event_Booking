

import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String id;
  final String name;
  final String organizerId;
  final String organizerName;
  final String description;
  final String address;
  final String city;
  final String categoryId;
  final String duration;
  final List<String> ageLimit;
  final List<String> languages;
  final DateTime? date;
  final DateTime? startTime;
  final DateTime? endTime;
  final List<String> images;
  final double ticketPrice;
  final int ticketCount;
  final int soldTickets;
  final DateTime? createdAt;

  EventModel({
    required this.id,
    required this.name,
    required this.organizerId,
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
    required this.images,
    required this.ticketPrice,
    required this.ticketCount,
    required this.soldTickets,
    this.createdAt,
  });

  factory EventModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return EventModel(
      id: doc.id,
      name: data['name'] ?? '',
      organizerId: data['organizerId'] ?? '',
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
      ticketPrice: (data['ticketPrice'] ?? 0.0).toDouble(),
      ticketCount: data['ticketCount'] ?? 0,
      soldTickets: data['soldTickets'] ?? 0,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'organizerId': organizerId,
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
      'ticketCount': ticketCount,
      'soldTickets': soldTickets,
    };
  }

  EventModel copyWith({
    String? name,
    String? organizerId,
    String? organizerName,
    String? description,
    String? address,
    String? city,
    String? categoryId,
    String? duration,
    List<String>? ageLimit,
    List<String>? languages,
    DateTime? date,
    DateTime? startTime,
    DateTime? endTime,
    List<String>? images,
    double? ticketPrice,
    int? ticketCount,
    int? soldTickets,
    DateTime? createdAt,
  }) {
    return EventModel(
      id: this.id,
      name: name ?? this.name,
      organizerId: organizerId ?? this.organizerId,
      organizerName: organizerName ?? this.organizerName,
      description: description ?? this.description,
      address: address ?? this.address,
      city: city ?? this.city,
      categoryId: categoryId ?? this.categoryId,
      duration: duration ?? this.duration,
      ageLimit: ageLimit ?? this.ageLimit,
      languages: languages ?? this.languages,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      images: images ?? this.images,
      ticketPrice: ticketPrice ?? this.ticketPrice,
      ticketCount: ticketCount ?? this.ticketCount,
      soldTickets: soldTickets ?? this.soldTickets,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
