import 'package:flutter/material.dart';
import 'package:muipzi/assets/assets.dart';
import 'package:muipzi/screens/home/main_content_card.dart';
import 'package:muipzi/screens/home/weather_info_card.dart';
import 'package:muipzi/theme/app_colors.dart';

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
                children: [
                  AppAssets.logoImage,
                  const Icon(
                    Icons.settings,
                    color: AppColors.gray700,
                    size: 24,
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: WeatherInfoCard(),
            ),
            MainContentCard(),
          ],
        ),
      ),
    );
  }
}
