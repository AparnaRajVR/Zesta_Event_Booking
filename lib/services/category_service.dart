import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryService {
  final CollectionReference _categoryCollection =
      FirebaseFirestore.instance.collection('event_categories');


  Stream<List<Map<String, dynamic>>> getCategories() {
    return _categoryCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => {'id': doc.id, 'name': doc['name']})
          .toList();
    });
  }
}