// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:z_organizer/constant/color.dart';
// import 'package:z_organizer/providers/event_provider.dart';
// import 'package:z_organizer/view/widget/event/event_carousel.dart';
// import 'package:z_organizer/view/widget/event/event_list.dart';

// class HomeScreen extends ConsumerWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Scaffold(
//       body: Container(
//         decoration: _gradientDecoration(),
//         child: ref.watch(eventsProvider).when(
//               data: (events) => CustomScrollView(
//                 slivers: [
//                   SliverPadding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
//                     sliver: SliverToBoxAdapter(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Featured Events',
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.deepPurple.shade700,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           EventCarousel(events: events),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SliverPadding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                     sliver: SliverToBoxAdapter(
//                       child: Text(
//                         'All Events',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.deepPurple.shade700,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SliverToBoxAdapter(child: SizedBox(height: 8)),
//                   SliverPadding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                     sliver: SliverFillRemaining(
//                       hasScrollBody: true,
//                       child: EventList(events: events),
//                     ),
//                   ),
//                 ],
//               ),
//               loading: () => const Center(child: CircularProgressIndicator()),
//               error: (error, _) => Center(
//                 child: Text(
//                   'Failed to load events: $error',
//                   style: const TextStyle(color: AppColors.error, fontSize: 16),
//                 ),
//               ),
//             ),
//       ),
//     );
//   }

//   BoxDecoration _gradientDecoration() {
//     return BoxDecoration(
//       gradient: LinearGradient(
//         begin: Alignment.topCenter,
//         end: Alignment.bottomCenter,
//         colors: [
//           AppColors.background,
//           Colors.deepPurple,
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:z_organizer/constant/color.dart';
import 'package:z_organizer/providers/event_provider.dart';
import 'package:z_organizer/view/screen/main_screens/event_grid_view.dart';
import 'package:z_organizer/view/widget/event/event_carousel.dart';
import 'package:z_organizer/view/widget/event/event_list.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        decoration: _gradientDecoration(),
        child: ref.watch(eventsProvider).when(
              data: (events) => CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 16.0),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Featured Events',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple.shade700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          EventCarousel(events: events),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'All Events',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple.shade700,
                            ),
                          ),
                          Text(
                            'See All',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        EventGridViewPage(events: events)),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 8)),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    sliver: SliverFillRemaining(
                      hasScrollBody: true,
                      child: EventList(events: events),
                    ),
                  ),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Text(
                  'Failed to load events: $error',
                  style: const TextStyle(color: AppColors.error, fontSize: 16),
                ),
              ),
            ),
      ),
    );
  }

  BoxDecoration _gradientDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.background,
          Colors.deepPurple,
        ],
      ),
    );
  }
}
