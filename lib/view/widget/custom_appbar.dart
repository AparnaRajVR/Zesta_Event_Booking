// import 'package:flutter/material.dart';
// import 'package:z_organizer/constant/color.dart';

// class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final String title;

//   const CustomAppBar({super.key, required this.title, required bool centerTitle});

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       leading: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Image.asset("asset/images/logo.png", height: 280),
//       ),
//       title: Text(
//         title,
//         style: const TextStyle(
//           fontSize: 20,
//           fontWeight: FontWeight.bold,
//           color: AppColors.textlight,
          
//         ),
//       ),
//       backgroundColor:AppColors.primary,
//       elevation: 4,
//       actions: [
//         IconButton(icon: const Icon(Icons.search,color:AppColors.textlight), onPressed: () {}),
//         // IconButton(icon: const Icon(Icons.settings,color:AppColors.textlight), onPressed: () {}),
//       ],
//     );
//   }

//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }
import 'package:flutter/material.dart';
import 'package:z_organizer/constant/color.dart';
import 'package:z_organizer/view/screen/main_screens/search_page.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title, required bool centerTitle});

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
          color: AppColors.textlight,
          
        ),
      ),
      backgroundColor:AppColors.primary,
      elevation: 4,
      actions: [
        IconButton(icon: const Icon(Icons.search,color:AppColors.textlight), onPressed: () {
          Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EventSearchPage()),
              );
       
        }),
        // IconButton(icon: const Icon(Icons.settings,color:AppColors.textlight), onPressed: () {}),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}