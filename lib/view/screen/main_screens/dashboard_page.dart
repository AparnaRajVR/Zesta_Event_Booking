
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:z_organizer/view/screen/main_screens/add_event_page.dart';
import 'package:z_organizer/view/screen/main_screens/home_screen.dart';
import 'package:z_organizer/view/screen/main_screens/profile_page.dart';
import 'package:z_organizer/view/screen/main_screens/ticket_page.dart';
import 'package:z_organizer/view/screen/revenue_page.dart';
import 'package:z_organizer/view/widget/custom_appbar.dart';
import 'package:z_organizer/view/widget/custom_bottom_nav.dart';

final selectedTabProvider = StateProvider<int>((ref) => SelectedTab.home.index);

class Dashboard extends ConsumerWidget {
  const Dashboard({super.key});

  void _onTabSelected(WidgetRef ref, BuildContext context, SelectedTab tab) {
    if (tab == SelectedTab.add) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddEventScreen()),
      );
    } else {
      ref.read(selectedTabProvider.notifier).state = tab.index;
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
Widget build(BuildContext context, WidgetRef ref) {
  final selectedTabIndex = ref.watch(selectedTabProvider);

  const pages = [
    HomeScreen(),
    TicketPage(),
    SizedBox(),
    RevenuePage(),
    UserProfileScreen(),
  ];

  return Scaffold(
    // Show CustomAppBar only on HomeScreen (index 0)
    appBar: selectedTabIndex == 0
        ? CustomAppBar(
            title: 'Zesta',
          )
        : null,
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Show search only on HomeScreen (index 0)
          if (selectedTabIndex == 0)
            TextField(
              decoration: InputDecoration(
                hintText: 'Search events...',
                hintStyle: TextStyle(color: Colors.grey.shade600),
                prefixIcon: Icon(Icons.search, color: Colors.deepPurple.shade700),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
              onSubmitted: (value) => _showSnackBar(context, 'Searching for: $value'),
            ),
          Expanded(child: pages[selectedTabIndex]),
        ],
      ),
    ),
    bottomNavigationBar: CustomBottomNav(
      selectedTab: SelectedTab.values[selectedTabIndex],
      onTabSelected: (tab) => _onTabSelected(ref, context, tab),
    ),
  );
}
}