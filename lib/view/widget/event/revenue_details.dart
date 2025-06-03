// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:z_organizer/providers/ticket_provider.dart';

// class EventRevenueDetailPage extends ConsumerWidget {
//   final String eventId;
//   final String eventName;

//   const EventRevenueDetailPage({
//     super.key,
//     required this.eventId,
//     required this.eventName,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final ticketsAsync = ref.watch(ticketsByEventProvider(eventId));

//     return Scaffold(
//       appBar: AppBar(title: Text('$eventName - Ticket Details')),
//       body: ticketsAsync.when(
//         data: (tickets) {
//           if (tickets.isEmpty) {
//             return const Center(child: Text('No tickets sold yet.'));
//           }
//           return ListView.builder(
//             itemCount: tickets.length,
//             itemBuilder: (context, index) {
//               final ticket = tickets[index];
//               return ListTile(
//                 title: Text('Buyer: ${ticket['buyerName'] ?? 'Unknown'}'),
//                 subtitle: Text(
//                   'Ticket Count: ${ticket['ticketCount']}\n'
//                   'Amount Paid: ₹${ticket['amountPaid']}',
//                 ),
//               );
//             },
//           );
//         },
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (err, stack) => Center(child: Text('Error: $err')),
//       ),
//     );
//   }
// }
