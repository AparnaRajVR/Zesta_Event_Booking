import 'package:flutter/material.dart';
import 'package:z_organizer/constant/color.dart';
import 'package:z_organizer/model/event_model.dart';
import 'package:z_organizer/view/widget/event/event_card.dart';

class EventGridViewPage extends StatelessWidget {
  final List<EventModel> events;
  const EventGridViewPage({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Events',
            style: TextStyle(color: AppColors.textlight, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: events.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.7,
          ),
          itemBuilder: (context, index) {
            return EventCard(event: events[index]);
          },
        ),
      ),
    );
  }
}
