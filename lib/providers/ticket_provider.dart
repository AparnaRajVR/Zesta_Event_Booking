

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:z_organizer/model/ticket_model.dart';

final ticketsProvider = StreamProvider<List<Ticket>>((ref) {
  return FirebaseFirestore.instance
      .collection('tickets')
      // .where('organizerId', isEqualTo: organizerId) // Uncomment if you have organizerId
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Ticket.fromMap(doc.data())).toList());
});
// event_providers.dart or ticket_service.dart


final eventTicketCountProvider = StreamProvider.family<int, String>((ref, eventId) {
  return FirebaseFirestore.instance
      .collection('events')
      .doc(eventId)
      .snapshots()
      .map((snapshot) => snapshot.data()?['totalTickets'] ?? 0);
});
