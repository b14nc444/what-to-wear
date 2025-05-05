import 'package:flutter/material.dart';
import 'package:muipzi/assets/assets.dart';
import 'package:muipzi/screens/home/main_content_container.dart';
import 'package:muipzi/screens/home/weather_info_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          spacing: 24,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [AppAssets.logoImage, AppAssets.settingsIcon],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: WeatherInfoCard(),
            ),
            MainContentContainer(),
          ],
        ),
      ),
    );
  }
}
