
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:z_organizer/providers/cloudinary_provider.dart';

final firebaseServiceProvider = Provider((ref) => FirebaseService(ref));

class FirebaseService {
  final Ref ref;
  FirebaseService(this.ref);

  Future<List<String>> uploadImages(List<File> images) async {
    final cloudinaryService = ref.read(cloudinaryServiceProvider);
    List<String> imageUrls = [];

    for (File image in images) {
      try {
        String imageUrl = await cloudinaryService.uploadImage(image);
        imageUrls.add(imageUrl);
      } catch (e) {
        throw Exception("Image upload failed: $e");
      }
    }
    return imageUrls;
  }

  Future<void> createEvent({
    required String name,
    required  String organizerName,
    required String description,
    required String address,
    required String city,
    required String categoryId,
    required String duration,
    required List<String> ageLimit,
    required List<String> languages,
    required DateTime? date,
    required DateTime? startTime,
    DateTime? endTime, //Making this optional
    required List<String> imageUrls,
    required double ticketPrice,
  }) async {
    final firestore = FirebaseFirestore.instance;

    try {
      await firestore.collection("events").add({
        "name": name,
        "organizerName": organizerName,
        "description": description,
        "address": address,
        "city": city,
        "categoryId": categoryId,
        "duration": duration,
        "ageLimit": ageLimit,
        "languages": languages,
        "date": date?.toIso8601String(),
        "startTime": startTime?.toIso8601String(),
        "endTime": endTime?.toIso8601String(), //It can be null now
        "images": imageUrls,
        "ticketPrice": ticketPrice,
        "createdAt": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception("Failed to create event: $e");
    }
  }
}
