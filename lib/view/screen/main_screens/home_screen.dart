
// import 'package:flutter/material.dart';
// import 'package:z_organizer/view/widget/event_card.dart';

// class HomeScreen extends StatelessWidget {
//   final List<EventModel> featuredEvents;
//   final List<EventModel> upcomingEvents;

//   const HomeScreen({required this.featuredEvents, required this.upcomingEvents, Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: TextField(
//             decoration: InputDecoration(
//               hintText: 'Discover and manage your events',
//               prefixIcon: Icon(Icons.search),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(10.0)),
//               ),
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Text(
//             'Featured Events',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//         ),
//         CustomCarousel(events: featuredEvents),
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Text(
//             'Upcoming Events',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//         ),
//         Expanded(
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: upcomingEvents.length,
//             itemBuilder: (context, index) {
//               final event = upcomingEvents[index];
//               return EventCard(event: event);
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
