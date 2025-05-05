import 'package:flutter/material.dart';
import 'package:muipzi/theme/app_colors.dart';

class LocationSearchScreen extends StatefulWidget {
  const LocationSearchScreen({super.key});

  @override
  State<LocationSearchScreen> createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Column(
            spacing: 24,
            children: [
              SizedBox(height: 20),
              //검색
              Row(
                spacing: 12,
                children: [
                  Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.gray700,
                    size: 28,
                  ),
                  Expanded(child: SearchBar()),
                ],
              ),
              //검색결과
            ],
          ),
        ),
      ),
    );
  }
}
