import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:z_organizer/model/event_model.dart';
import 'package:z_organizer/providers/event_provider.dart';

// Holds the current search query
final searchQueryProvider = StateProvider<String>((ref) => '');

// Filters events based on the search query
final filteredEventsProvider = Provider<List<EventModel>>((ref) {
  final eventsAsync = ref.watch(eventsProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase();

  return eventsAsync.when(
    data: (events) {
      if (query.isEmpty) return events;
      return events.where((event) {
        final name = event.name.toLowerCase() ?? '';
        final city = event.city.toLowerCase() ?? '';
        return name.contains(query) || city.contains(query);
      }).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
});
