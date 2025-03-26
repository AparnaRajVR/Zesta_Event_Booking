

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:z_organizer/providers/event_provider.dart';
// import 'package:z_organizer/view/screen/main_screens/add_event_page.dart';
// import 'package:z_organizer/view/screen/main_screens/analytics_page.dart';
// import 'package:z_organizer/view/screen/main_screens/ticket_page.dart';
// import 'package:z_organizer/view/widget/custom_appbar.dart';
// import 'package:z_organizer/view/widget/custom_bottom_nav.dart';
// import 'package:carousel_slider/carousel_slider.dart';



// class Dashboard extends ConsumerStatefulWidget {
//   const Dashboard({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _DashboardState createState() => _DashboardState();
// }

// class _DashboardState extends ConsumerState<Dashboard> {
//   int _selectedIndex = 0;

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final eventService = ref.watch(eventServiceProvider);
//     final featuredEvents = eventService.getFeaturedEvents();
//     final upcomingEvents = eventService.getUpcomingEvents();

//     // List of pages (keeping Dashboard UI for Home)
//     final List<Widget> _pages = [
//       _buildHomeScreen(featuredEvents, upcomingEvents), 
//       TicketPage(),
//      CreateEventPage(),
//      AnalyticsPage()
      
//     ];

//     return Scaffold(
//       appBar:  const CustomAppBar(title: "Home"),
//       bottomNavigationBar: CustomBottomNav(
//         selectedTab: SelectedTab.values[_selectedIndex],
//         onTabSelected: (SelectedTab tab) {
//           _onItemTapped(SelectedTab.values.indexOf(tab));
//         },
//       ),
//       body: _pages[_selectedIndex], // Switches content based on tab
//     );
//   }

//   // Home Screen UI (Dashboard)
//   Widget _buildHomeScreen(List<String> featuredEvents, List<String> upcomingEvents) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: TextField(
//             decoration: InputDecoration(
//               hintText: 'Discover and manage your events',
//               prefixIcon: Icon(Icons.search),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(10.0)),
//               ),
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Text(
//             'Featured Events',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//         ),
//         CarouselSlider(
//           options: CarouselOptions(height: 200, autoPlay: true),
//           items: featuredEvents.map((image) {
//             return Container(
//               margin: EdgeInsets.all(5),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
//               ),
//             );
//           }).toList(),
//         ),
//         Expanded(
//           child: ListView(
//             scrollDirection: Axis.horizontal,
//             children: upcomingEvents.map((event) => _eventCard(event)).toList(),
//           ),
//         ),
//       ],
//     );
//   }

//   // Event Card Widget
//   Widget _eventCard(String eventName) {
//     return Container(
//       width: 120,
//       height: 90,
//       margin: EdgeInsets.fromLTRB(10, 50, 10, 10),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         color: Colors.purple[100],
//       ),
//       child: Center(child: Text(eventName, style: TextStyle(fontWeight: FontWeight.bold))),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:z_organizer/view/screen/main_screens/add_event_page.dart';
import 'package:z_organizer/view/screen/main_screens/analytics_page.dart';
import 'package:z_organizer/view/screen/main_screens/ticket_page.dart';
import 'package:z_organizer/view/widget/custom_bottom_nav.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  SelectedTab _selectedTab = SelectedTab.home;

  void _onTabSelected(SelectedTab tab) {
    if (tab == SelectedTab.add) {
      // Open Add Event Page Instead of Changing Tab
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddEventScreen()),
      );
    } else {
      setState(() {
        _selectedTab = tab;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Pages Based on Selected Tab
    final List<Widget> pages = [
      Center(child: Text("Home Screen")), // Replace with actual Home UI
      TicketPage(),
      Container(), // Placeholder (Add Event handled separately)
      AnalyticsPage(),
      Center(child: Text("User Profile")),
    ];

    return Scaffold(
      body: pages[_selectedTab.index],
      bottomNavigationBar: CustomBottomNav(
        selectedTab: _selectedTab,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}
