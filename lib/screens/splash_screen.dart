import 'package:flutter/material.dart';
import 'package:muipzi/assets/assets.dart';
import 'package:muipzi/screens/location_permission_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LocationPermissionScreen(),
        ),
      );
    });

    return Scaffold(body: Center(child: AppAssets.logoImage));
  }
}
