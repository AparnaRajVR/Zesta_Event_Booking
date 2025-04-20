import 'package:flutter/material.dart';
import 'package:z_organizer/model/event_model.dart';
import 'event_card.dart';

class EventList extends StatelessWidget {
  final List<EventModel> events;

  const EventList({Key? key, required this.events}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: events.isEmpty
          ? Center(
              child: Text(
                'No events available',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                ),
              ),
            )
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return EventCard(event: event);
              },
            ),
    );
  }
}