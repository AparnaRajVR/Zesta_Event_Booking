

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:z_organizer/model/event_model.dart';
import 'package:z_organizer/view/widget/event/delete_event.dart';
import 'event_card.dart';

class EventList extends ConsumerWidget {
  final List<EventModel> events;

  const EventList({super.key, required this.events});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 180,
      child: events.isEmpty
          ? Center(
              child: Image.asset(
                'asset/images/event_card.jpg',
                fit: BoxFit.cover,
                height: 180,
              ),
            )
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return GestureDetector(
                  onLongPress: () {
                    if (event.id != null) {
                      showDialog(
                        context: context,
                        builder: (context) => DeleteEventDialog(eventId: event.id),
                      );
                    }
                  },
                  child: EventCard(event: event),
                );
              },
            ),
    );
  }
}
