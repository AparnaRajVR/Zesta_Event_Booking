
// import 'package:flutter/material.dart';

// class AppColors{

//   static const Color primary = Colors.purple;
  // static const Color second =  Color.fromARGB(255, 153, 76, 167);
//   static const Color accent = Color(0xFFFFA726);
//   static const Color textlight  = Colors.white;
//   static const Color textdark = Colors.black;
//   static const Color textaddn = Colors.grey;
  
// }




import 'package:flutter/material.dart';

class AppColors {
  // Primary color palette
  // static const Color primary = Color(0xFF6B46C1); 
   static const Color primary =Color.fromARGB(255, 153, 76, 167);
  static const Color secondary = Color(0xFF4FD1C5); 
  static const Color background = Colors.white;
  static const Color appbar = Colors.deepPurple;
   

  // Bottom Navigation Colors
  static final Color bottomNavBackground = Colors.black.withOpacity(0.1);
  static final Color bottomNavBorder = Colors.white.withOpacity(0.5);
  static final Color bottomNavSelectedIcon = Colors.white;
  

  // Text Colors
  static const Color darkText = Color(0xFF2D3748);
  static const Color lightText = Colors.white;

  // Accent Colors
  static const Color success = Color(0xFF48BB78);
  static const Color error = Color(0xFFE53E3E);
  static const Color warning = Color(0xFFFFC107);

  // Gradient Colors
  static final LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}