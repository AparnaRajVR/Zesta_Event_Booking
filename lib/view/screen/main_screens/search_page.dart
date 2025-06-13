// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:z_organizer/constant/color.dart';
// // contains eventsProvider
// import 'package:z_organizer/providers/search_provider.dart'; // contains searchQueryProvider, filteredEventsProvider

// class EventSearchPage extends ConsumerWidget {
//   const EventSearchPage({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final searchController = TextEditingController(
//       text: ref.watch(searchQueryProvider),
//     );
//     final filteredEventsAsync = ref.watch(filteredEventsProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Search Events',style: TextStyle(color: AppColors.textlight,fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         backgroundColor: AppColors.primary,
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: TextField(
//               controller: searchController,
//               decoration: InputDecoration(
//                 hintText: 'Search events by name or city...',
//                 prefixIcon: const Icon(Icons.search),
//                 suffixIcon: ref.watch(searchQueryProvider).isNotEmpty
//                     ? IconButton(
//                         icon: const Icon(Icons.clear),
//                         onPressed: () {
//                           searchController.clear();
//                           ref.read(searchQueryProvider.notifier).state = '';
//                           FocusScope.of(context).unfocus();
//                         },
//                       )
//                     : null,
//               ),
//               onChanged: (query) {
//                 ref.read(searchQueryProvider.notifier).state = query;
//               },
//             ),
//           ),
//           Expanded(
//             child: filteredEventsAsync.when(
//               data: (events) {
//                 if (events.isEmpty) {
//                   return const Center(child: Text('No events found.'));
//                 }
//                 return ListView.builder(
//                   itemCount: events.length,
//                   itemBuilder: (context, index) {
//                     final event = events[index];
//                     return ListTile(
//                       leading: event.images.isNotEmpty
//                           ? Image.network(
//                               event.images.first,
//                               width: 60,
//                               height: 60,
//                               fit: BoxFit.cover,
//                             )
//                           : const Icon(Icons.event),
//                       title: Text(event.name),
//                       subtitle: Text(event.city),
//                       onTap: () {
//                         // TODO: Navigate to event details page
//                       },
//                     );
//                   },
//                 );
//               },
//               loading: () => const Center(child: CircularProgressIndicator()),
//               error: (error, _) => Center(child: Text('Error: $error')),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:z_organizer/constant/color.dart';
import 'package:z_organizer/providers/search_provider.dart';
import 'package:z_organizer/view/screen/main_screens/event_details.dart';

class EventSearchPage extends ConsumerStatefulWidget {
  const EventSearchPage({super.key});

  @override
  ConsumerState<EventSearchPage> createState() => _EventSearchPageState();
}

class _EventSearchPageState extends ConsumerState<EventSearchPage> {
  late final TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController(
      text: ref.read(searchQueryProvider),
    );
    searchController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final value = searchController.text;
    if (ref.read(searchQueryProvider) != value) {
      ref.read(searchQueryProvider.notifier).state = value;
    }
  }

  @override
  void dispose() {
    searchController.removeListener(_onTextChanged);
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredEventsAsync = ref.watch(filteredEventsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search Events',
          style: TextStyle(
            color: AppColors.textlight,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(12),
              child: TextField(
                controller: searchController,
                style: const TextStyle(color: AppColors.textlight),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
                  hintText: 'Search events by name or city...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                  suffixIcon: ref.watch(searchQueryProvider).isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: AppColors.primary),
                          onPressed: () {
                            searchController.clear();
                            ref.read(searchQueryProvider.notifier).state = '';
                            FocusScope.of(context).unfocus();
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredEventsAsync.when(
              data: (events) {
                if (events.isEmpty) {
                  return const Center(
                    child: Text(
                      'No events found.',
                      style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: event.images.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  event.images.first,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.event, color: AppColors.primary, size: 32),
                              ),
                        title: Text(
                          event.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        subtitle: Text(
                          event.city,
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        onTap: () {
                         {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EventDetailsPage(event: event,)),
        );
      }
                        },
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
              error: (error, _) => Center(
                child: Text(
                  'Error: $error',
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
