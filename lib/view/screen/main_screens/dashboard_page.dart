
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:z_organizer/view/screen/main_screens/add_event_page.dart';
import 'package:z_organizer/view/screen/main_screens/analytics_page.dart';
import 'package:z_organizer/view/screen/main_screens/ticket_page.dart';
import 'package:z_organizer/view/widget/custom_bottom_nav.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends ConsumerState<Dashboard> {
  SelectedTab _selectedTab = SelectedTab.home;

  void _onTabSelected(SelectedTab tab) {
    if (tab == SelectedTab.add) {
      // Open Add Event Page Instead of Changing Tab
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddEventScreen()) 
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
      Center(child: Text("Home Screen")), 
      TicketPage(),
      Container(), 
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
