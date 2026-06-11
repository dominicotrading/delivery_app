import 'package:flutter/material.dart';
import 'package:marocsie/app/utils/sizes.dart';

class AppLogo extends StatelessWidget {
  final double size; // This will be the width

  const AppLogo({
    super.key,
    this.size = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/images/logo.png',
        width: screenWidth * size,
        fit: BoxFit.contain,
      ),
    );
  }
} 