import 'dart:async';

import 'package:flutter/material.dart';
import 'package:muipzi/constants/assets.dart';
import 'package:muipzi/screens/home/temperature_row.dart';
import 'package:muipzi/theme/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeatherInfoCard extends StatefulWidget {
  const WeatherInfoCard({super.key});

  @override
  State<WeatherInfoCard> createState() => _WeatherInfoCardState();
}

class _WeatherInfoCardState extends State<WeatherInfoCard> {
  Timer? _timer;
  String _currentTime = '';
  String? _locationName;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _loadLocationName();
    // 1분마다 시간 업데이트
    _timer = Timer.periodic(const Duration(minutes: 1), (_) => _updateTime());
  }

  Future<void> _loadLocationName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _locationName = prefs.getString('selected_location_name') ?? '지역 없음';
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTime() {
    final now = DateTime.now();
    final hour = now.hour;
    final period = hour < 12 ? '오전' : '오후';
    final displayHour = hour == 12 ? 12 : hour % 12;
    setState(() {
      _currentTime = '$period $displayHour시';
    });
  }

  ShapeDecoration weatherInfoCardDecoration() {
    return ShapeDecoration(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      shadows: [
        BoxShadow(
          color: const Color(0x0F000000),
          blurRadius: 4,
          offset: const Offset(0, 2),
          spreadRadius: -1,
        ),
        BoxShadow(
          color: const Color(0x0F000000),
          blurRadius: 4,
          offset: const Offset(0, 2),
          spreadRadius: -1,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: weatherInfoCardDecoration(),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    '날씨',
                    style: TextStyle(
                      color: AppColors.gray950,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _currentTime,
                    style: const TextStyle(
                      color: AppColors.gray700,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: ShapeDecoration(
                  color: AppColors.gray50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  spacing: 6,
                  children: [
                    AppAssets.locationIcon,
                    Text(
                      _locationName ?? '',
                      style: const TextStyle(
                        color: AppColors.gray900,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const TemperatureRow(),
        ],
      ),
    );
  }
}
