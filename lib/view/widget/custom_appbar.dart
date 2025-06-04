import 'package:flutter/material.dart';
import 'package:z_organizer/constant/color.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset("asset/images/logo.png", height: 60),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.lightText
        ),
      ),
      backgroundColor:AppColors.appbar,
      elevation: 4,
      actions: [
        // IconButton(icon: const Icon(Icons.notifications,color:AppColors.lightText), onPressed: () {}),
        // IconButton(icon: const Icon(Icons.settings,color:AppColors.lightText), onPressed: () {}),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
