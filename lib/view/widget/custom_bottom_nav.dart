import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:z_organizer/constant/color.dart';

enum SelectedTab { home, favorite, add, search, user }

class CustomBottomNav extends StatelessWidget {
  final SelectedTab selectedTab;
  final Function(SelectedTab) onTabSelected;

  const CustomBottomNav({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: CrystalNavigationBar(
        currentIndex: SelectedTab.values.indexOf(selectedTab),
         unselectedItemColor: AppColors.primary.withOpacity(0.7),
        backgroundColor: AppColors.bottomNavBackground,
        borderWidth: 2,
        outlineBorderColor:AppColors.bottomNavBorder,
        onTap: (index) => onTabSelected(SelectedTab.values[index]),
        items: [
          CrystalNavigationBarItem(
            icon: IconlyBold.home,
            unselectedIcon: IconlyLight.home,
            selectedColor:AppColors.bottomNavSelectedIcon
          ),
          CrystalNavigationBarItem(
            icon: IconlyBold.heart,
            unselectedIcon: IconlyLight.calendar,
            selectedColor:AppColors.bottomNavSelectedIcon
          ),
          CrystalNavigationBarItem(
            icon: IconlyBold.plus,
            unselectedIcon: IconlyLight.plus,
            selectedColor:AppColors.bottomNavSelectedIcon
          ),
          CrystalNavigationBarItem(
            icon: IconlyBold.search,
            unselectedIcon: IconlyLight.ticket,
            selectedColor:AppColors.bottomNavSelectedIcon
          ),
          CrystalNavigationBarItem(
            icon: IconlyBold.user_2,
            unselectedIcon: IconlyLight.chart,
            selectedColor:AppColors.bottomNavSelectedIcon
          ),
        ],
      ),
    );
  }
}

