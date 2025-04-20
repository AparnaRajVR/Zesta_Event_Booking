import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:z_organizer/model/event_model.dart';
import 'carousel_item.dart';

class EventCarousel extends StatelessWidget {
  final List<EventModel> events;

  const EventCarousel({Key? key, required this.events}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final featuredEvents = events.take(4).toList();
    return CarouselSlider(
      options: CarouselOptions(
        height: 280,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        autoPlayInterval: const Duration(seconds: 3),
        viewportFraction: 0.85,
      ),
      items: featuredEvents.isEmpty
          ? [_buildEmptyCarouselItem(context)]
          : featuredEvents.map((event) => CarouselItem(event: event)).toList(),
    );
  }

  Widget _buildEmptyCarouselItem(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey.shade200,
      ),
      child: Center(
        child: Text(
          'No events available',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}