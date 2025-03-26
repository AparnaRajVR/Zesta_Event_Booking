import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:z_organizer/providers/event_provider.dart';

class EventCarousel extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(eventProvider);

    return events.isEmpty
        ? Center(child: Text("No Events Added"))
        : CarouselSlider(
            options: CarouselOptions(height: 200.0),
            items: events.map((event) {
              return Container(
                margin: EdgeInsets.all(5.0),
                child: Image.network(event.images.isNotEmpty ? event.images.first : 'placeholder_image_url'),
              );
            }).toList(),
          );
  }
}
