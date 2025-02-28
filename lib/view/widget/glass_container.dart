// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';

class GlassEffect extends StatelessWidget {
  final Widget child;
  final double blurSigmaX;
  final double blurSigmaY;
  final BorderRadius? borderRadius;

  const GlassEffect({
    required this.child,
    this.blurSigmaX = 10.0,
    this.blurSigmaY = 10.0,
    this.borderRadius,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigmaX, sigmaY: blurSigmaY),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: borderRadius ?? BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
