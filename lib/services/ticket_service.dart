import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> sellTicket(String eventId) async {
  final eventRef = FirebaseFirestore.instance.collection('events').doc(eventId);

  await FirebaseFirestore.instance.runTransaction((transaction) async {
    final snapshot = await transaction.get(eventRef);

    if (!snapshot.exists) {
      throw Exception("Event does not exist!");
    }

    final currentCount = snapshot.get('totalTickets') as int;

    if (currentCount <= 0) {
      throw Exception("Tickets sold out!");
    }

    // Decrement ticket count by 1
    transaction.update(eventRef, {
      'totalTickets': FieldValue.increment(-1),
    });
  });
}
