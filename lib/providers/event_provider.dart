import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:z_organizer/model/event_model.dart';

class EventNotifier extends StateNotifier<List<EventModel>> {
  EventNotifier() : super([]);

  void addEvent(EventModel event) {
    state = [...state, event];
  }
}

final eventProvider = StateNotifierProvider<EventNotifier, List<EventModel>>((ref) {
  return EventNotifier();
});
