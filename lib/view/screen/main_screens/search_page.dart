import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:z_organizer/model/event_model.dart';
import 'package:z_organizer/providers/search_provider.dart';

class SearchPage extends ConsumerWidget {
  const SearchPage({super.key});
  

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = TextEditingController();
    final filteredEvents = ref.watch(filteredEventsProvider);
    final DateTime? date;


    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Events'),
      ),
      body: Column(
        children: [
          Padding(
  padding: const EdgeInsets.all(12.0),
  child: TextField(
    // Remove controller:
    // controller: searchController,
    decoration: InputDecoration(
      hintText: 'Search events...',
      prefixIcon: const Icon(Icons.search),
      suffixIcon: ref.watch(searchQueryProvider).isNotEmpty
          ? IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                ref.read(searchQueryProvider.notifier).state = '';
                FocusScope.of(context).unfocus();
              },
            )
          : null,
      filled: true,
      fillColor: Colors.grey[200],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
    onChanged: (value) =>
        ref.read(searchQueryProvider.notifier).state = value,
  ),
),

          Expanded(
            child: filteredEvents.isEmpty
                ? const Center(child: Text('No events found.'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    itemCount: filteredEvents.length,
                    itemBuilder: (context, index) {
                      final event = filteredEvents[index];
                      return EventCard(event: event);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final EventModel event;
  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Image (Use first image from images list or placeholder)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: event.images!= null && event.images!.isNotEmpty
                  ? Image.network(
                      event.images.first,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildPlaceholderImage(),
                    )
                  : _buildPlaceholderImage(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    event.city,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  // FIXED: Pass DateTime? directly, no cast needed
                  Text(
                    formatEventDate(event.date),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 100,
      height: 100,
      color: Colors.grey[300],
      child: const Icon(
        Icons.event,
        size: 40,
        color: Colors.grey,
      ),
    );
  }

  // FIXED: Accept DateTime? instead of String?
  String formatEventDate(DateTime? date) {
    if (date == null) return 'No Date';
    return DateFormat('d MMMM yyyy').format(date);
  }
}
