import 'package:flutter/material.dart';
import 'package:muipzi/screens/home/temperature_row.dart';
import 'package:muipzi/theme/app_colors.dart';

class WeatherInfoCard extends StatelessWidget {
  const WeatherInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: ShapeDecoration(
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
      ),
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
                      color: Color(0xFF252527),
                      fontSize: 16,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    '오후 12시',
                    style: TextStyle(
                      color: Color(0xFF4D4C52),
                      fontSize: 12,
                      fontFamily: 'Pretendard',
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
                    const Icon(Icons.place_outlined, color: AppColors.gray700),
                    const Text(
                      '서울시 00구',
                      style: TextStyle(color: AppColors.gray900, fontSize: 12),
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
